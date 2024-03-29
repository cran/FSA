% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CIDists.R
\name{hyperCI}
\alias{hyperCI}
\title{Confidence interval for population size (N) in hypergeometric distribution.}
\usage{
hyperCI(M, n, m, conf.level = 0.95)
}
\arguments{
\item{M}{Number of successes in the population.}

\item{n}{Number of observations in the sample.}

\item{m}{Number of observed successes in the sample.}

\item{conf.level}{Level of confidence to use for constructing confidence intervals (default is \code{0.95}).}
}
\value{
A 1x2 matrix that contains the lower and upper confidence interval bounds.
}
\description{
Computes a confidence interval for population size (N) in hypergeometric distribution.
}
\details{
This is an inefficient brute-force algorithm. The algorithm computes the \code{conf.level} range of possible values for \code{m}, as if it was unknown, for a large range of values of N. It then finds all possible values of N for which \code{m} was in the \code{conf.level} range. The smallest and largest values of N for which \code{m} was in the \code{conf.level} range are the CI endpoints.
}
\note{
This algorithm is experimental at this point.
}
\examples{
hyperCI(50,25,10)

}
\author{
Derek H. Ogle, \email{DerekOgle51@gmail.com}
}
\keyword{htest}
