#' @title Use an age-length key to assign age to individuals in the unaged sample.
#'
#' @description Use either the semi- or completely-random methods from Isermann and Knight (2005) to assign ages to individual fish in the unaged sample according to the information in an age-length key supplied by the user. 
#'
#' @details The age-length key in \code{key} must have length intervals as rows and ages as columns. The row names of \code{key} (i.e., \code{rownames(key)}) must contain the minimum values of each length interval (e.g., if an interval is 100-109, then the corresponding row name must be 100). The column names of \code{key} (i.e., \code{colnames(key)}) must contain the age values (e.g., the columns can NOT be named with \dQuote{age.1}, for example).
#'
#' The length intervals in the rows of \code{key} must contain all of the length intervals present in the unaged sample to which the age-length key is to be applied (i.e., sent in the \code{length} portion of the \code{formula}). If this constraint is not met, then the function will stop with an error message.
#'
#' If \code{breaks=NULL}, then the length intervals for the unaged sample will be determined with a starting interval at the minimum value of the row names in \code{key} and a width of the length intervals as determined by the minimum difference in adjacent row names of \code{key}. If length intervals of differing widths were used when constructing \code{key}, then those breaks should be supplied to \code{breaks=}. Use of \code{breaks=} may be useful when \dQuote{uneven} length interval widths were used because the lengths in the unaged sample are not fully represented in the aged sample. See the examples.
#'
#' Assigned ages will be stored in the column identified on the left-hand-side of \code{formula} (if the formula has both a left- and right-hand-side). If this variable is missing in \code{formula}, then the new column will be labeled with \code{age}.
#'
#' @param key A numeric matrix that contains the age-length key. The format of this matrix is important. See details.
#' @param formula A formula of the form \code{age~length} where \code{age} generically represents the variable that will contain the estimated ages once the key is applied (i.e., should currently contain no values) and \code{length} generically represents the variable that contains the known length measurements. If only \code{~length} is used, then a new variable called \dQuote{age} will be created in the resulting data frame.
#' @param data A data.frame that minimally contains the length measurements and possibly contains a variable that will receive the age assignments as given in \code{formula}.
#' @param type A string that indicates whether to use the semi-random (\code{type="SR"}, default) or completely-random (\code{type="CR"}) methods for assigning ages to individual fish. See the \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{IFAR chapter} for more details.
#' @param breaks A numeric vector of lower values that define the length intervals. See details.
#' @param seed A single numeric that is given to \code{set.seed} to set the random seed. This allows repeatability of results.
#' 
#' @return The original data.frame in \code{data} with assigned ages added to the column supplied in \code{formula} or in an additional column labeled as \code{age}. See details.
#' 
#' @section Testing: The \code{type="SR"} method worked perfectly on a small example. The \code{type="SR"} method provides results that reasonably approximate the results from \code{\link{alkAgeDist}} and \code{\link{alkMeanVar}}, which suggests that the age assessments are reasonable.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}. This is largely an R version of the SAS code provided by Isermann and Knight (2005).
#'
#' @section IFAR Chapter: 5-Age-Length Key.
#'
#' @seealso  See \code{\link{alkAgeDist}} and \code{\link{alkMeanVar}} for alternative methods to derived age distributions and mean (and SD) values for each age. See \code{\link{alkPlot}} for methods to visualize age-length keys.
#'
#' @references Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.
#' 
#' Isermann, D.A. and C.T. Knight. 2005. A computer program for age-length keys incorporating age assignment to individual fish. North American Journal of Fisheries Management, 25:1153-1160. [Was (is?) from http://www.tandfonline.com/doi/abs/10.1577/M04-130.1.]
#'
#' @keywords manip
#'
#' @examples
#' ## First Example -- Even breaks for length categories
#' WR1 <- WR79
#' # add length categories (width=5)
#' WR1$LCat <- lencat(WR1$len,w=5)
#' # isolate aged and unaged samples
#' WR1.age <- subset(WR1, !is.na(age))
#' WR1.len <- subset(WR1, is.na(age))
#' # note no ages in unaged sample
#' head(WR1.len)
#' # create age-length key
#' raw <- xtabs(~LCat+age,data=WR1.age)
#' ( WR1.key <- prop.table(raw, margin=1) )
#' # apply the age-length key
#' WR1.len <- alkIndivAge(WR1.key,age~len,data=WR1.len)
#' # now there are ages
#' head(WR1.len)
#' # combine orig age & new ages
#' WR1.comb <- rbind(WR1.age, WR1.len)
#' # mean length-at-age
#' Summarize(len~age,data=WR1.comb,digits=2)
#' # age frequency distribution
#' ( af <- xtabs(~age,data=WR1.comb) )
#' # proportional age distribution
#' ( ap <- prop.table(af) )
#'
#' ## Second Example -- length sample does not have an age variable
#' WR2 <- WR79
#' # isolate age and unaged samples
#' WR2.age <- subset(WR2, !is.na(age))
#' WR2.len <- subset(WR2, is.na(age))
#' # remove age variable (for demo only)
#' WR2.len <- WR2.len[,-3]
#' # add length categories to aged sample
#' WR2.age$LCat <- lencat(WR2.age$len,w=5)
#' # create age-length key
#' raw <- xtabs(~LCat+age,data=WR2.age)
#' ( WR2.key <- prop.table(raw, margin=1) )
#' # apply the age-length key
#' WR2.len <- alkIndivAge(WR2.key,~len,data=WR2.len)
#' # add length cat to length sample
#' WR2.len$LCat <- lencat(WR2.len$len,w=5)
#' head(WR2.len)
#' # combine orig age & new ages
#' WR2.comb <- rbind(WR2.age, WR2.len)
#' Summarize(len~age,data=WR2.comb,digits=2)
#'
#' ## Third Example -- Uneven breaks for length categories
#' WR3 <- WR79
#' # set up uneven breaks
#' brks <- c(seq(35,100,5),110,130)
#' WR3$LCat <- lencat(WR3$len,breaks=brks)
#' WR3.age <- subset(WR3, !is.na(age))
#' WR3.len <- subset(WR3, is.na(age))
#' head(WR3.len)
#' raw <- xtabs(~LCat+age,data=WR3.age)
#' ( WR3.key <- prop.table(raw, margin=1) )
#' WR3.len <- alkIndivAge(WR3.key,age~len,data=WR3.len,breaks=brks)
#' head(WR3.len)
#' WR3.comb <- rbind(WR3.age, WR3.len)
#' Summarize(len~age,data=WR3.comb,digits=2)
#'
#' @export alkIndivAge
#' @rdname alkIndivAge
alkIndivAge <- function(key,formula,data,type=c("SR","CR"),
                        breaks=NULL,seed=NULL) {
  ## some checks
  type <- match.arg(type)
  key <- iCheckALK(key,only1=TRUE,remove0rows=TRUE)
  
  ## Perform some checks on the formula
  tmp <- iHndlFormula(formula,data,expNumE=1,expNumR=1)
  # handle differently depending on how many variables were in the formula
  if (tmp$vnum==1) {
    if (!tmp$vclass %in% c("numeric","integer"))
      STOP("RHS variable must be numeric.")
    ca <- "age"
    cl <- tmp$vname
  } else if (tmp$vnum==2) {
    if (!tmp$metExpNumE)
      STOP("'alkIndivAge' must have only one RHS variable.")
    if (!tmp$Eclass %in% c("numeric","integer"))
      STOP("RHS variable must be numeric.")
    if (!tmp$Rclass %in% c("numeric","integer"))
      STOP("LHS variable must be numeric.")
    cl <- tmp$Enames
    ca <- tmp$Rname
  } else STOP("'formula' must have only one variable on LHS and RHS.")
  #Check for NA's
  if (any(is.na(data[,cl]))) 
    STOP("Length variable contains 'NA's; Please remove these fish from the length sample before using 'alkIndivAge()'.")
  ## Set the random seed if asked to do so
  if (!is.null(seed)) set.seed(seed)
  ## Begin process
  # Find the length categories that are present in the key
  da.len.cats <- as.numeric(rownames(key))
  # Check about min and max value in length sample relative to same on key
  if (min(data[,cl],na.rm=TRUE)<min(da.len.cats)) {
    STOP("The minimum observed length in the length sample (",
         min(data[,cl],na.rm=TRUE),
         ") is less than the smallest length category in the age-length key (",
         min(da.len.cats),
         "). You should include fish of these lengths in your age sample\n",
         " or exclude fish of this length from your length sample.\n")
  }
  # Find the minimum width of the length categories so that this can be used
  #   in the check for the maximum length without being too sensitive. In other
  #   words, if the maximum observed length is greater than the maximum length
  #    category in the ALK PLUS the minimum width of length categories then
  #    don't send the message.
  min.w <- min(diff(da.len.cats))
  if (max(data[,cl],na.rm=TRUE)>(max(da.len.cats)+min.w)) {
    WARN("The maximum observed length in the length sample (",
         max(data[,cl],na.rm=TRUE),
         ") is greater",
         " than the largest length category in the age-length key (",
         max(da.len.cats),
         "). The last length category will be treated as all-inclusive.")
  }
  # Create length categories var (TMPLCAT) for L sample
  if (is.null(breaks)) breaks <- da.len.cats
  suppressWarnings(data <- lencat(stats::as.formula(paste("~",cl)),data=data,
                                  breaks=breaks,as.fact=FALSE,vname="TMPLCAT"))
  # Find Vector of length cats present in L sample
  data.len.cats <- as.numeric(names(table(data$TMPLCAT)))                                  
  # Add variable for ages for L sample (initially NAs)
  if (!any(names(data)==ca)) {
    data <- data.frame(data,rep(NA,length(data[,cl])))
    names(data)[ncol(data)] <- ca
  }
  # Find vector of age categories in key
  age.cats <- as.numeric(colnames(key))
  # Perform the randomization depending on type chosen by user
  switch(type,
    SR=,Sr=,sr=,S=,s= {data <- iAgeKey.SR(key,age.cats,data,data.len.cats,ca)},
    CR=,Cr=,cr=,C=,c= {data <- iAgeKey.CR(key,age.cats,data,ca)}
  )
  # Remove length category column that was added
  data[,names(data)!="TMPLCAT"]
}


##############################################################
## Semi-random assignment internal function
##############################################################
iAgeKey.SR <- function(key,age.cats,data,data.len.cats,ca) {                        
  for (i in data.len.cats) {  ### Cycle through len categories in L sample
    # Number in len interval from L sample
    len.n <- nrow(data[data$TMPLCAT==i,])
    # Conditional probability of age for len interval
    age.prob <- key[as.numeric(rownames(key))==i,]
    # Integer number of fish for each age
    age.freq <- floor(len.n*age.prob)
    # Vector of ages for integer counts
    ages <- rep(age.cats,age.freq)
    # Identify and deal with fractionality
    if (length(ages)<len.n) {
      # How many fish must be added?
      num.add <- len.n-length(ages)
      # Randomly ages for added fish
      ages.add <- sample(age.cats,num.add,replace=TRUE,prob=age.prob)
      # Add additional fish ages to end
      ages <- c(ages,ages.add)
    }
    # Randomly mix up the ages vector
    if (length(ages)>1) { ages <- sample(ages,length(ages),replace=FALSE) }
    # Replace rows of age col w/ assigned ages
    data[data$TMPLCAT==i,ca] <- ages
  }
  data
}

##############################################################
## Completely random assignment internal function
##############################################################
iAgeKey.CR <- function(key,age.cats,data,ca) {
  for (i in 1:dim(data)[1]) { #### Cycle through the fish
    # Conditional probability of age for length interval
    age.prob <- key[as.numeric(rownames(key))==data$TMPLCAT[i],]
    data[i,ca] <- sample(age.cats,1,prob=age.prob)                              
  }
  data
}
