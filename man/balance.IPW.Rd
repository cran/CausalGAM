\name{balance.IPW}
\Rdversion{1.1}
\alias{balance.IPW}

\title{
Check Post-Weighting Balance for (A)IPW Estimators Using Generalized Additive Models} 

\description{
This function calculates weighted means of covariates where weights in inverse propensity weights and then examines the differences in the weighted means across treated and control units as a diagnostic for covariate balance.  
}
\usage{
balance.IPW(pscore.formula, pscore.family,
             treatment.var, outcome.var, data = NULL, 
             divby0.action = c("fail", "truncate", "discard"), 
             divby0.tol = 1e-08, nboot = 501, 
             suppress.warnings = TRUE, ...)
}

\arguments{
  \item{pscore.formula}{
  A formula expression for the propensity score model. See the documentation of \code{gam} for details. 
}
  \item{pscore.family}{
  A description of the error distribution and link function to be used for the propensity score model. See the documentation of \code{gam} for details.
}
  \item{treatment.var}{
  A character variable giving the name of the binary treatment variable in \code{data}. If \code{treatment.var} is a numeric variable, it is assumed that \emph{control} corresponds to \code{sort(unique(treatment.values))[1]} and \emph{treatment} corresponds to \code{sort(unique(treatment.values))[2]}. If \code{treatment.var} is a factor, it is assumed that \emph{control} corresponds to \code{levels(treatment.values)[1]} and \emph{treatment} corresponds to \code{levels(treatment.values)[2]}.
}
  \item{outcome.var}{A character variable giving the name of the outcome variable in \code{data}.}
  \item{data}{
  A \emph{non-optional} data frame containing the variables in the propensity score model along with all covariates that one wishes to assess balance for. \strong{\code{data} cannot contain any missing values.}   
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
  \item{suppress.warnings}{
 Logical value indicating whether warnings from the \code{gam} fitting procedures should be suppressed from printing to the screen. Defaults to \code{TRUE}. 
}
  \item{\dots}{
  Further arguments to be passed.
}
}


\details{
This function provides diagnostic information that allows a
user to judge whether the inverse propensity weights generated from a
particular generalized additive model specification result in
covariate balance across treated and control groups. The function is
intended to be used before the \code{estimate.ATE} function in order
to find a specification for the propensity score model that results in
sufficient covariate balance. 

The weighted mean differences between all variables in the dataset
passed to \code{balance.IPW} are reported along with a z-statistics
for these weighted differences. Univariate mean covariate balance is
decreasing in the absolute value of the z-statistics (z-statistics
closer to 0 imply better univariate mean balance).

Printing the output from \code{balance.IPW} will result in a table
with \eqn{k-2} rows (one for each variable other than the treatment
and outcome variables) and \eqn{6} columns. The columns are (from left
to right) the observed mean of the covariate among the treated units,
the observed mean of the covariate among the control units, the
weighted mean of the covariate among the treated units, the weighted
mean of the covariate among the control units, the weighted mean
difference, and the z-statistic for the difference.

It is often useful to include interactions and powers of the
covariates in the dataset so that balance can be checked for these
quantities as well.

Means, mean differences, and z-statistics are only reported for numeric covariates. 

}


\value{
An object of class \code{balance} with the following attributes: 
  \item{obs.mean.control}{The observed mean of each of the covariates within the control units.}
  \item{obs.mean.treated}{The observed mean of each of the covariates within the treated units.}
  \item{weighted.mean.control}{The weighted mean of each of the covariates within the control units.}
  \item{weighted.mean.treated}{The weighted mean of each of the covariates within the treated units.}
  \item{weighted.diff.SE}{The bootstrap standard errors for the differences betwen \code{weighted.mean.treated} and \code{weighted.mean.control}.} 
}



\references{
Adam N. Glynn and Kevin M. Quinn. 2010. "An Introduction to the Augmented Inverse Propensity Weighted Estimator." \emph{Political Analysis}. 

}
\author{
Adam Glynn, Emory University

Kevin Quinn, University of Michigan
}





\examples{
\dontrun{
set.seed(1234)
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

## augment data with interactions and powers of covariates
examp.data$z1z1 <- examp.data$z1^2
examp.data$z2z2 <- examp.data$z2^2
examp.data$z3z3 <- examp.data$z3^2
examp.data$z4z4 <- examp.data$z4^2

examp.data$z1z2 <- examp.data$z1 * examp.data$z2
examp.data$z1z3 <- examp.data$z1 * examp.data$z3
examp.data$z1z4 <- examp.data$z1 * examp.data$z4

examp.data$z2z3 <- examp.data$z2 * examp.data$z3
examp.data$z2z4 <- examp.data$z2 * examp.data$z4

examp.data$z3z4 <- examp.data$z3 * examp.data$z4



## check balance of a propensity score model that is not sufficient to
## control confounding bias

bal.1 <- balance.IPW(pscore.formula=x~s(z3)+s(z4),
                     pscore.family=binomial(probit),
                     treatment.var="x",
                     outcome.var="y",
                     data=examp.data,
                     nboot=250)

print(bal.1) ## some big z-statistics here indicating balance not so great


## try again
bal.2 <- balance.IPW(pscore.formula=x~z1+z2+z3+z4,
                     pscore.family=binomial(probit),
                     treatment.var="x",
                     outcome.var="y",
                     data=examp.data,
                     nboot=250)

print(bal.2) ## balance looks much better-- 
             ##    only 1 out of 14 zs > 2.0 in absval

}
}


% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ models }

\seealso{\code{\link[gam]{gam}}, \code{\link[CausalGAM]{estimate.ATE}}}
