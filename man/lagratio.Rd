% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FSAUtils.R
\name{lagratio}
\alias{lagratio}
\title{Ratio of lagged observations.}
\usage{
lagratio(
  x,
  lag = 1L,
  recursion = 1L,
  differences = recursion,
  direction = c("backward", "forward"),
  ...
)
}
\arguments{
\item{x}{A numeric vector or matrix.}

\item{lag}{An integer representing the lag \sQuote{distance}.}

\item{recursion}{An integer that indicates the level of recursion for the calculations. A \code{1} will simply compute the ratios. A \code{2}, for example, will compute the ratios, save the result, and then compute the ratios of the results using the same \code{lag}. See examples.}

\item{differences}{Same as \code{recursion}. Used for symmetry with \code{\link[base]{diff}}.}

\item{direction}{A string that indicates the direction of calculation. A \code{"backward"} indicates that \sQuote{latter} values are divided by \sQuote{former} values. A \code{"forward"} indicates that \sQuote{former} values are divided by \sQuote{latter} values. See examples.}

\item{\dots}{Additional arguments to \code{diff()}.}
}
\value{
A vector or matrix of lagged ratios.
}
\description{
Computes the ratio of lagged observations in a vector.
}
\details{
This function behaves similarly to \code{diff()} except that it returns a vector or matrix of ratios rather than differences.
}
\examples{
## Backward lagged ratios
# no recursion
lagratio(1:10,1)
lagratio(1:10,2)
# with recursion
lagratio(1:10,1,2)
lagratio(1:10,2,2)

## Forward lagged ratios
# no recursion
lagratio(10:1,1,direction="forward")
lagratio(10:1,2,direction="forward")
# with recursion
lagratio(10:1,1,2,direction="forward")
lagratio(10:1,2,2,direction="forward")

}
\seealso{
\code{diff}
}
\author{
Derek H. Ogle, \email{DerekOgle51@gmail.com}
}
\keyword{manip}
