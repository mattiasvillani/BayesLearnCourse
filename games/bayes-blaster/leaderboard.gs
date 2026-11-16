/* Bayes Blaster leaderboards: Google Apps Script backend.

   SETUP (once)
   1. Create a Google Sheet. Rename the first tab to  Config  and put this in it:
          A1: year    B1: password
          A2: 2026    B2: <the password you give that year's class>
      Add one row per year. The tabs with scores (2026, 2027, ...) are created
      automatically the first time a student saves a score.
   2. In the Sheet: Extensions > Apps Script. Replace the code with this file. Save.
   3. Deploy > New deployment > type "Web app".
          Execute as:      Me
          Who has access:  Anyone
      Click Deploy, approve the permissions, and copy the Web app URL
      (it ends in /exec). Paste it into BOARD_URL in index.html.
   4. If you change this script later: Deploy > Manage deployments > edit (pencil)
      > Version: New version > Deploy. The URL stays the same.

   Course students (year + password) are saved in that year's tab; players
   without a year and password are saved in the  Guests  tab (created
   automatically). Each player has one row per tab, holding their best score;
   a new game only overwrites it when it beats that score. Delete a row to
   remove a bogus score.

   Reading the leaderboard needs no password: "all" combines every tab except
   Config, or a single year (tab name) can be shown. New year tabs are picked
   up automatically.
*/

const MAX_SCORE = 100000;   // well above what a full run through all 12 lectures can give
const N_LEVELS = 12;
const SPEEDS = ["Slow", "Medium", "Fast"];
const TOP_N = 25;
const GUESTS = "Guests";
const MAX_GUEST_ROWS = 3000;   // stops anyone from filling the Guests tab without limit

function doGet() {
  return out({ ok: true, msg: "Bayes Blaster leaderboard is running." });
}

function doPost(e) {
  let req;
  try { req = JSON.parse(e.postData.contents); } catch (err) { return out({ ok: false, error: "bad_request" }); }
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const year = String(req.year || "").trim();

  // public: no password needed to look at the leaderboard
  if (req.action === "board") return out({ ok: true, rows: board(ss, String(req.show || "all").trim()) });

  // no year and no password: a guest
  const guest = !year && !String(req.password || "").trim();
  if (!guest && !checkPassword(ss, year, req.password)) return out({ ok: false, error: "auth" });
  if (req.action === "verify") return out({ ok: true });
  if (req.action === "submit") return submit(ss, guest ? GUESTS : year, req);
  return out({ ok: false, error: "bad_request" });
}

function checkPassword(ss, year, password) {
  if (!year || ["config", GUESTS.toLowerCase()].indexOf(year.toLowerCase()) >= 0) return false;
  const cfg = ss.getSheetByName("Config");
  if (!cfg) return false;
  const rows = cfg.getDataRange().getDisplayValues();
  for (let i = 1; i < rows.length; i++) {
    if (String(rows[i][0]).trim() === year && String(rows[i][1]).trim() !== "" &&
        String(rows[i][1]).trim() === String(password || "").trim()) return true;
  }
  return false;
}

function cleanName(s) {
  return Array.from(String(s || "").replace(/[^\p{L}\p{N} _-]/gu, "").replace(/^[\s_-]+/, ""))
    .slice(0, 12).join("").trim();
}

function int(x, lo, hi) {
  const v = Math.floor(Number(x));
  return isFinite(v) && v >= lo && v <= hi ? v : null;
}

function submit(ss, year, req) {
  const name = cleanName(req.name);
  const score = int(req.score, 0, MAX_SCORE);
  const level = int(req.level, 0, N_LEVELS - 1);
  const ghosts = int(req.ghosts, 0, 1000);
  const speed = SPEEDS.indexOf(req.speed) >= 0 ? req.speed : "";
  if (!name || score === null || level === null || ghosts === null) return out({ ok: false, error: "bad_score" });

  const lock = LockService.getScriptLock();
  lock.waitLock(10000);
  try {
    let sh = ss.getSheetByName(year);
    if (!sh) {
      sh = ss.insertSheet(year);
      sh.appendRow(["Time", "Name", "Score", "Lecture", "Speed", "Ghosts"]);
      sh.setFrozenRows(1);
      sh.getRange("B:B").setNumberFormat("@");   // names are always text
    }
    // one row per player: overwrite it only when the new score beats the old best
    const row = [new Date(), name, score, level, speed, ghosts];
    const n = sh.getLastRow() - 1;
    const names = n > 0 ? sh.getRange(2, 2, n, 2).getValues() : [];
    const key = name.toLowerCase();
    let at = -1, best = -1;
    for (let i = 0; i < names.length; i++) {
      if (cleanName(names[i][0]).toLowerCase() === key && Number(names[i][1]) > best) { at = i; best = Number(names[i][1]); }
    }
    if (at < 0) {
      if (year === GUESTS && n >= MAX_GUEST_ROWS) return out({ ok: false, error: "full" });
      sh.appendRow(row); return out({ ok: true, best: true });
    }
    if (score <= best) return out({ ok: true, best: false, previous: best });
    sh.getRange(at + 2, 1, 1, 6).setValues([row]);
    return out({ ok: true, best: true, previous: best });
  } finally {
    lock.releaseLock();
  }
}

// show = "all" (every tab except Config) or one tab name, e.g. "2026" or "Guests"
function board(ss, show) {
  const tabs = ss.getSheets().map(sh => sh.getName()).filter(n => n !== "Config");
  const want = show.toLowerCase() === "all" ? tabs : tabs.filter(n => n.toLowerCase() === show.toLowerCase());
  const best = {};
  for (const tab of want) {
    const sh = ss.getSheetByName(tab);
    if (!sh || sh.getLastRow() < 2) continue;
    const rows = sh.getRange(2, 1, sh.getLastRow() - 1, 6).getValues();
    for (const r of rows) {
      const name = cleanName(r[1]);
      const score = Number(r[2]);
      if (!name || !isFinite(score)) continue;
      const key = tab + "|" + name.toLowerCase();
      if (!best[key] || score > best[key].score)
        best[key] = { name: name, year: tab === GUESTS ? "Guest" : tab, score: score,
                      level: Number(r[3]) || 0, speed: String(r[4] || ""), ghosts: Number(r[5]) || 0 };
    }
  }
  return Object.keys(best).map(k => best[k]).sort((a, b) => b.score - a.score).slice(0, TOP_N);
}

function out(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(ContentService.MimeType.JSON);
}
