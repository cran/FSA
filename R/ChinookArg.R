#' @title Lengths and weights for Chinook Salmon from three locations in Argentina.
#'
#' @description Lengths and weights for Chinook Salmon from three locations in Argentina.
#'
#' @name ChinookArg
#' 
#' @docType data
#' 
#' @format A data frame with 112 observations on the following 3 variables:
#'  \describe{
#'    \item{tl}{Total length (cm)}
#'    \item{w}{Weight (kg)}
#'    \item{loc}{Capture location (\code{Argentina}, \code{Petrohue}, \code{Puyehue})} 
#'  }
#' 
#' @section Topic(s):
#'  \itemize{
#'    \item Weight-Length 
#'  }
#' 
#' @concept Weight-Length
#' 
#' @source From Figure 4 in Soto, D., I. Arismendi, C. Di Prinzio, and F. Jara. 2007. Establishment of Chinook Salmon (\emph{Oncorhynchus tshawytscha}) in Pacific basins of southern South America and its potential ecosystem implications. Revista Chilena d Historia Natural, 80:81-98. [Was (is?) from http://www.scielo.cl/pdf/rchnat/v80n1/art07.pdf.] \href{https://raw.githubusercontent.com/fishR-Core-Team/FSA/master/data-raw/ChinookArg.csv}{CSV file}
#' 
#' @seealso Used in \code{\link{lwCompPreds}} examples.
#' 
#' @keywords datasets
#' 
#' @examples
#' str(ChinookArg)
#' head(ChinookArg)
#' op <- par(mfrow=c(2,2),pch=19,mar=c(3,3,0.5,0.5),mgp=c(1.9,0.5,0),tcl=-0.2)
#' plot(w~tl,data=ChinookArg,subset=loc=="Argentina")
#' plot(w~tl,data=ChinookArg,subset=loc=="Petrohue")
#' plot(w~tl,data=ChinookArg,subset=loc=="Puyehue")
#' par(op)
#'
NULL