\name{estimate.ATE}
\Rdversion{1.1}
\alias{estimate.ATE}

\title{
Estimate Population Average Treatment Effects (ATE) Using Generalized Additive Models} 

\description{
This function implements three estimators for the population ATE--- a regression estimator, an inverse propensity weighted (IPW) estimator, and an augmented inverse propensity weighted (AIPW) estimator--- using generalized additive models. 
}
\usage{
estimate.ATE(pscore.formula, pscore.family,
             outcome.formula.t, outcome.formula.c, outcome.family, 
             treatment.var, data = NULL, 
             divby0.action = c("fail", "truncate", "discard"), 
             divby0.tol = 1e-08, nboot = 501, 
             variance.smooth.deg = 1, variance.smooth.span = 0.75, 
             var.gam.plot = TRUE, suppress.warnings = TRUE, ...)
}

\arguments{
  \item{pscore.formula}{
  A formula expression for the propensity score model. See the documentation of \code{gam} for details. 
}
  \item{pscore.family}{
  A description of the error distribution and link function to be used for the propensity score model. See the documentation of \code{gam} for details.
}
  \item{outcome.formula.t}{
  A formula expression for the outcome model under active treatment. See the documentation of \code{gam} for details. 
}
  \item{outcome.formula.c}{
  A formula expression for the outcome model under control. See the documentation of \code{gam} for details. 
}
  \item{outcome.family}{
  A description of the error distribution and link function to be used for the outcome models. See the documentation of \code{gam} for details.
}
  \item{treatment.var}{
  A character variable giving the name of the binary treatment variable in \code{data}. If \code{treatment.var} is a numeric variable, it is assumed that \emph{control} corresponds to \code{sort(unique(treatment.values))[1]} and \emph{treatment} corresponds to \code{sort(unique(treatment.values))[2]}. If \code{treatment.var} is a factor, it is assumed that \emph{control} corresponds to \code{levels(treatment.values)[1]} and \emph{treatment} corresponds to \code{levels(treatment.values)[2]}.
}
  \item{data}{
  A \emph{non-optional} data frame containing the variables in the model. \strong{\code{data} cannot contain any missing values.}   
}
  \item{divby0.action}{
  A character variable describing what action to take when some estimated propensity scores are less than \code{divby0.tol} or greater than \eqn{1 - \code{divby0.tol}}. Options include: \samp{fail} (abort the call to \code{estimate.ATE}), \samp{truncate} (set all estimated propensity scores less than \code{divby0.tol} equal to \code{divby0.tol} and all estimated propensity scores greater than \eqn{1 - \code{divby0.tol}} equal to \eqn{1 - \code{divby0.tol}}), and \samp{discard} (discard units that have estimate propensity scores less than \code{divby0.tol} or greater than \eqn{1 - \code{divby0.tol}}). Note that discarding units will change the estimand.   
}
  \item{divby0.tol}{
  A scalar in \eqn{[0,0.5)} giving the tolerance level for extreme propensity scores. Defaults to \eqn{1e-8}. See \code{divby0.action} for details. 
}
  \item{nboot}{
  Number of bootrap replications used for calculating bootstrap standard errors. If \code{nboot} is less than or equal to 0 then bootstrap standard errors are not calculated. Defaults to 501. 	
}
  \item{variance.smooth.deg}{
  The degree of the loess smooth used to calculate the conditional error variance of the outcome models given the estimated propensity scores. Possible values are \eqn{0}, \eqn{1}, or \eqn{2}. Defaults to \eqn{1}. If set to a value less than 0 than the conditional error variance will not be calculated and the estimated asymptotic standard errors will not be reported. See \code{lo} for details.  
}
  \item{variance.smooth.span}{
  The span of the loess smooth used to calculate the conditional error variance of the outcome models given the estimated propensity scores. Defaults to \eqn{10.75}. If set to a value less than or equal to 0 than the conditional error variance will not be calculated and the estimated asymptotic standard errors will not be reported.See \code{lo} for details.
}
  \item{var.gam.plot}{
  Logical value indicating whether the estimated conditional variances should be plotted against the estimated propensity scores. Setting \code{var.gam.plot} to \code{TRUE} is useful for judging whether \code{variance.smooth.deg} and \code{variance.smooth.span} were set appropriately. Defaults to \code{TRUE}.
}
  \item{suppress.warnings}{
 Logical value indicating whether warnings from the \code{gam} fitting procedures should be suppressed from printing to the screen. Defaults to \code{TRUE}. 
}
  \item{\dots}{
  Further arguments to be passed.
}
}


\details{
The three estimators implemented by this function are a regression estimator, an IPW estimator with weights normalized to sum to 1, and an AIPW estimator. Glynn and Quinn (2010) provides details regarding how each of these estimators are implemented. The AIPW estimator requires the specification of both a propensity score model governing treatment assignment and outcome models that describe the conditional expectation of the outcome variable given measured confounders and treatment status. The AIPW estimator has the so-called double robustness property. This means that if either the propensity score model or the outcomes models are correctly specified then the estimator is consistent for ATE.

Standard errors for the regression and IPW estimators can be calculated by either the bootstrap or by estimating the large sample standard errors. The latter approach requires estimation of the conditional variance of the disturbances in the outcome models given the propensity scores (see section IV of Imbens (2004) for details). The accuracy of these standard errors is only as good as one's estimates of these conditional variances. 

Standard errors for the AIPW estimator can be calculated similarly. In addition, Lunceford and Davidian (2004) also discuss an empirical sandwich estimator of the sampling variance which is also implemented here.  
}


\value{
An object of class \code{CausalGAM} with the following attributes: 
  \item{ATE.AIPW.hat }{AIPW estimate of ATE.}
  \item{ATE.reg.hat }{Regression estimate of ATE.}
  \item{ATE.IPW.hat }{IPW estimate of ATE.}
  \item{ATE.AIPWsand.SE }{Empirical sandwich standard error for \code{ATE.AIPW.hat}.}
  \item{ATE.AIPW.asymp.SE }{Estimated asymptotic standard error for \code{ATE.AIPW.hat}.}
  \item{ATE.reg.asymp.SE }{Estimated asymptotic standard error for \code{ATE.reg.hat}.}
  \item{ATE.IPW.asymp.SE }{Estimated asymptotic standard error for \code{ATE.IPW.hat}.}
  \item{ATE.AIPW.bs.SE }{Estimated bootstrap standard error for \code{ATE.AIPW.hat}.}
  \item{ATE.reg.bs.SE }{Estimated bootstrap standard error for \code{ATE.reg.hat}.}
  \item{ATE.IPW.bs.SE }{Estimated bootstrap standard error for \code{ATE.IPW.hat}.}
  \item{ATE.AIPW.bs }{Vector of bootstrap replications of \code{ATE.AIPW.hat}.}
  \item{ATE.reg.bs }{Vector of bootstrap replications of \code{ATE.reg.hat}.}
  \item{ATE.IPW.bs }{Vector of bootstrap replications of \code{ATE.IPW.hat}.}
  \item{gam.t }{\code{gam} object from fitted outcome model under treatment.}
  \item{gam.c }{\code{gam} object from the fitted outcome model under control.}
  \item{gam.ps }{\code{gam} object from the fitted propensity score model.}
  \item{truncated.indic }{Logical vector indicating which rows of \code{data} had extreme propensity scores truncated.}
  \item{discarded.indic }{Logical vector indicating which rows of \code{data} were discarded because of extreme propensity scores.}
  \item{treated.value }{Value of \code{treatment.var} that corresponds to active treatment.}
  \item{control.value }{Value of \code{treatment.var} that corresponds to control.}
  \item{treatment.var }{\code{treatment.var}}
  \item{n.treated.prediscard }{Number of treated units before any truncations or discards.}
  \item{n.control.prediscard }{Number of control units before any truncations or discards.}
  \item{n.treated.postdiscard }{Number of treated units after truncations or discards.}
  \item{n.control.postdiscard }{Number of control units after truncations or discards.}
  \item{pscores.prediscard }{Estimated propensity scores before any truncations or discards.}
  \item{pscores.postdiscard }{Estimated propensity scores after truncations or discards.}
  \item{cond.var.t }{Vector of conditional error variances for the outcome for each unit under treatment given the unit's estimated propensity score.}
  \item{cond.var.c }{Vector of conditional error variances for the outcome for each unit under control given the unit's estimated propensity score.}
  \item{call }{The initial call to \code{estimate.ATE}.}
  \item{data }{The data frame sent to \code{estimate.ATE}.}
}



\references{
Adam N. Glynn and Kevin M. Quinn. 2010. "An Introduction to the Augmented Inverse Propensity Weighted Estimator." \emph{Political Analysis}. 

Guido W. Imbens. 2004. "Nonparametric Estimation of Average Treatment Effects Under Exogeneity: A Review." \emph{The Review of Economics and Statistics}. 86: 4-29.  

Jared K. Lunceford and Marie Davidian. 2004. "Stratification and Weighting via the Propensity Score in Estimation of Causal Treatment Effects: A Comparative Study." \emph{Statistics in Medicine}. 23: 2937-2960.

}
\author{
Adam Glynn, Emory University

Kevin Quinn, University of Michigan
}





\examples{
\dontrun{
## a simulated data example with Gaussian outcomes
## 

## number of units in sample
n <- 2000


## measured potential confounders
z1 <- rnorm(n)
z2 <- rnorm(n)
z3 <- rnorm(n)
z4 <- rnorm(n)

## treatment assignment
prob.treated <-	pnorm(-0.5 + 0.75*z2)
x <- rbinom(n, 1, prob.treated)

## potential outcomes
y0 <- z4 + rnorm(n)
y1 <- z1 + z2 + z3 + cos(z3*2) + rnorm(n)

## observed outcomes
y <- y0
y[x==1] <- y1[x==1] 	     	


## put everything in a data frame
examp.data <- data.frame(z1, z2, z3, z4, x, y)


## estimate ATE
##
## in a real example one would want to use a larger number of 
## bootstrap replications
##
ATE.out <- estimate.ATE(pscore.formula = x ~ s(z2),
                        pscore.family = binomial,
                        outcome.formula.t = y ~ s(z1) + s(z2) + s(z3) + s(z4),
                        outcome.formula.c = y ~ s(z1) + s(z2) + s(z3) + s(z4),
      			outcome.family = gaussian,
			treatment.var = "x",
                        data=examp.data,
                        divby0.action="t",
                        divby0.tol=0.001, 
                        var.gam.plot=FALSE,
			nboot=50)      	   	


## print summary of estimates
print(ATE.out)




## a simulated data example with Bernoulli outcomes
## 

## number of units in sample
n <- 2000


## measured potential confounders
z1 <- rnorm(n)
z2 <- rnorm(n)
z3 <- rnorm(n)
z4 <- rnorm(n)

## treatment assignment
prob.treated <-	pnorm(-0.5 + 0.75*z2)
x <- rbinom(n, 1, prob.treated)

## potential outcomes
p0 <- pnorm(z4)
p1 <- pnorm(z1 + z2 + z3 + cos(z3*2))
y0 <- rbinom(n, 1, p0)
y1 <- rbinom(n, 1, p1)

## observed outcomes
y <- y0
y[x==1] <- y1[x==1] 	     	


## put everything in a data frame
examp.data <- data.frame(z1, z2, z3, z4, x, y)


## estimate ATE
##
## in a real example one would want to use a larger number of 
## bootstrap replications
##
ATE.out <- estimate.ATE(pscore.formula = x ~ s(z2),
                        pscore.family = binomial,
                        outcome.formula.t = y ~ s(z1) + s(z2) + s(z3) + s(z4),
                        outcome.formula.c = y ~ s(z1) + s(z2) + s(z3) + s(z4),
      			outcome.family = binomial,
			treatment.var = "x",
                        data=examp.data,
                        divby0.action="t",
                        divby0.tol=0.001,
                        var.gam.plot=FALSE, 
			nboot=50)      	   	


## print summary of estimates
print(ATE.out)		     
}
}


% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ models }

\seealso{\code{\link[gam]{gam}}, \code{\link[CausalGAM]{balance.IPW}}}
