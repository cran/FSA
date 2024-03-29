% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/psdVal.R
\name{psdVal}
\alias{psdVal}
\title{Finds Gabelhouse lengths (for PSD calculations) for a species.}
\usage{
psdVal(
  species = "List",
  units = c("mm", "cm", "in"),
  incl.zero = TRUE,
  addLens = NULL,
  addNames = NULL,
  showJustSource = FALSE
)
}
\arguments{
\item{species}{A string that contains the species name for which to find Gabelhouse lengths. See details.}

\item{units}{A string that indicates the units for the returned lengths. Choices are \code{mm} for millimeters (DEFAULT), \code{cm} for centimeters, and \code{in} for inches.}

\item{incl.zero}{A logical that indicates if a zero is included in the first position of the returned vector (DEFAULT) or not. This position will be named \dQuote{substock}. See details.}

\item{addLens}{A numeric vector that contains minimum length definitions for additional categories. See details.}

\item{addNames}{A string vector that contains names for the additional length categories added with \code{addLens}. See details.}

\item{showJustSource}{A logical that indicates whether just the literature source information should be returned (\code{TRUE}) or not. If \code{TRUE} this will NOT return any of the Gabelhouse length information.}
}
\value{
A vector of minimum values for length categories for the chosen species.
}
\description{
Returns a vector with the five Gabelhouse lengths for a chosen species.
}
\details{
Finds the Gabelhouse lengths from \code{data(PSDlit)} for the species given in \code{species}. The species name must be spelled exactly (within capitalization differences) as it appears in \code{data(PSDlit)}. Type \code{psdVal()} to see the list of species and how they are spelled.

A zero is included in the first position of the returned vector if \code{incl.zero=TRUE}. This is useful when computing PSD values with a data.frame that contains fish smaller than the stock length.

Additional lengths may be added to the returned vector with \code{addLens}. Names for these lengths can be included in \code{addNames}. If \code{addNames} is non-NULL, then it must be of the same length as \code{addLens}. If \code{addLens} is non-NULL but \code{addNames} is NULL, then the default names will be the same as the lengths in \code{addLens}. The \code{addLens} argument is useful for calculating PSD values that are different from the Gabelhouse lengths.
}
\section{IFAR Chapter}{
 6-Size Structure.
}

\examples{
# List all of the species
psdVal()
# Demonstrate typical usages
psdVal("Yellow perch")
psdVal("Walleye",units="cm")
psdVal("Bluegill",units="in")
psdVal("Bluegill",units="in",incl.zero=FALSE)
psdVal("Bluegill")
# Demonstrate that it will work with mis-capitalization
psdVal("bluegill")
psdVal("Yellow Perch")
# Demonstrate adding in user-defined categories
psdVal("Bluegill",units="in",addLens=7)
psdVal("Bluegill",units="in",addLens=7,addNames="MinLen")
psdVal("Bluegill",units="in",addLens=c(7,9),addNames=c("MinSlot","MaxSlot"))
psdVal("Bluegill",units="in",addLens=c("MinLen"=7))
psdVal("Bluegill",units="in",addLens=c("MinSlot"=7,"MaxSlot"=9))
psdVal("Bluegill",showJustSource=TRUE)

}
\references{
Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.

Guy, C.S., R.M. Neumann, and D.W. Willis. 2006. New terminology for proportional stock density (PSD) and relative stock density (RSD): proportional size structure (PSS). Fisheries 31:86-87. [Was (is?) from http://pubstorage.sdstate.edu/wfs/415-F.pdf.]

Guy, C.S., R.M. Neumann, D.W. Willis, and R.O. Anderson. 2006. Proportional size distribution (PSD): A further refinement of population size structure index terminology. Fisheries 32:348. [Was (is?) from http://pubstorage.sdstate.edu/wfs/450-F.pdf.]

Willis, D.W., B.R. Murphy, and C.S. Guy. 1993. Stock density indices: development, use, and limitations. Reviews in Fisheries Science 1:203-222. [Was (is?) from http://web1.cnre.vt.edu/murphybr/web/Readings/Willis\%20et\%20al.pdf.]
}
\seealso{
See \code{\link{psdCalc}}, \code{\link{psdPlot}}, \code{\link{psdAdd}}, \code{\link{PSDlit}}, \code{\link{tictactoe}}, \code{\link{lencat}}, and \code{\link{rcumsum}} for related functionality.
}
\author{
Derek H. Ogle, \email{DerekOgle51@gmail.com}
}
\keyword{manip}
