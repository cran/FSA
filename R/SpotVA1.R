#' @title Age and length of spot.
#'
#' @description Ages (from otoliths) and lengths of Virginia Spot (\emph{Leiostomus xanthurus}).
#'
#' @details Final length measurements were simulated by adding a uniform error to the value at the beginning of the length category.
#'
#' @name SpotVA1
#'
#' @docType data
#'
#' @format A data frame of 403 observations on the following 2 variables:
#'  \describe{
#'    \item{tl}{Measured total lengths (in inches)}
#'    \item{age}{Ages assigned from examination of otoliths}
#'  }
#'
#' @section Topic(s):
#'  \itemize{
#'    \item Growth
#'    \item von Bertalanffy
#'  }
#'
#' @concept Growth
#' @concept von Bertalanffy
#'
#' @seealso Used in \code{\link{vbFuns}}, \code{\link{vbStarts}}, and \code{\link{nlsTracePlot}} examples. Also see \code{\link[FSAdata]{SpotVA2}} in \pkg{FSAdata} for related data.
#'
#' @source Extracted from Table 1 in Chapter 8 (Spot) of the VMRC Final Report on Finfish Ageing, 2002 by the Center for Quantitative Fisheries Ecology at Old Dominion University. \href{https://raw.githubusercontent.com/fishR-Core-Team/FSA/master/data-raw/SpotVA1.csv}{CSV file}
#'
#' @keywords datasets
#'
#' @examples
#' str(SpotVA1)
#' head(SpotVA1)
#' plot(tl~age,data=SpotVA1)
#'
NULL
