<!-- font: frutiger -->

### Bayesian Learning

![](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/Images/BayesTheoremNeonBlack.jpg "Bayesian Learning")

---

### Contents

The course gives a solid introduction to Bayesian statistical inference, with special emphasis on models and methods in computational statistics and machine learning. 
* We will get off to a shocking start by introducing a very different probability concept than the one you are probably (:wink:) used to: subjective probability. 
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

The course schedule on TimeEdit is here: [Schedule](https://cloud.timeedit.net/su/web/stud1/s.html?tab=8&object=cevt_39757&type=courseevent&h=t).

---

### Computer labs

* The three computer labs are central to the course. Expect to allocate substantial time for each lab. Many of the exam questions will be computer based, so working on the labs will also help you with the exam.
* You are strongly encouraged to do the labs in R, but any programming language is ok to use.
* The labs should be done in **pairs** of students.
* Each lab report should be submitted as a PDF along with the .R file with code. Submission is done through [Athena](https://athena.itslearning.com/ContentArea/ContentArea.aspx?LocationID=7339&LocationType=1).
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

<img src="Misc/VillaniFotoMindre.jpg" width="100">\
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
Code: [Beta density](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/ManipBeta.R) | [Bernoulli model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/PriorPosteriorManipBern.R)\
Notebooks: [BernBeta.jl](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Notebooks/Julia/BernBeta.jl)

**Lecture 2 - Poisson model. Summarizing posteriors. Conjugate priors. Prior elicitation.**\
Reading: BDA Ch. 2.-2.9 | BL Ch. 2 and 4 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L2.pdf) \
Code: [One-parameter Gaussian model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/PriorPosteriorManipNormal.R)\
Notebooks: [eBayPoisson.ipynb](https://github.com/mattiasvillani/BayesLearnCourse/blob/master/Notebooks/Python/eBayPoisson.ipynb)

**Lecture 3 - Multi-parameter models. Marginalization. Monte Carlo simulation. Multinomial model.**\
Reading: BDA Ch. 3 | BL Ch. 3 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L3.pdf) \
Code: [Two-parameter Gaussian model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/NormalNonInfoPrior.R)\
Notebooks: [multinomial.Rmd](https://github.com/mattiasvillani/BayesLearnCourse/blob/master/Notebooks/R/multinomial.Rmd) |
[multinomial.jl](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Notebooks/Julia/BernBeta.jl)

**Lecture 4 - Linear Regression. Prediction. Making Decisions**\
Reading: BDA Ch. 14 and Ch. 20.1-20.2 | BL Ch. 5 and 6 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L4.pdf)  
Code: [Prediction with two-parameter Gaussian model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/PostAndPredIIDNormalNonInfoPrior.R)

**Lecture 5 - Classification. Large-sample properties and Posterior approximation.** \
Reading: BDA Ch. 16.1-16.3, 4.1-4.2 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L5.pdf) \
Notebook: [Normal approximation of posterior for logistic regression](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Notebooks/R/SpamOptim.Rmd) using the [spamdata](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Notebooks/R/SpamReduced.dat).

**Lecture 6 - Nonlinear regression and Classification. Regularization.**\
Reading: [Slides]() 

**Lecture 7 - Gibbs sampling and Data augmentation** \
Reading: BDA Ch. 10-11 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L7.pdf) \
Code: [Gibbs sampling for a bivariate normal](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/GibbsBivariateNormal.R) | [Gibbs sampling for a mixture of normals](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/NormalMixtureGibbs.R) \
Extra material: [Illustration](https://www.youtube.com/watch?v=IGiQOCX9UbM&ab_channel=Red15) of Gibbs sampling when parameters are strongly correlated.

**Lecture 8 - MCMC and Metropolis-Hastings** \
Reading: BDA Ch. 11 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L8.pdf) \
Code: [Simulating Markov Chains](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/SimulateDiscreteMarkovChain.R)

**Lecture 9 - HMC and Variational inference** \
Reading: BDA Ch. 12.4 and Ch. 13.7 | 

**Lecture 10 - Probabilistic programming for Bayesian learning**\
Reading: BDA Ch. X | [Slides]() [RStan vignette](https://cran.r-project.org/web/packages/rstan/vignettes/rstan.html) \
Code: [RStan - Three Plants](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/ThreePlants.R) | [RStan - Bernoulli model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/BernBetaRStan.R) | [RStan - Logistic regression](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/LogisticRegRStan.R) | [RStan - Logistic regression with random effects](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/LogisticRegRandEffectsRStan.R) | [RStan - Poisson model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/RoachesPoissonRStan.R)

**Lecture 11 - Bayesian model comparison**\
Reading: BDA Ch. 7 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L10.pdf) \
Code: [Comparing models for count data](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/MainGeoVsPois.R)

**Lecture 12 - Bayesian variable selection and model averaging**\
Reading: [Article](http://www-stat.wharton.upenn.edu/~edgeorge/Research_papers/GeorgeMcCulloch97.pdf) on Bayesian variable selection | [Slides]()

---

## Mathematical exercises
### Assistant: [Oscar Oelrich](https://www.su.se/english/profiles/ooelr-1.342298)

**Exercise session 1:** [Problem set](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/MathExercises/BLExercise1.pdf)

**Exercise session 2:** [Problem set](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/MathExercises/BLExercise2.pdf)

**Exercise session 3:** [Problem set](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/MathExercises/BLExercise3.pdf)

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


---

### R

* The main page with links to downloads for the [programming language R](https://www.r-project.org/)
* [RStudio](https://rstudio.com/products/rstudio/) - a very nice developing environment for R.
* Short introduction to R | A little [longer introduction](https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf) | John Cook's [intro to R for programmers](https://www.johndcook.com/blog/r_language_for_programmers/).

---

### Pluto Notebooks
As a bonus, I will occasionally post Notebooks where you can interactively play around with some Bayesian analyses. I will use a new type of notebook system called [Pluto](https://github.com/fonsp/Pluto.jl) in the [Julia](https://julialang.org/) programming language. The advantage of Pluto is that it is reactive: changing one variable in the notebook immediately updates the parts of the notebook that depend on the variable.

Here is what you need to do to access this bonus feature:
* [Download Julia](https://julialang.org/downloads/) and install it.
* Start up Julia to get the `julia>` prompt where you can type commands.
* Install and start Pluto by typing in the following commands at the `julia>` prompt
  ```
  using Pkg        # initializes the package manager
  Pkg.add("Pluto") # installs the Pluto package. 
  import Pluto     # loads the Pluto package.
  Pluto.run()      # Opens up Pluto in your browser (Firefox or Chrome)
  ```
* Open up a notebook file in the Pluto browser tab and start playing around by changing value in the cells. 
 
Note that the notebooks uses modules (like R packages) that you need to install (similar to how you have to install.packages() in R). So you have to do Pkg.add("NameOfPackage") to install each package at the Julia prompt. This is only done once. The first cell of the notebook shows the needed modules (look for the `using` and `import` statements). Here is for example what you need to install for running the BernBeta.jl notebook:

```
Pkg.add("Plots")           # The basic plotting module
Pkg.add("LaTeXStrings")    # The get LaTeX maths in plots
Pkg.add("Distributions")   # Module with probability distributions
Pkg.add("PlutoUI")         # A module with fancy sliders etc for Pluto
Pkg.add("ColorSchemes")    # Fancy colors for plotting
```

Julia is a very attractive programming language for numerical and statistical analysis. If you are curious and want to use if for more than Notebooks, I suggest downloading the fantastic editor [VS Code](https://code.visualstudio.com/) and the [Julia for VS Code](https://www.julia-vscode.org/) extension that turns VS Code into an RStudio-like experience for Julia.

Here is an animated GIF to give you a feel for how it works for the Bernoulli model:

![Bernoulli notebook](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Extras/BernPluto.gif "Bernoulli notebook")

---
