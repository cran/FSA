#' @title Capture histories (9 samples) of Cutthroat Trout from Auke Lake.
#'
#' @description Individual capture histories of Cutthroat Trout (\emph{Oncorhynchus clarki}) in Auke Lake, Alaska, from samples taken in 1998-2006.
#'
#' @name CutthroatAL
#' 
#' @docType data
#' 
#' @format A data frame with 1684 observations on the following 10 variables.
#'  \describe{
#'    \item{id}{Unique identification numbers for each fish}
#'    \item{y1998}{Indicator variable for whether the fish was captured in 1998 (\code{1}=captured)}
#'    \item{y1999}{Indicator variable for whether the fish was captured in 1999 (\code{1}=captured)}
#'    \item{y2000}{Indicator variable for whether the fish was captured in 2000 (\code{1}=captured)}
#'    \item{y2001}{Indicator variable for whether the fish was captured in 2001 (\code{1}=captured)}
#'    \item{y2002}{Indicator variable for whether the fish was captured in 2002 (\code{1}=captured)}
#'    \item{y2003}{Indicator variable for whether the fish was captured in 2003 (\code{1}=captured)}
#'    \item{y2004}{Indicator variable for whether the fish was captured in 2004 (\code{1}=captured)}
#'    \item{y2005}{Indicator variable for whether the fish was captured in 2005 (\code{1}=captured)}
#'    \item{y2006}{Indicator variable for whether the fish was captured in 2006 (\code{1}=captured)}
#'  }
#'
#' @section Topic(s):
#'  \itemize{
#'    \item Population Size
#'    \item Abundance
#'    \item Mark-Recapture
#'    \item Capture-Recapture
#'    \item Jolly-Seber
#'    \item Capture History 
#'  }
#' 
#' @concept Abundance
#' @concept Population Size
#' @concept Mark-Recapture
#' @concept Capture-Recapture
#' @concept Jolly-Seber
#' @concept Capture History
#' 
#' @source From Appendix A.3 of Harding, R.D., C.L. Hoover, and R.P. Marshall. 2010. Abundance of Cutthroat Trout in Auke Lake, Southeast Alaska, in 2005 and 2006. Alaska Department of Fish and Game Fisheries Data Series No. 10-82. [Was (is?) from http://www.sf.adfg.state.ak.us/FedAidPDFs/FDS10-82.pdf.] \href{https://raw.githubusercontent.com/fishR-Core-Team/FSA/master/data-raw/CutthroatAL.csv}{CSV file}
#' 
#' @note Entered into \dQuote{RMark} format (see \code{\link[FSAdata]{CutthroatALf}} in \pkg{FSAdata}) and then converted to individual format with \code{\link{capHistConvert}}
#' 
#' @seealso Used in \code{\link{mrOpen}} examples.
#' 
#' @keywords datasets
#' 
#' @examples
#' str(CutthroatAL)
#' head(CutthroatAL)
#'
NULL
