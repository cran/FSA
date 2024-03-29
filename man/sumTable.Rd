% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sumTable.R
\name{sumTable}
\alias{sumTable}
\alias{sumTable.formula}
\title{Creates a one- or two-way table of summary statistics.}
\usage{
sumTable(formula, ...)

\method{sumTable}{formula}(formula, data = NULL, FUN = mean, digits = getOption("digits"), ...)
}
\arguments{
\item{formula}{A formula with a quantitative variable on the left-hand-side and one or two factor variables on the right-hand-side. See details.}

\item{\dots}{Other arguments to pass through to \code{FUN}.}

\item{data}{An optional data frame that contains the variables in \code{formula}.}

\item{FUN}{A scalar function that identifies the summary statistics. Applied to the quantitative variable for all data subsets identified by the combination of the factor(s). Defaults to \code{mean}.}

\item{digits}{A single numeric that indicates the number of digits to be used for the result.}
}
\value{
A one-way array of values if only one factor variable is supplied on the right-hand-side of \code{formula}. A two-way matrix of values if two factor variables are supplied on the right-hand-side of \code{formula}. These are the same classes of objects returned by \code{\link[base]{tapply}}.
}
\description{
Creates a one- or two-way table of summary statistics for a quantitative variable.
}
\details{
The formula must be of the form \code{quantitative~factor} or \code{quantitative~factor*factor2} where \code{quantitative} is the quantitative variable to construct the summaries for and \code{factor} and \code{factor2} are factor variables that contain the levels for which separate summaries should be constructed. If the variables on the right-hand-side are not factors, then they will be coerced to be factors and a warning will be issued.

This function is largely a wrapper to \code{tapply()}, but only works for one quantitative variable on the left-hand-side and one or two factor variables on the right-hand-side. Consider using \code{\link[base]{tapply}} for situations with more factors on the right-hand-side.
}
\examples{
## The same examples as in the old aggregate.table in gdata package
## but data in data.frame to illustrate formula notation
d <- data.frame(g1=sample(letters[1:5], 1000, replace=TRUE),
                g2=sample(LETTERS[1:3], 1000, replace=TRUE),
                dat=rnorm(1000))

sumTable(dat~g1*g2,data=d,FUN=length)       # get sample size
sumTable(dat~g1*g2,data=d,FUN=validn)       # get sample size (better way)
sumTable(dat~g1*g2,data=d,FUN=mean)         # get mean
sumTable(dat~g1*g2,data=d,FUN=sd)           # get sd
sumTable(dat~g1*g2,data=d,FUN=sd,digits=1)  # show digits= argument

## Also demonstrate use in the 1-way example -- but see Summarize()
sumTable(dat~g1,data=d,FUN=validn)
sumTable(dat~g1,data=d,FUN=mean)

## Example with a missing value (compare to above)
d$dat[1] <- NA
sumTable(dat~g1,data=d,FUN=validn)  # note use of validn
sumTable(dat~g1,data=d,FUN=mean,na.rm=TRUE)

}
\seealso{
See \code{\link[base]{tapply}} for a more general implementation. See \code{\link{Summarize}} for a similar computation when only one factor variable is given.
}
\author{
Derek H. Ogle, \email{DerekOgle51@gmail.com}
}
\keyword{hplot}
