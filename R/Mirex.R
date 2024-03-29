#' @title Mirex concentration, weight, capture year, and species of Lake Ontario salmon.
#'
#' @description Mirex concentration, weight, capture year, and species of Lake Ontario Coho and Chinook salmon.
#'
#' @details The \code{year} variable should be converted to a factor as shown in the example.
#'
#' @name Mirex
#'
#' @docType data
#'
#' @format A data frame with 122 observations on the following 4 variables.
#'  \describe{ 
#'    \item{year}{a numeric vector of capture years}
#'    \item{weight}{a numeric vector of salmon weights (kg)}
#'    \item{mirex}{a numeric vector of mirex concentration in the salmon tissue (mg/kg)}
#'    \item{species}{a factor with levels \code{chinook} and \code{coho}}
#'  }
#'
#' @section Topic(s):
#'  \itemize{
#'    \item Linear models
#'    \item Other
#'  }
#'  
#' @concept Linear Models
#' @concept Other
#'
#' @source From (actual data) Makarewicz, J.C., E.Damaske, T.W. Lewis, and M. Merner. 2003. Trend analysis reveals a recent reduction in mirex concentrations in Coho (\emph{Oncorhynchus kisutch}) and Chinook (\emph{O. tshawytscha}) Salmon from Lake Ontario. Environmental Science and Technology, 37:1521-1527. \href{https://raw.githubusercontent.com/fishR-Core-Team/FSA/master/data-raw/Mirex.csv}{CSV file}
#'
#' @keywords datasets
#'
#' @examples
#' Mirex$year <- factor(Mirex$year)
#' lm1 <- lm(mirex~weight*year*species,data=Mirex)
#' anova(lm1)
#'
NULL
