% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mdmr.R
\name{mdmr}
\alias{mdmr}
\title{Conduct MDMR with analytic p-values}
\usage{
mdmr(X, D = NULL, G = NULL, lambda = NULL, return.lambda = F,
  start.acc = 1e-20, ncores = 1, perm.p = (nrow(as.matrix(X)) < 200),
  nperm = 500, seed = NULL)
}
\arguments{
\item{X}{A \eqn{n x p} matrix or data frame of predictors. Unordered factors
will be tested with contrast-codes by default, and ordered factors will be
tested with polynomial contrasts. For finer control of how categorical
predictors are handled, or if higher-order effects are desired, the output
from a call to \code{model.matrix()} can be supplied to this argument as
well.}

\item{D}{Distance matrix computed on the outcome data. Can be either a
matrix or an R \code{\link{dist}} object. Either \code{D} or \code{G}
must be passed to \code{mdmr()}.}

\item{G}{Gower's centered similarity matrix computed from \code{D}.
Either \code{D} or \code{G} must be passed to \code{mdmr}.}

\item{lambda}{Optional argument: Eigenvalues of \code{G}.
Eigendecomposition of large \code{G} matrices can be somewhat time
consuming, and the theoretical p-values require the eigenvalues of
\code{G}. If MDMR is to be conducted multiple times on one distance
matrix, it is advised to conduct the eigendecomposition once and pass the
eigenvalues to \code{mdmr()} directly each time.}

\item{return.lambda}{Logical; indicates whether or not the eigenvalues of
\code{G} should be returned, if calculated. Default is \code{FALSE}.}

\item{start.acc}{Starting accuracy of the Davies (1980) algorithm
implemented in the \code{\link{davies}} function in the \code{CompQuadForm}
package (Duchesne &  De Micheaux, 2010) that \code{mdmr()} uses to compute
MDMR p-values.}

\item{ncores}{Integer; if \code{ncores} > 1, the \code{\link{parallel}}
package is used to speed computation. Note: Windows users must set
\code{ncores = 1} because the \code{parallel} pacakge relies on forking. See
\code{mc.cores} in the \code{\link{mclapply}} function in the
\code{parallel} pacakge for more details.}

\item{perm.p}{Logical: should permutation-based p-values be computed instead
of analytic p-values? Default behavior is \code{TRUE} if \code{n < 200} and
\code{FALSE} otherwise because the anlytic p-values depend on asymptotics.
for \code{n > 200} and "permutation" otherwise.}

\item{nperm}{Number of permutations to use if permutation-based p-values are
to be computed.}

\item{seed}{Random seed to use to generate the permutation null distribution.
Defaults to a random seed.}
}
\value{
An object with six elements and a summary function. Calling
\code{summary(mdmr.res)} produces a data frame comprised of:
\item{Statistic}{Value of the corresponding MDMR test statistic}
\item{Numer DF}{Numerator degrees of freedom for the corresponding effect}
\item{Pseudo R2}{Size of the corresponding effect on the
distance matrix}
\item{p-value}{The p-value for each effect.}
In addition to the information in the three columns comprising
\code{summary(res)}, the \code{res} object also contains:

\item{p.prec}{A data.frame reporting the precision of each p-value. If
analytic p-values were computed, these are the maximum error bound of the
p-values reported by the \code{davies} function in \code{CompQuadForm}. If
permutation p-values were computed, it is the standard error of each
permutation p-value.}
\item{lambda}{A vector of the eigenvalues of \code{G} (if
\code{return.lambda = T}).}
\item{nperm}{Number of permutations used. Will read \code{NA} if analytic
p-values were computed}

Note that the printed output of \code{summary(res)} will truncate p-values
to the smallest trustworthy values, but the object returned by
\code{summary(res)} will contain the p-values as computed. The reason for
this truncation differs for analytic and permutation p-values. For an
analytic p-value, if the error bound of the Davies algorithm is larger than
the p-value, the only conclusion that can be drawn with certainty is that
the p-value is smaller than (or equal to) the error bound. For a permutation
test, the estimated p-value will be zero if no permuted test statistics are
greater than the observed statistic, but the zero p-value is only a product
of the finite number of permutations conduted. The only conclusion that can
be drawn is that the p-value is smaller than \code{1/nperm}.
}
\description{
\code{mdmr} (multivariate distance matrix regression) is used to regress a
distance matrix onto a set of predictors. It returns the test statistic,
pseudo R-square statistic, and analytic p-values for all predictors
jointly and for each predictor individually, conditioned on the rest.
}
\details{
This function is the fastest approach to conducting MDMR. It uses the
fastest known computational strategy to compute the MDMR test statistic (see
Appendix A of McArtor et al., 2017), and it uses fast, analytic p-values.

The slowest part of conducting MDMR is now the necessary eigendecomposition
of the \code{G} matrix, whose computation time is a function of
\eqn{n^3}. If MDMR is to be conducted multiple times on the same
distance matrix, it is recommended to compute eigenvalues of \code{G} in
advance and pass them to the function rather than computing them every
time \code{mdmr} is called, as is the case if the argument \code{lambda}
is left \code{NULL}.

The distance matrix \code{D} can be passed to \code{mdmr} as either a
distance object or a symmetric matrix.
}
\examples{
# --- The following two approaches yield equivalent results --- #
# Approach 1
data(mdmrdata)
D <- dist(Y.mdmr, method = "euclidean")
res1 <- mdmr(X = X.mdmr, D = D)
summary(res1)

# Approach 2
data(mdmrdata)
D <- dist(Y.mdmr, method = "euclidean")
G <- gower(D)
res2 <- mdmr(X = X.mdmr, G = G)
summary(res2)

}
\references{
Davies, R. B. (1980). The Distribution of a Linear Combination of
 chi-square Random Variables. Journal of the Royal Statistical Society.
 Series C (Applied Statistics), 29(3), 323-333.

 Duchesne, P., & De Micheaux, P. L. (2010). Computing the distribution of
 quadratic forms: Further comparisons between the Liu-Tang-Zhang
 approximation and exact methods. Computational Statistics and Data
 Analysis, 54(4), 858-862.

 McArtor, D. B., Lubke, G. H., & Bergeman, C. S. (2017). Extending
 multivariate distance matrix regression with an effect size measure and the
 distribution of the test statistic. Psychometrika, 82, 1052-1077.
}
\author{
Daniel B. McArtor (dmcartor@gmail.com) [aut, cre]
}
