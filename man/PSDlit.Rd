% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PSDlit.R
\docType{data}
\name{PSDlit}
\alias{PSDlit}
\title{Gabelhouse five-cell length categories for various species.}
\format{
A data frame of 58 observations on the following 11 variables:
 \describe{
   \item{species}{Species name.}
   \item{group}{Sub-group name (e.g., \code{"landlocked"} or \code{"lotic"}).}
   \item{substock.in}{Zero inches.}
   \item{stock.in}{Stock length in inches.}
   \item{quality.in}{Quality length in inches.}
   \item{preferred.in}{Preferred length in inches.}
   \item{memorable.in}{Memorable length in inches.}
   \item{trophy.in}{Trophy length in inches.}
   \item{substock.cm}{Zero cm.}
   \item{stock.cm}{Stock length in cm.}
   \item{quality.cm}{Quality length in cm.}
   \item{preferred.cm}{Preferred length in cm.}
   \item{memorable.cm}{Memorable length in cm.}
   \item{trophy.cm}{Trophy length in cm.}
   \item{source}{Literature source for the length entries.}
 }
}
\source{
Original summary table from Dr. Michael Hansen, University of Wisconsin-Stevens Point. Additional species have been added by the package author from the literature.
}
\description{
Cutoffs for the Gabelhouse five-cell length categories for a variety of species.
}
\section{Topic(s)}{

 \itemize{
   \item Size structure
   \item Proportional size structure
   \item Relative stock density
   \item Proportional stock density
 }
}

\section{IFAR Chapter}{
 6-Size Structure.
}

\examples{
str(PSDlit)
head(PSDlit)

}
\references{
Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.
}
\seealso{
See \code{\link{psdVal}}, \code{\link{psdCalc}}, \code{\link{psdPlot}}, \code{\link{psdAdd}}, and \code{\link{tictactoe}} for related functionality.
}
\concept{PSD}
\concept{Size Structure}
\keyword{datasets}
