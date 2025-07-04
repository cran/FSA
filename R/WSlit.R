#' @title All known standard weight equations.
#'
#' @description Parameters for all known standard weight equations.
#'
#' @details The minimum TL for the English units were derived by rounding the converted minimum TL for the metric units to what seemed like common units (inches, half inches, or quarter inches).
#'
#' @name WSlit
#'
#' @docType data
#'
#' @format A data frame with observations on the following 13 variables:
#'  \describe{
#'    \item{species}{Species name. Use \code{wsVal()} to see the list of available species.}
#'    \item{group}{Sub-group name (e.g., \code{"female"} or \code{"lotic"}).}
#'    \item{units}{Units of measurements. \code{Metric} uses lengths in mm and weight in grams. \code{English} uses lengths in inches and weight in pounds.}
#'    \item{ref}{Reference quartile (\code{75}, \code{50}, or \code{25}).}
#'    \item{measure}{The type of length measurement used -- total length (\code{TL}) or fork length (\code{FL}).}
#'    \item{method}{The type of method used to derive the equation (Regression Line Percentile (\code{RLP}; see Murphy \emph{et al.} (1990) and Murphy \emph{et al.} (1991)), Empirical Percentile (\code{EmP}; see Gerow \emph{et al.} (2005)), or \code{Other}).}
#'    \item{min.len}{Minimum total length (mm or in, depending on \code{units}) for which the equation should be applied.}
#'    \item{max.len}{Maximum total length (mm or in, depending on \code{units}) for which the equation should be applied.}
#'    \item{int}{The intercept for the model.}
#'    \item{slope}{The slope for the linear equation or the linear coefficient for the quadratic equation.}
#'    \item{quad}{The quadratic coefficient in the quadratic equation.}
#'    \item{source}{Source of the equation. These match the sources given in Neumann \emph{et al.} (2012).}
#'    \item{comment}{Comments about use of equation.}
#'  }
#'
#' @section Topic(s):
#'  \itemize{
#'    \item Relative weight
#'    \item Standard weight
#'    \item Condition
#'  }
#'
#' @concept Condition
#' @concept Relative Weight
#' @concept Standard Weight
#'
#' @seealso See \code{\link{wsVal}} and \code{\link{wrAdd}} for related functionality.
#'
#' @section IFAR Chapter: 8-Condition.
#'
#' @references Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.
#' 
#' Gerow, K.G., R.C. Anderson-Sprecher, and W.A. Hubert. 2005. A new method to compute standard weight equations that reduces length-related bias. North American Journal of Fisheries Management 25:1288–1300.
#' 
#' Murphy, B.R., M.L. Brown, and T.A. Springer. 1990. Evaluation of the relative weight (Wr) index, with new applications to walleye. North American Journal of Fisheries Management 10:85–97.
#' 
#' Murphy, B. R., D. W. Willis, and T. A. Springer. 1991. The relative weight index in fisheries management: Status and needs. Fisheries (Bethesda) 16(2):30–38.
#' 
#' Neumann, R.M., C.S. Guy, and D.W. Willis. 2012. Length, Weight, and Associated Indices. Chapter 14 in Zale, A.V., D.L. Parrish, and T.M. Sutton, editors. Fisheries Techniques. American Fisheries Society, Bethesda, MD.
#'
#' @source Most of these equations can be found in Neumann \emph{et al.} (2012). Species not in Neumann \emph{et al.} (2012) are noted as such in the \code{comments} variable.
#'
#' @keywords datasets
#'
#' @examples
#' str(WSlit)
#' head(WSlit)
#'
NULL
