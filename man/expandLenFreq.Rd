% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/expandLenFreq.R
\name{expandLenFreq}
\alias{expandLenFreq}
\title{Expands a length frequency based on a subsample.}
\usage{
expandLenFreq(
  x,
  w,
  additional,
  startcat = NULL,
  total = additional + length(x),
  decimals = decs$wdec,
  show.summary = TRUE,
  ...
)
}
\arguments{
\item{x}{A numeric vector of length measurements.}

\item{w}{A number that indicates the width of length classes to create.}

\item{additional}{The number of individuals that were not measured in the sample (for which measurements should be determined).}

\item{startcat}{A number that indicates the beginning of the first length-class.}

\item{total}{The total number of individuals in the sample (including those that were measured in the subsample).}

\item{decimals}{A number that indicates the number of decimals used in the output vector of estimated lengths.}

\item{show.summary}{A logical that indicates whether a summary of the process should be shown at the end.}

\item{\dots}{Optional arguments to be passed to \code{\link{lencat}}.}
}
\value{
Returns a vector that consists of measurements for the non-measured individuals in the entire sample.
}
\description{
Creates a vector of lengths for the individuals not measured based on the lengths measured in a subsample of individuals.
}
\details{
Creates a vector of lengths for the individuals not measured based on the lengths measured in a subsample of individuals. Length categories are created first that begin with the value in \code{startcat} (or the minimum observed value by default) and continue by values of \code{w} until a category value greater than the largest observed length in \code{x}. Categories of different widths are not allowed.

The resulting \dQuote{expanded} lengths are created by allocating individuals to each length class based on the proportion of measured individuals in the subsample in that length class. Individuals within a length class are then assigned a specific length within that length class based on a uniform distribution. Because the expanded number of individuals in a length class is rounded down based on the measured number per length class, not all individuals will initially be assigned a length value. The remaining individuals are assigned to a length class randomly according to weights based on the proportion of individuals in the measured length classes. Finally, these individuals are randomly assigned a specific length within the respective length class from a uniform distribution, same as above.

The resulting length assignments are rounded to the number of decimals shown in \code{decimal}. If \code{decimals} is not set by the user then it will default to the same number of decimals shown in the \code{w} value. Care is taken to make sure that the rounded result will not pass out of the given length category (i.e., will not be allowed to round up to the next length category). Generally speaking, one will want to use more decimals then is shown in \code{w}. For example, one may want to create length categories with a width of 1 inch (i.e., \code{w=1}) but have the results recorded as if measured to within 0.1 inch (i.e., \code{decimals=1}).
}
\examples{
## Set the random seed for reproducibility
set.seed(15343437)

## First example
# random lengths measured to nearest 0.1 unit -- values in a vector
len1 <- round(runif(50,0.1,9.9),1)
# assignment of integer lengths to 110 non-measured individuals
new.len1a <- expandLenFreq(len1,w=1,total=160)
new.len1a
# assignment of lengths to 0.1 to 110 non-measured individuals
new.len1b <- expandLenFreq(len1,w=1,total=160,decimals=1)
new.len1b

## Second example -- if values are in a data.frame
# random lengths measured to nearest 0.1 unit
len2 <- data.frame(len=round(runif(50,10,117),1))
# assignment of lengths to 0.1 for 140 non-measured indivs
new.len2a <- expandLenFreq(len2$len,w=10,total=190,decimals=1)
new.len2a

## Third example
# hypothetically measured lengths
len <- c(6.7,6.9,7.3,7.4,7.5,8.2,8.7,8.9)
# find lengths for unmeasured fish assuming a total of 30
newlen1 <- expandLenFreq(len,w=0.5,total=30,decimals=1)
newlen1
# set a starting length category
newlen2 <- expandLenFreq(len,w=0.5,startcat=6.2,total=30,decimals=1)
newlen2

}
\seealso{
See \code{\link{expandCounts}} for expanding more than just lengths or expanding lengths when there is a known number in each length bin. See \code{\link{lencat}} for creating length bins.
}
\author{
Derek H. Ogle, \email{DerekOgle51@gmail.com}
}
\keyword{manip}
