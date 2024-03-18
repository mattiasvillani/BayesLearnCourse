<!-- font: frutiger -->

# Bayesian Learning, 7.5 credits

<img src="Misc/linocut_blsu.png" alt="drawing" style="width:200px;"/><img src="Misc/linocut_blsu.png" alt="drawing" style="width:200px;"/>

---

### Contents

The course gives a gentle but solid introduction to Bayesian statistical inference, with special emphasis on models and methods in computational statistics and machine learning. 
* We will get off to a shocking start by introducing a very different probability concept than the one you are probably used to: **subjective probability**. 
* We will then move on to the mathematics of the **prior-to-posterior updating in basic statistical models**, such as the Bernoulli, normal and multinomial models. 
* **Bayesian prediction** and **decision making under uncertainty** is carefully explained, and you will hopefully see why Bayesian methods are so useful in modern application where so much focuses on prediction and decision making. 
* The really interesting stuff starts to happen when we study **regression** and **classification**. You will learn how prior distributions can be seen as regularization that allows us to use flexible models with many parameters without overfitting the data and improving predictive performance. 
* A new world will open up when we learn how complex models can be analyzed with **simulation methods** like Markov Chain Monte Carlo (MCMC), Hamiltonian Monte Carlo (HMC) and **approximate optimization methods** like Variational Inference (VI).
* You will also get a taste for **probabilistic programming languages** for Bayesian learning, in particular the popular Stan language in R. 
* Finally, we'll round off with an introduction to Bayesian model selection and Bayesian variable selection.

---

### Course literature and Schedule

The course will use the following book as the main course literature:

* Gelman, Carlin, Stern, Dunson, Vehtari, Rubin (2014).
Bayesian Data Analysis (BDA). Chapman & Hall/CRC: Boca Raton, Florida. 3rd edition. Here is the [book webpage](http://www.stat.columbia.edu/~gelman/book/) and a free [PDF version](http://www.stat.columbia.edu/~gelman/book/BDA3.pdf).
* Villani, M. (2022). Bayesian Learning (BL). Approximately half of a book that I am writing is [here](https://github.com/mattiasvillani/BayesianLearningBook/raw/main/pdf/BayesBook.pdf). This is work in progress, but currently covers L1-L7 and L11. 
* Additional course material linked from this page, such as articles and tutorial.

The course schedule on TimeEdit is here: [Schedule](https://cloud.timeedit.net/su/web/stud1/s.html?tab=3&object=cevt_39946_VT2024&startDate=20240217&endDate=20240803&type=courseevent&h=t).

Some of the Lectures are pre-recorded (see the Schedule on TimeEdit), partly to make room for the discussion seminars. The recorded lectures are hosted on Athena in a folder called "Videos". See the file **videos** in the Resources at [Athena](https://athena.itslearning.com/ContentArea/ContentArea.aspx?LocationID=22499&LocationType=1) for a lists of the videos, and the order in which they should be viewed.

---

### Computer labs

* The three computer labs are central to the course. Expect to allocate substantial time for each lab, not just the scheduled time for computer exercises. Many of the exam questions will be computer based, so working on the labs will also help you with the exam.
* The labs should be done in R, since only R is available at the computer exam and your lab solutions will be available for you at the exam.
* The labs should be done in **pairs** of students.
* Each lab report should be submitted as a PDF along with the .R file with code. Submission is done through [Athena](https://athena.itslearning.com/ContentArea/ContentArea.aspx?LocationID=18147&LocationType=1).
* There is only two hours of supervised time allocated to each lab. The idea is that you:
  *  should start working on the lab before the computer session
  *  so that you are in a position to ask questions at the session
  *  and then finish up the report after the lab session.

* The datasets used in the labs are included in the `SUdatasets` R package which is available on github. There is also a course package `bayeslearn` with some distributions and functions for regression, logistic regression etc. To install the packages, you first need to install the `remotes` package.
```
# To install and load the package with the data
install.packages("remotes") # only one time
library(remotes)  
install_github("StatisticsSU/SUdatasets") # only one time
library(SUdatasets)
install_github("StatisticsSU/bayeslearn") # only one time
library(bayeslearn)

# For a list of all available data sets
help(, "SUdatasets")

# For information about specific data sets
help(name_of_dataset)
```
---

### Teachers

<img src="Misc/VillaniLowRes.jpg" width="100">\
[Mattias Villani](https://mattiasvillani.com), Lecturer \
Professor, Natural Born Bayesian :stuck_out_tongue_winking_eye: \
Department of Statistics, Stockholm University \

<img src="Misc/Oscar.jpg" width="100">\
[Oscar Oelrich](https://www.su.se/english/profiles/ooelr-1.342298), Math exercises and Computer labs \
PhD in Statistics, specializing in Bayesian Statistics \
Department of Statistics, Stockholm University

---
## Lectures
### Lecturer: [Mattias Villani](https://mattiasvillani.com)



**Lecture 1 - Subjective probability. Bayesian updating. Bernoulli model. Gaussian model.**\
Reading: BDA Ch. 1, 2.1-2.4 |  BL Ch. 1-2, 4 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L1.pdf) \
Notebooks: [Analyzing email spam data with a Bernoulli model](https://github.com/mattiasvillani/BayesianLearningBook/tree/main/notebooks/SpamBern) | 
[Analyzing internet download speeds with a Gaussian model](https://github.com/mattiasvillani/BayesianLearningBook/tree/main/notebooks/DownloadSpeedNormal)\
Widgets: [gaussian known variance](https://mattiasvillani.com/BayesianLearningBook/observable/gaussian_knownvariance.html) | [bayesian updating - widget](https://mattiasvillani.com/BayesianLearningBook/observable/gaussian_knownvariance_sequential.html)

**Lecture 2 - Poisson model. Summarizing posteriors. Conjugate priors. Prior elicitation.**\
Reading: BDA Ch. 2.-2.9 | BL Ch. 2 and 4 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L2.pdf) \
Notebooks: [Analyzing number of eBay bidders with an iid Poisson model](https://github.com/mattiasvillani/BayesianLearningBook/tree/main/notebooks/ebayPoissonOneParam)\
Widget: [Autoregressive processes](https://observablehq.com/@mattiasvillani/ar-processes)

**Lecture 3 - Multi-parameter models. Marginalization. Monte Carlo simulation. Multinomial model.**\
Reading: BDA Ch. 3 | BL Ch. 3 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L3.pdf) \
Notebooks: [Analyzing mobile phone survey data with a multinomial model](https://github.com/mattiasvillani/BayesianLearningBook/tree/main/notebooks/SurveyMultinomial)

**Lecture 4 - Linear Regression. Prediction. Making Decisions**\
Reading: BDA Ch. 14, Ch. 9.1-9.2 | BL Ch. 5 and 6 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L4.pdf)\  
Code: [Prediction with two-parameter Gaussian model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/PostAndPredIIDNormalNonInfoPrior.R)\
Widgets: [linear regression](https://mattiasvillani.com/BayesianLearningBook/observable/bike_lin_reg.html) | [prediction iid Gaussian](https://mattiasvillani.com/BayesianLearningBook/observable/pred_gaussian_knownvariance.html)

**Lecture 5 - Classification. Large-sample properties and Posterior approximation.** \
Reading: BDA Ch. 16.1-16.3, 4.1-4.2 | BL 7-8 and appendix on Taylor approximations  | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L5.pdf) \
Notebook: [Logistic regression](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Notebooks/R/SpamOptim.qmd) \
Code:  [bayeslearn package - Logistic and Probit regression for Titanic data](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/binary_reg_script.R) \
Extras: [Video on Taylor approximation](https://youtu.be/3d6DsjIBzJ4)

**Lecture 6 - Nonlinear regression and Classification. Regularization.**\
Reading: BDA Ch. 20.1-20.2 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L6.pdf) 

**Lecture 7 - Gibbs sampling and Data augmentation** \
Reading: BDA Ch. 10-11 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L7.pdf) \
Code: [Gibbs sampling for a bivariate normal](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/GibbsBivariateNormal.R) | [Gibbs sampling for a mixture of normals](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/NormalMixtureGibbs.R) \
Widget: [mixture of normals](https://observablehq.com/@mattiasvillani/normal-mixture) \
Extras: [Illustration](https://www.youtube.com/watch?v=IGiQOCX9UbM&ab_channel=Red15) of Gibbs sampling when parameters are strongly correlated.

**Lecture 8 - MCMC and Metropolis-Hastings** \
Reading: BDA Ch. 11 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L8.pdf) \
Code: [Simulating Markov Chains](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/SimulateDiscreteMarkovChain.R)

**Lecture 9 - HMC and Variational inference** \
Reading: BDA Ch. 12.4 and Ch. 13.7 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L9.pdf) \
Extras: [HMC animations](http://arogozhnikov.github.io/2016/12/19/markov_chain_monte_carlo.html) | [HarlMCMC shake](https://www.youtube.com/watch?v=Vv3f0QNWvWQ&ab_channel=DavidDuvenaud) | [visual explantion of HMC algorithm tuning](https://colcarroll.github.io/mcmc-adapt/) | [Radford Neal's handbook chapter on HMC](https://arxiv.org/pdf/1206.1901.pdf)

**Lecture 10 - Probabilistic programming for Bayesian learning**\
Reading: [RStan vignette](https://cran.r-project.org/web/packages/rstan/vignettes/rstan.html) | [Linear regression in RStan](https://mc-stan.org/docs/2_26/stan-users-guide/linear-regression.html) |  [Prediction in RStan](https://mc-stan.org/docs/2_26/stan-users-guide/prediction-forecasting-and-backcasting.html) | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L10new.pdf) \
RStan Code: [Bernoulli](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/BernBetaRStan.R) | [Normal model](https://github.com/mattiasvillani/BayesianLearningBook/raw/main/ppl/Stan/normalStan.R) | [Logistic regression](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/LogisticRegRStan.R) | [Logistic regression with random effects](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/LogisticRegRandEffectsRStan.R) | [Poisson model](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/RoachesPoissonRStan.R) | [Three plants data](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Code/RStanCode/Code/ThreePlants.R) \
Turing code (Julia): [Bernoulli model](https://github.com/mattiasvillani/BayesianLearningBook/raw/main/ppl/Turing/BernTuring.jl) | [Normal model](https://github.com/mattiasvillani/BayesianLearningBook/raw/main/ppl/Turing/NormalTuring.jl)

**Lecture 11 - Bayesian model comparison**\
Reading: BDA Ch. 7 | BL Ch. 12 | [Slides](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Slides/BL_L11.pdf) \
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
Lab: [Lab 1](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/Lab1/Lab1.pdf) \
Submission: [Athena](https://athena.itslearning.com/ContentArea/ContentArea.aspx?LocationID=18147&LocationType=1).

**Computer Lab 2** - Polynomial regression and classification with logistic regression.\
Lab: [Lab 2](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/Lab2/Lab2.pdf)\
Submission: [Athena](https://athena.itslearning.com/ContentArea/ContentArea.aspx?LocationID=18147&LocationType=1).

**Computer Lab 3** - Gibbs sampling, Metropolis-Hastings and Stan. \
Lab: [Lab 3](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/Lab3/Lab3.pdf) | [Note on how to code R functions which take functions as arguments](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/Labs/HowToCodeRWM.pdf)\
Submission: [Athena](https://athena.itslearning.com/ContentArea/ContentArea.aspx?LocationID=18147&LocationType=1).

---

### Examination

The course examination consists of:

* Written lab reports (deadlines given in Athena)
* Exam (pen and paper + computer)

The written exam will be in a room with computer access and R will be installed.
Roughly 1/4 of the exam will be pen-and-paper math problems, and 3/4 computer based problems. 
You will be given the opportunity to submit your lab solutions as a PDF so that they will be available to you during the exam. The uploaded lab solutions can be polished, but are only allowed to contain material related to the lab solutions. The uploaded lab solutions will be screened before the exam. 
You will also have the following PDF with distributions available during the exam [Distributions from BDA3](/OldExamsSU/DistributionsBDA.pdf).

Some old exams with solutions:

- [Old exams](https://github.com/mattiasvillani/BayesLearnCourse/raw/master/OldExamsSU/)



---

### R 

* The main page with links to downloads for the [programming language R](https://www.r-project.org/)
* [RStudio](https://rstudio.com/products/rstudio/) - a very nice developing environment for R.
* [An introduction to R](https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf) | John Cook's [intro to R for programmers](https://www.johndcook.com/blog/r_language_for_programmers/) | [base-R cheat sheet](https://github.com/rstudio/cheatsheets/raw/main/base-r.pdf) .

