<!-- font: frutiger -->

### Bayesian Learning

![](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/Images/BayesTheoremNeonBlack.jpg "Bayesian Learning")

---

### Contents

The course gives a solid introduction to Bayesian statistical inference, with special emphasis on models and methods in computational statistics and machine learning. 
* We will get off to a shocking start by introducing a very different probability concept than the one you are probably used to: subjective probability. 
* We will then move on to the mathematics of the prior-to-posterior updating in basic statistical models, such as the Bernoulli, normal and multinomial models. 
* Bayesian prediction and decision making under uncertainty is carefully explained, and you will hopefully see why Bayesian methods are so useful in modern application where so much focuses on prediction and decision making. 
* The really interesting stuff starts to happen when we study regression and classification. You will learn how prior distributions can be seen as regularization that allows us to use flexible models with many parameters without overfitting the data and improving predictive performance. 
* A new world will open up when we learn how complex models can be analyzed with simulation methods like Markov Chain Monte Carlo (MCMC), Hamiltonian Monte Carlo (HMC) and approximate optimization methods like Variational Inference (VI).
* You will also get a taste for probabilistic programming languages for Bayesian learning, in particular the popular Stan language in R. 
* Finally, we'll round off with an introduction to Bayesian model selection and Bayesian variable selection.

---

### Course literature and Schedule

The course will use the following book as the main course literature:

* Gelman, Carlin, Stern, Dunson, Vehtari, Rubin (2014).
Bayesian Data Analysis (BDA). Chapman & Hall/CRC: Boca Raton, Florida. 3rd edition. Here is the [book webpage](http://www.stat.columbia.edu/~gelman/book/) and PDF.
* Villani, M. (2020). Bayesian Learning (BL). First chapters of a book that I am writing is [here](https://github.com/mattiasvillani/BayesianLearningBook/raw/main/pdf/BayesBook.pdf). This is a very rough version with lots of typos, but may be useful as a complement to Gelman et al.
* Additional course material linked from this page, such as articles and tutorial.

The course schedule on TimeEdit is here: [Schedule](https://cloud.timeedit.net/su/web/stud1/s.html?tab=8&object=cevt_39769&type=courseevent&h=t).

---

### Computer labs

* The three computer labs are central to the course. Expect to allocate substantial time for each lab. Many of the exam questions will be computer based, so working on the labs will also help you with the exam.
* You are strongly encouraged to do the labs in R, but any programming language is ok to use.
* The labs should be done in **pairs** of students.
* Each lab report should be submitted as a PDF along with the .R file with code. Submission is done through [Athena](https://athena.itslearning.com/ContentArea/ContentArea.aspx?LocationID=9595&LocationType=1).
* There is only two hours of supervised time allocated to each lab. The idea is that you:
  *  should start working on the lab before the computer session
  *  so that you are in a position to ask questions at the session
  *  and then finish up the report after the lab session.

* The datasets used in the labs are included in the **BayesLearnSU** R package which is available on github. To install it, you first need to install the devtools package.
```
# To install and load the package with the data
install.packages("devtools") # only one time
library(devtools)  
install_github("ooelrich/BayesLearnSU") # only one time
library(BayesLearnSU)

# For general information about the package
help("BayesLearnSU")

# For a list of all available data sets
help(, "BayesLearnSU")

# For information about specific data sets
help(name_of_dataset)
```
---

### Teachers

<img src="Misc/VillaniLowRes.jpg" width="100">\
[Mattias Villani](https://mattiasvillani.com), Lecturer \
Professor, Natural Born Bayesian :stuck_out_tongue_winking_eye: \
Department of Statistics, Stockholm University \
Division of Statistics and Machine Learning, Linköping University

<img src="Misc/Oscar.jpg" width="100">\
[Oscar Oelrich](https://www.su.se/english/profiles/ooelr-1.342298), Math exercises and Computer labs \
PhD Candidate, specializing in Bayesian Statistics \
Department of Statistics, Stockholm University

---
## Lectures
### Lecturer: [Mattias Villani](https://mattiasvillani.com)



**Lecture 1 - Subjective probability. Bayesian updating. Bernoulli model. Gaussian model.**\
Reading: BDA Ch. 1, 2.1-2.4 |  BL Ch. 1-2, 4 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L1.pdf) \
Notebooks: [Analyzing email spam data with a Bernoulli model](https://github.com/mattiasvillani/BayesianLearningBook/tree/main/notebooks/SpamBern) | 
[Analyzing internet download speeds with a Gaussian model](https://github.com/mattiasvillani/BayesianLearningBook/tree/main/notebooks/DownloadSpeedNormal)

**Lecture 2 - Poisson model. Summarizing posteriors. Conjugate priors. Prior elicitation.**\
Reading: BDA Ch. 2.-2.9 | BL Ch. 2 and 4 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L2.pdf) \
Notebooks: [Analyzing number of eBay bidders with an iid Poisson model](https://github.com/mattiasvillani/BayesianLearningBook/tree/main/notebooks/ebayPoissonOneParam)

**Lecture 3 - Multi-parameter models. Marginalization. Monte Carlo simulation. Multinomial model.**\
Reading: BDA Ch. 3 | BL Ch. 3 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L3.pdf) \
Notebooks: [Analyzing mobile phone survey data with a multinomial model](https://github.com/mattiasvillani/BayesianLearningBook/tree/main/notebooks/SurveyMultinomial)

**Lecture 4 - Linear Regression. Prediction. Making Decisions**\
Reading: BDA Ch. 14, Ch. 9.1-9.2 | BL Ch. 5 and 6 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L4.pdf)  
Code: [Prediction with two-parameter Gaussian model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/PostAndPredIIDNormalNonInfoPrior.R)

**Lecture 5 - Classification. Large-sample properties and Posterior approximation.** \
Reading: BDA Ch. 16.1-16.3, 4.1-4.2 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L5.pdf) \
Notebook: [Normal approximation of posterior for logistic regression](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Notebooks/R/SpamOptim.Rmd) 

**Lecture 6 - Nonlinear regression and Classification. Regularization.**\
Reading: BDA Ch. 20.1-20.2 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L6.pdf) 

**Lecture 7 - Gibbs sampling and Data augmentation** \
Reading: BDA Ch. 10-11 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L7.pdf) \
Code: [Gibbs sampling for a bivariate normal](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/GibbsBivariateNormal.R) | [Gibbs sampling for a mixture of normals](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/NormalMixtureGibbs.R) \
Extra material: [Illustration](https://www.youtube.com/watch?v=IGiQOCX9UbM&ab_channel=Red15) of Gibbs sampling when parameters are strongly correlated.

**Lecture 8 - MCMC and Metropolis-Hastings** \
Reading: BDA Ch. 11 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L8.pdf) \
Code: [Simulating Markov Chains](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/SimulateDiscreteMarkovChain.R)

**Lecture 9 - HMC and Variational inference** \
Reading: BDA Ch. 12.4 and Ch. 13.7 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L9.pdf)

**Lecture 10 - Probabilistic programming for Bayesian learning**\
Reading: [RStan vignette](https://cran.r-project.org/web/packages/rstan/vignettes/rstan.html) | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L10new.pdf) \
RStan Code: [Bernoulli](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/BernBetaRStan.R) | [Normal model](https://github.com/mattiasvillani/BayesianLearningBook/raw/main/ppl/Stan/normalStan.R) | [Logistic regression](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/LogisticRegRStan.R) | [Logistic regression with random effects](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/LogisticRegRandEffectsRStan.R) | [Poisson model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/RoachesPoissonRStan.R) | [Three plants data](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/ThreePlants.R)\
Turing code (Julia): [Bernoulli model](https://github.com/mattiasvillani/BayesianLearningBook/raw/main/ppl/Turing/BernTuring.jl) | [Normal model](https://github.com/mattiasvillani/BayesianLearningBook/raw/main/ppl/Turing/NormalTuring.jl)

**Lecture 11 - Bayesian model comparison**\
Reading: BDA Ch. 7 | BL Ch. 11 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L11.pdf) \
Code: [Comparing models for count data](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/MainGeoVsPois.R)

**Lecture 12 - Bayesian variable selection and model averaging**\
Reading: [Article](http://www-stat.wharton.upenn.edu/~edgeorge/Research_papers/GeorgeMcCulloch97.pdf) on Bayesian variable selection | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L12.pdf)

---

## Mathematical exercises
### Assistant: [Oscar Oelrich](https://www.su.se/english/profiles/ooelr-1.342298)

**Exercise session 1:** [Problem set](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/MathExercises/BLExercise1.pdf)

**Exercise session 2:** [Problem set](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/MathExercises/BLExercise2.pdf)

---
## Computer labs
### Assistant: [Oscar Oelrich](https://www.su.se/english/profiles/ooelr-1.342298)
**Computer Lab 1** - Exploring posterior distributions in one-parameter models by simulation and direct numerical evaluation.\
Lab: [Lab 1](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/Lab1.pdf) \
Submission: [Athena]().

**Computer Lab 2** - Polynomial regression and classification with logistic regression.\
Lab: [Lab 2](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/Lab2.pdf) | [Temp in Linköping dataset](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/TempLinkoping.txt) | [WomenWork dataset](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/WomenWork.dat)\
Submission: [Athena]().

**Computer Lab 3** - Gibbs sampling, Metropolis-Hastings and Stan. \
Lab: [Lab 3](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/Lab3.pdf) | [Rainfall dataset](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/rainfall.dat) | [eBay dataset](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/eBayNumberOfBidderData.dat) | [How to code](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/HowToCodeRWM.pdf) up Random Walk Metropolis | [campylobacter dataset](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/campy.dat)\
Submission: [Athena]().

---

### Examination

The course examination consists of:

* Written lab reports (deadlines given in Athena)
* Take home exam (first exam on Jan 15)

[Here](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/OldExamsLiU/) are some past exams with solutions from a similar course that I have given at Linköping University. **Note** however that although the course contents are very similar that course had only a 4 hour exam in a computer room without internet access. You have more time and the internet available (from which you **cannot** copy or ask questions though) so your exam will be somewhat different.


---

### R

* The main page with links to downloads for the [programming language R](https://www.r-project.org/)
* [RStudio](https://rstudio.com/products/rstudio/) - a very nice developing environment for R.
* [An introduction to R](https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf) | John Cook's [intro to R for programmers](https://www.johndcook.com/blog/r_language_for_programmers/) | [R cheat sheet](https://rstudio.com/wp-content/uploads/2016/10/r-cheat-sheet-3.pdf) .

---

### Pluto Notebooks
As a bonus, I will occasionally post notebooks from a new notebook system called [Pluto](https://github.com/fonsp/Pluto.jl) in the [Julia](https://julialang.org/) programming language. The advantage of Pluto is that it is reactive: changing one variable in the notebook immediately updates the parts of the notebook that depend on the variable.
Here are some instructions for how you can get started with Pluto Notebooks: 
[Pluto instructions](https://gist.github.com/mattiasvillani/73c7a26bfc7c82d2fb35dbbb31f38945)

---

### Bayes was a cool dude

<a href="http://www.youtube.com/watch?v=8ErvD90-BUU" target="_blank">
 <img src="http://img.youtube.com/vi/8ErvD90-BUU/0.jpg" alt="Click to watch on youtube" width="240" height="180" border="10" />
</a>
