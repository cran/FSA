#' @title Capitalizes the first letter of first or all words in a string.
#' 
#' @description Capitalizes the first letter of first or all words in a string.
#' 
#' @param x A single string.
#' @param which A single string that indicates whether all (the default) or only the first words should be capitalized.
#'
#' @return A single string with the first letter of the first or all words capitalized.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @keywords manip
#'
#' @examples
#' ## Capitalize first letter of all words (the default)
#' capFirst("Derek Ogle")
#' capFirst("derek ogle")
#' capFirst("derek")
#'
#' ## Capitalize first letter of only the first words
#' capFirst("Derek Ogle",which="first")
#' capFirst("derek ogle",which="first")
#' capFirst("derek",which="first")

#' ## apply to all elements in a vector
#' vec <- c("Derek Ogle","derek ogle","Derek ogle","derek Ogle","DEREK OGLE")
#' capFirst(vec)
#' capFirst(vec,which="first")
#'
#' ## check class types
#' class(vec)
#' vec1 <- capFirst(vec)
#' class(vec1)
#' fvec <- factor(vec)
#' fvec1 <- capFirst(fvec)
#' class(fvec1)
#' 
#' @export
capFirst <- function(x,which=c("all","first")) {
  ## Get the class of the object
  cls <- class(x)
  ## Perform a check
  if (!inherits(cls,c("character","factor")))
    STOP("'capFirst' only works with 'character' or 'factor' objects.")
  ## Capitalize the one word or the words in the vector
  if (length(x)==1) x <- iCapFirst(x,which)
  else x <- apply(matrix(x),MARGIN=1,FUN=iCapFirst,which=which)
  ## Change the class to what the original was
  if (cls=="factor") x <- as.factor(x)
  ## Return the object
  x
}

## Internal Function
iCapFirst<- function(x,which=c("all","first")) {
  # See whether all or just the first word should have the first letter capitalized
  which <- match.arg(which)
  # Only process if not NA
  if (!is.na(x)) {
    # convert entire string to lower case ...
    x <- tolower(x)
    # then split on space if more than one word
    s <- strsplit(x, " ")[[1]]
    if (which=="first") {
      # convert first letters of first word to upper-case    
      s1 <- toupper(substring(s, 1,1)[1])
      # attach capitalized first letter to rest of lower-cased original string
      x <- paste(s1,substring(x,2),sep="",collapse=" ")
    } else {
      # convert first letters of all words to upper-case
      s1 <- toupper(substring(s, 1,1))
      # attach capitalized first letter to rest of lower-cased separated strings
      x <- paste(s1,substring(s,2),sep="",collapse=" ")
    }
  }
  x
}


#' @title Converts an R color to RGB (red/green/blue) including a transparency (alpha channel).
#'
#' @description Converts an R color to RGB (red/green/blue) including a transparency (alpha channel). Similar to \code{\link[grDevices]{col2rgb}} except that a transparency (alpha channel) can be included.
#'
#' @param col A vector of any of the three kinds of R color specifications (i.e., either a color name (as listed by \code{\link[grDevices]{colors}}()), a hexadecimal string of the form "#rrggbb" or "#rrggbbaa" (see \code{\link[grDevices]{rgb}}), or a positive integer i meaning \code{\link[grDevices]{palette}}()[i].
#' @param transp A numeric vector that indicates the transparency level for the color. The transparency values must be greater than 0. Transparency values greater than 1 are interpreted as the number of points plotted on top of each other before the transparency is lost and is, thus, transformed to the inverse of the transparency value provided.
#' 
#' @return A vector of hexadecimal strings of the form "#rrggbbaa" as would be returned by \code{\link[grDevices]{rgb}}.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @seealso See \code{\link[grDevices]{col2rgb}} for similar functionality.
#'
#' @keywords manip
#'
#' @examples
#' col2rgbt("black")
#' col2rgbt("black",1/4)
#' clrs <- c("black","blue","red","green")
#' col2rgbt(clrs)
#' col2rgbt(clrs,1/4)
#' trans <- (1:4)/5
#' col2rgbt(clrs,trans)
#' 
#' @export
col2rgbt <- function(col,transp=1) {
  if (length(transp)==1) transp <- rep(transp,length(col))
  if (length(col)!=length(transp))
    STOP("Length of 'transp' must be 1 or same as length of 'col'.")
  mapply(iMakeColor,col,transp,USE.NAMES=FALSE)
}


#' @title Converts "numeric" factor levels to numeric values.
#'
#' @description Converts \dQuote{numeric} factor levels to numeric values.
#'
#' @param object A vector with \dQuote{numeric} factor levels to be converted to numeric values.
#'
#' @return A numeric vector.
#' 
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#' 
#' @keywords manip
#' 
#' @examples
#' junk <- factor(c(1,7,2,4,3,10))
#' str(junk)
#' junk2 <- fact2num(junk)
#' str(junk2)
#'
#' ## ONLY RUN IN INTERACTIVE MODE
#' if (interactive()) {
#' 
#' bad <- factor(c("A","B","C"))
#' # This will result in an error -- levels are not 'numeric'
#' bad2 <- fact2num(bad)
#' 
#' }  ## END IF INTERACTIVE MODE
#' 
#' @export
fact2num <- function(object) {
  ## Don't continue if object is not a factor or character 
  ## i.e., does not fit the purpose of this function
  if (!inherits(object,c("factor","character")))
    STOP("'object' is not a factor or character and",
         "does not fit the purpose of this function.")
  ## Convert factor to character and then numeric
  suppressWarnings(res <- as.numeric(as.character(object)))
  ## If all na's then stop because values were not numeric-like, else return
  if (all(is.na(res)))
    STOP("Conversion aborted because all levels in 'object' are not 'numbers'.")
  else as.vector(res)
}


#' @title Opens web pages associated with the fishR website.
#'
#' @description Opens web pages associated with the \href{https://fishr-core-team.github.io/fishR/}{fishR website} in a browser. The user can open the main page or choose a specific page to open.
#'
#' @param where A string that indicates a particular page on the fishR website to open.
#' @param open A logical that indicates whether the webpage should be opened in the default browser. Defaults to \code{TRUE}; \code{FALSE} is used for unit testing.
#' 
#' @return None, but a webpage will be opened in the default browser.
#' 
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#' 
#' @keywords misc
#' 
#' @examples
#' \dontrun{
#' ## Opens an external webpage ... only run interactively
#' fishR()            # home page
#' fishR("posts")     # blog posts (some examples) page
#' fishR("books")     # examples page
#' fishR("IFAR")      # Introduction to Fisheries Analysis with R page
#' fishR("AIFFD")     # Analysis & Interpretation of Freshw. Fisher. Data page
#' fishR("packages")  # list of r-related fisheries packages
#' fishR("data")      # list of fisheries data sets
#' fishR("teaching")  # teaching resources
#' }
#' 
#' @export
fishR <- function(where=c("home","posts","books","IFAR","AIFFD",
                          "packages","data","teaching"),
                  open=TRUE) {
  where <- match.arg(where)
  tmp <- "https://fishr-core-team.github.io/fishR/"
  switch(where,
         home=     { tmp <- paste0(tmp,"") },
         posts=    { tmp <- paste0(tmp,"blog/") },
         books=    { tmp <- paste0(tmp,"pages/books.html") },
         IFAR=     { tmp <- paste0(tmp,"pages/books.html#introductory-fisheries-analyses-with-r") },
         AIFFD=    { tmp <- paste0(tmp,"pages/books.html#analysis-and-interpretation-of-freshwater-fisheries-data-i") },
         packages= { tmp <- paste0(tmp,"pages/packages.html") },
         data=     { tmp <- paste0(tmp,"pages/data_fishR_alpha.html")},
         teaching= { tmp <- paste0(tmp,"teaching/")}
  )
  if (open) utils::browseURL(tmp)
  invisible(tmp)
}

#' @title Shows rows from the head and tail of a data frame or matrix.
#'
#' @description Shows rows from the head and tail of a data frame or matrix.
#'
#' @param x A data frame or matrix.
#' @param n A single numeric that indicates the number of rows to display from each of the head and tail of structure.
#' @param which A numeric or string vector that contains the column numbers or names to display. Defaults to showing all columns.
#' @param addrownums If there are no row names for the MATRIX, then create them from the row numbers.
#' @param \dots Arguments to be passed to or from other methods.
#'
#' @return A matrix or data.frame with 2*n rows.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @note If \code{n} is larger than the number of rows in \code{x} then all of \code{x} is displayed.
#'
#' @seealso \code{peek}
#'
#' @keywords manip
#'
#' @examples
#' headtail(iris)
#' headtail(iris,10)
#' headtail(iris,which=c("Sepal.Length","Sepal.Width","Species"))
#' headtail(iris,which=grep("Sepal",names(iris)))
#' headtail(iris,n=200)
#'
#' ## Make a matrix for demonstration purposes only
#' miris <- as.matrix(iris[,1:4])
#' headtail(miris)
#' headtail(miris,10)
#' headtail(miris,addrownums=FALSE)
#' headtail(miris,10,which=2:4)
#'
#' ## Make a tibble type from tibble ... note how headtail() is not limited by
#' ##   the tibble restriction on number of rows to show (but head() is).
#' \dontrun{
#'   if (require(tibble)) {
#'     iris2 <- as_tibble(iris)
#'     class(iris2)
#'     headtail(iris2,n=15)
#'     head(iris2,n=15)
#'   }
#' }
#' 
#' @export
headtail <- function(x,n=3L,which=NULL,addrownums=TRUE,...) {
  ## Some checks
  if (!(is.matrix(x) | is.data.frame(x)))
    STOP("'x' must be a matrix or data.frame.")
  if (length(n)!=1L)
    STOP("'n' must be a single number.")
  ## Remove tbl_df class if it exists
  if ("tbl_df" %in% class(x)) x <- as.data.frame(x)
  ## Process data.frame
  N <- nrow(x)
  if (n>=N) tmp <- x
  else {
    h <- utils::head(x,n,...)
    if (addrownums) {
      if (is.null(rownames(x))) rownames(h) <- paste0("[",seq_len(n),",]")
    } else rownames(h) <- NULL
    t <- utils::tail(x,n,addrownums,...)
    tmp <- rbind(h,t)
  }
  if (!is.null(which)) tmp <- tmp[,which]
  tmp
}


#' @title Ratio of lagged observations.
#'
#' @description Computes the ratio of lagged observations in a vector.
#'
#' @details This function behaves similarly to \code{diff()} except that it returns a vector or matrix of ratios rather than differences.
#'
#' @param x A numeric vector or matrix.
#' @param lag An integer representing the lag \sQuote{distance}.
#' @param direction A string that indicates the direction of calculation. A \code{"backward"} indicates that \sQuote{latter} values are divided by \sQuote{former} values. A \code{"forward"} indicates that \sQuote{former} values are divided by \sQuote{latter} values. See examples.
#' @param recursion An integer that indicates the level of recursion for the calculations. A \code{1} will simply compute the ratios. A \code{2}, for example, will compute the ratios, save the result, and then compute the ratios of the results using the same \code{lag}. See examples.
#' @param differences Same as \code{recursion}. Used for symmetry with \code{\link[base]{diff}}.
#' @param \dots Additional arguments to \code{diff()}.
#'
#' @return A vector or matrix of lagged ratios.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @seealso \code{diff}
#'
#' @keywords manip
#'
#' @examples
#' ## Backward lagged ratios
#' # no recursion
#' lagratio(1:10,1)
#' lagratio(1:10,2)
#' # with recursion
#' lagratio(1:10,1,2)
#' lagratio(1:10,2,2)
#' 
#' ## Forward lagged ratios
#' # no recursion
#' lagratio(10:1,1,direction="forward")
#' lagratio(10:1,2,direction="forward")
#' # with recursion
#' lagratio(10:1,1,2,direction="forward")
#' lagratio(10:1,2,2,direction="forward")
#'
#' @export
lagratio <- function(x,lag=1L,recursion=1L,differences=recursion,
                     direction=c("backward","forward"),...) {
  ## Some checks
  direction <- match.arg(direction)
  if(any(x==0))
    STOP("Will not work with zeros in 'x'.")
  if(inherits(x,c("POSIXt","POSIXct")))
    STOP("Function does not work for 'POSIXt' objects.")
  if (!recursion>0) STOP("'recursion' value must be >0.")
  ## Flip vector if ratio direction is forward
  if (direction=="forward") x <- rev(x)
  ## Compute lagged ratio
  res <- exp(diff(log(x),lag=lag,differences=differences,...))
  ## Flip the resulting vector if direction is forward
  if (direction=="forward") res <- rev(res)
  ## Return the result
  res
}


#' @title Constructs the correction-factor used when back-transforming log-transformed values.
#'
#' @description Constructs the correction-factor used when back-transforming log-transformed values according to Sprugel (1983). Sprugel's main formula -- exp((syx^2)/2) -- is used when syx is estimated for natural log transformed data. A correction for any base is obtained by multiplying the syx term by log_e(base) to give exp(((log_e(base)*syx)^2)/2). This more general formula is implemented here (if, of course, the base is exp(1) then the general formula reduces to the original specific formula).
#'
#' @param obj An object from \code{lm}.
#' @param base A single numeric that indicates the base of the logarithm used.
#'
#' @return A numeric value that is the correction factor according to Sprugel (1983).
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @references Sprugel, D.G. 1983. Correcting for bias in log-transformed allometric equations. Ecology 64:209-210.
#'
#' @keywords manip
#'
#' @examples
#' # toy data
#' df <- data.frame(y=rlnorm(10),x=rlnorm(10))
#' df$logey <- log(df$y)
#' df$log10y <- log10(df$y)
#' df$logex <- log(df$x)
#' df$log10x <- log10(df$x)
#' 
#' # model and predictions on loge scale
#' lme <- lm(logey~logex,data=df)
#' ( ploge <- predict(lme,data.frame(logex=log(10))) )
#' ( pe <- exp(ploge) )
#' ( cfe <- logbtcf(lme) )
#' ( cpe <- cfe*pe )
#' 
#' # model and predictions on log10 scale
#' lm10 <- lm(log10y~log10x,data=df)
#' plog10 <- predict(lm10,data.frame(log10x=log10(10)))
#' p10 <- 10^(plog10)
#' ( cf10 <- logbtcf(lm10,10) )
#' ( cp10 <- cf10*p10 )
#' 
#' # cfe and cf10, cpe and cp10 should be equal
#' all.equal(cfe,cf10)
#' all.equal(cpe,cp10)
#' 
#' @rdname logbtcf
#' @export
logbtcf <- function(obj,base=exp(1)) {
  if (!all(class(obj)=="lm")) STOP("'obj' must be from lm().")
  exp(((log(base)*summary(obj)$sigma)^2)/2)
}


#' @name is.odd
#' 
#' @title Determine if a number is odd or even.
#' 
#' @description Determine if a number is odd or even.
#' 
#' @param x A numeric vector.
#' 
#' @return A logical vector of the same length as x.
#' 
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#' 
#' @keywords manip
#' 
#' @aliases is.odd is.even
#' 
#' @examples
#' ## Individual values
#' is.odd(1)
#' is.odd(2)
#' is.even(3)
#' is.even(4)
#' 
#' ## Vector of values
#' d <- 1:8
#' data.frame(d,odd=is.odd(d),even=is.even(d))
NULL

#' @rdname is.odd
#' @export
is.odd <- function (x) iOddEven(x,1)

#' @rdname is.odd
#' @export
is.even <- function(x) iOddEven(x,0)


## Internal function
iOddEven <- function(x,checkval) {
  if (!is.vector(x)) STOP("'x' must be a vector.")
  if (!is.numeric(x)) STOP("'x' must be numeric.")
  x%%2 == checkval
}


#' @title Computes the percentage of values in a vector less than or greater than (and equal to) some value.
#'
#' @description Computes the percentage of values in a vector less than or greater than (and equal to) a user-supplied value.
#' 
#' @details This function is most useful when used with an apply-type of function.
#'
#' @param x A numeric vector.
#' @param val A single numeric value.
#' @param dir A string that indicates whether the percentage is for values in \code{x} that are \dQuote{greater than and equal} \code{"geq"}, \dQuote{greater than} \code{"gt"}, \dQuote{less than and equal} \code{"leq"}, \dQuote{less than} \code{"lt"} the value in \code{val}. 
#' @param na.rm A logical that indicates whether \code{NA} values should be removed (DEFAULT) from \code{x} or not.
#' @param digits A single numeric that indicates the number of decimals the percentage should be rounded to.
#'
#' @return A single numeric that is the percentage of values in \code{x} that meet the criterion in \code{dir} relative to \code{val}.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @keywords misc
#'
#' @examples
#' ## vector of values
#' ( tmp <- c(1:8,NA,NA) )
#' 
#' ## percentages excluding NA values
#' perc(tmp,5)
#' perc(tmp,5,"gt")
#' perc(tmp,5,"leq")
#' perc(tmp,5,"lt")
#' 
#' ## percentages including NA values
#' perc(tmp,5,na.rm=FALSE)
#' perc(tmp,5,"gt",na.rm=FALSE)
#' perc(tmp,5,"leq",na.rm=FALSE)
#' perc(tmp,5,"lt",na.rm=FALSE)
#' 
#' @export
perc <- function(x,val,dir=c("geq","gt","leq","lt"),na.rm=TRUE,
                 digits=getOption("digits")) {
  ## Some checks
  dir <- match.arg(dir)
  if (!inherits(x,c("numeric","integer")))
    STOP("'perc' only works for numeric vectors.")
  if (length(val)>1)
    WARN("Only the first value of 'val' was used.")
  ## Find sample size (don't or do include NA values)
  n <- ifelse(na.rm,length(x[!is.na(x)]),length(x))
  ## Compute percentage in dir(ection) of val(ue), but return
  ##   a NaN if the x has no valid values
  if (n==0) return(NaN)
  else { # find values that fit criterion
    switch(dir,
           geq= {tmp <- x[x>=val]},
           gt = {tmp <- x[x>val]},
           leq= {tmp <- x[x<=val]},
           lt = {tmp <- x[x<val]}
    ) # end switch
    ## must remove NA values (even if asked not to because they
    ## will appear to be less than val ... i.e., NAs were included
    ## in n above if asked for but they should not be included in
    ## the vector of values that fit the criterion) to find
    ## number that match the criterion
    tmp <- length(tmp[!is.na(tmp)])
  }
  round(tmp/n*100,digits)
}


#' @title Peek into (show a subset of) a data frame or matrix.
#'
#' @description Shows the first, last, and approximately evenly spaced rows from a data frame or matrix.
#'
#' @param x A data frame or matrix.
#' @param n A single numeric that indicates the number of rows to display.
#' @param which A numeric or string vector that contains the column numbers or names to display. Defaults to showing all columns.
#' @param addrownums If there are no row names for the MATRIX, then create them from the row numbers.
#'
#' @return A matrix or data.frame with n rows.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @author A. Powell Wheeler, \email{powell.wheeler@@gmail.com}
#'
#' @seealso \code{headtail}
#' 
#' @note If \code{n} is larger than the number of rows in \code{x} then all of \code{x} is displayed.
#'
#' @keywords manip
#'
#' @examples
#' peek(CutthroatAL)
#' peek(CutthroatAL,n=6)
#' peek(CutthroatAL,n=6,which=c("id","y1998","y1999","y2000"))
#'
#' ## Make a matrix for demonstration purposes only
#' mCutthroatAL <- as.matrix(CutthroatAL)
#' peek(mCutthroatAL)
#' peek(mCutthroatAL,n=6)
#' peek(mCutthroatAL,n=6,addrownums=FALSE)
#' peek(mCutthroatAL,n=6,which=2:4)
#'
#' ## Make a tibble type from dplyr ... note how peek() is not limited by
#' ## the tibble restriction on number of rows to show (but head() is).
#' \dontrun{
#'   if (require(dplyr)) {
#'     CutthroatAL2 <- as_tibble(CutthroatAL)
#'     class(CutthroatAL2)
#'     peek(CutthroatAL2,n=6)
#'     head(CutthroatAL2,n=15)
#'   }
#' }
#' 
#' @export
peek <- function(x,n=20L,which=NULL,addrownums=TRUE) {
  ## Some checks
  if (!(is.matrix(x) | is.data.frame(x))) 
    STOP("'x' must be a matrix or data.frame.")
  if (length(n)!=1L) STOP("'n' must be a single number.")
  if (n<1L) STOP("'n' must be greater than 0.")
  ## Remove tbl_df class if it exists
  if ("tbl_df" %in% class(x)) x <- as.data.frame(x)
  ## Get number of rows in x
  N <- nrow(x)
  ## If asked for is greater than size then just return x
  if (n>=N) tmp <- x
  else {
    rows <- c(1,round((1:(n-2))*(N/(n-1)),0),N)
    tmp <- x[rows,,drop=FALSE]
    if (addrownums) {
      if (is.null(rownames(tmp))) rownames(tmp) <- rows
    } else rownames(tmp) <- NULL
  }
  if (!is.null(which)) tmp <- tmp[,which]
  tmp
}


#' @name rcumsum
#' 
#' @title Computes the prior to or reverse cumulative sum of a vector.
#'
#' @description Computes the prior-to (i.e., the cumulative sum prior to but not including the current value) or the reverse (i.e., the number that large or larger) cumulative sum of a vector. Also works for 1-dimensional tables, matrices, and data.frames, though it is best used with vectors.
#'
#' @note An \code{NA} in the vector causes all returned values at and after the first \code{NA} for \code{pcumsum} and at and before the last \code{NA} for \code{rcumsum} to be \code{NA}. See the examples.
#'
#' @param x a numeric object.
#'
#' @return A numeric vector that contains the prior-to or reverse cumulative sums.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @seealso \code{\link{cumsum}}.
#'
#' @keywords misc
#'
#' @examples
#' ## Simple example
#' cbind(vals=1:10,
#'       cum=cumsum(1:10),
#'       pcum=pcumsum(1:10),
#'       rcum=rcumsum(1:10))
#'
#' ## Example with NA
#' vals <- c(1,2,NA,3)
#' cbind(vals,
#'       cum=cumsum(vals),
#'       pcum=pcumsum(vals),
#'       rcum=rcumsum(vals))
#'
#' ## Example with NA
#' vals <- c(1,2,NA,3,NA,4)
#' cbind(vals,
#'       cum=cumsum(vals),
#'       pcum=pcumsum(vals),
#'       rcum=rcumsum(vals))
#'       
#' ## Example with a matrix
#' mat <- matrix(c(1,2,3,4,5),nrow=1)
#' cumsum(mat)
#' pcumsum(mat)
#' rcumsum(mat)
#' 
#' ## Example with a table (must be 1-d)
#' df <- sample(1:10,100,replace=TRUE)
#' tbl <- table(df)
#' cumsum(tbl)
#' pcumsum(tbl)
#' rcumsum(tbl)
#' 
#' ## Example with a data.frame (must be 1-d)
#' df <- sample(1:10,100,replace=TRUE)
#' tbl <- as.data.frame(table(df))[,-1]
#' cumsum(tbl)
#' pcumsum(tbl)
#' rcumsum(tbl)
NULL

#' @rdname rcumsum
#' @export
rcumsum <- function(x) {
  iChkCumSum(x)
  rev(cumsum(rev(x)))
}

#' @rdname rcumsum
#' @export
pcumsum <- function(x) {
  iChkCumSum(x)
  cumsum(x)-x
}

## Internal function for Xcumsum()
iChkCumSum <- function(x) {
  tmp <- class(x)
  if ("matrix" %in% tmp | "data.frame" %in% tmp) {
    if (all(dim(x)!=1)) STOP("'x' is not 1-dimensional.")
  }
  if ("table" %in% tmp | "xtabs" %in% tmp) {
    if (length(dim(x))>1) STOP("'x' is not 1-dimensional.")
  }
  if (!is.numeric(x)) STOP("'x' must be numeric.")
}


#' @title Extract the coefficient of determination from a linear model object.
#' 
#' @description Extracts the coefficient of determination (i.e., \dQuote{r-squared}) from a linear model (i.e., \code{lm}) object.
#' 
#' @details This is a convenience function to extract the \code{r.squared} part from \code{summary(lm)}.
#' 
#' @param object An object saved from \code{lm}.
#' @param digits A single number that is the number of digits to round the returned result to.
#' @param percent A logical that indicates if the result should be returned as a percentage (\code{=TRUE}) or as a proportion (\code{=FALSE}; default).
#' @param \dots Additional arguments for methods.
#' 
#' @return A numeric, as either a proportion or percentage, that is the coefficient of determination for a linear model.
#' 
#' @keywords misc
#' 
#' @aliases rSquared rSquared.default rSquared.lm
#' 
#' @examples
#' lm1 <- lm(mirex~weight, data=Mirex)
#' rSquared(lm1)
#' rSquared(lm1,digits=3)
#' rSquared(lm1,digits=1,percent=TRUE)
#' 
#' ## rSquared only works with lm objects
#' \dontrun{
#' nls1 <- nls(mirex~a*weight^b,data=Mirex,start=list(a=1,b=1))
#' rSquared(nls1)
#' }
#' 
#' @rdname rSquared
#' @export
rSquared <- function(object, ...) {
  UseMethod("rSquared")   
}

#' @rdname rSquared
#' @export
rSquared.default <- function(object, ...) {
  STOP("'rSquared' only works with 'lm', not '",class(object),"', objects")
}

#' @rdname rSquared
#' @export
rSquared.lm <- function(object,digits=getOption("digits"),
                        percent=FALSE,...) {
  r2 <- summary(object)$r.squared
  ifelse(percent,round(r2*100,digits),round(r2,digits))
}


#' @title Find non-repeated consecutive rows in a data.frame.
#'
#' @description Finds the rows in a data.frame that are not repeats of the row immediately above or below it.
#'
#' @param df A data.frame.
#' @param cols2use A string or numeric vector that indicates columns in \code{df} to use. Negative numeric values will not use those columns. Cannot use both \code{cols2use} and \code{col2ignore}.
#' @param cols2ignore A string or numeric vector that indicates columns in \code{df} to ignore. Cannot use both \code{cols2use} and \code{col2ignore}.
#' @param keep A string that indicates whether the \code{first} (DEFAULT) or \code{last} row of consecutive repeated rows should be kept.
#' 
#' @return A single logical that indicates which rows of \code{df} to keep such that no consecutive rows (for the columns used) will be repeated.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @keywords manip
#'
#' @examples
#' test1 <- data.frame(ID=1:10,
#'                     KEEP=c("First","Last","Both","Both","Both",
#'                            "Both","First","Neither","Last","Both"),
#'                     V1=c("a","a","a","B","b","B","A","A","A","a"),
#'                     V2=c("a","a","A","B","B","b","A","A","A","a"))
#' keepFirst <- repeatedRows2Keep(test1,cols2ignore=1:2)
#' keepLast <- repeatedRows2Keep(test1,cols2use=3:4,keep="last")
#' data.frame(test1,keepFirst,keepLast)
#' 
#' droplevels(subset(test1,keepFirst))  # should be all "First" or "Both" (7 items)
#' droplevels(subset(test1,keepLast))   # should be all "Last" or "Both" (7 items)
#' 
#' @export
repeatedRows2Keep <- function(df,cols2use=NULL,cols2ignore=NULL,
                              keep=c("first","last")) {
  ## Internal Function
  ### from www.cookbook-r.com/Manipulating_data/Comparing_vectors_or_factors_with_NA/
  iCompareNA <- function(v1,v2) {
    same <- (v1 == v2) | (is.na(v1) & is.na(v2))
    same[is.na(same)] <- FALSE
    same
  }
  ## Main Function
  keep <- match.arg(keep)
  # make sure df is a data.frame (could be sent as a matrix)
  df <- as.data.frame(df)
  if (nrow(df)==1) res <- FALSE
  else {
    # change data.frame based on cols2use or cols2ignore
    df <- iHndlCols2UseIgnore(df,cols2use,cols2ignore)
    ## get data.frames offset by 1 indice for comparisons
    df1 <- df[1:(nrow(df)-1),]
    df2 <- df[2:nrow(df),]
    ## compare data.frames
    if (keep=="first") { # returns first of the repeats
      # find rows where all are TRUE (consecutive rows repeat)
      # first row cannot be a repeat so put FALSE in its place
      res <- iCompareNA(df1,df2)
      if (is.matrix(res)) res <- apply(res,MARGIN=1,FUN=all)
      res <- c(FALSE,res)
    } else { # returns last of the repeats
      # reverse the order of the data.frames
      df1a <- df1[nrow(df1):1,]
      df2a <- df2[nrow(df2):1,]
      # find rows where all are TRUE (consecutive row repeats), but reverse the
      # order to return; last row can't be a repeat so put FALSE in its place
      res <- iCompareNA(df2a,df1a)
      if (is.matrix(res)) res <- apply(res,MARGIN=1,FUN=all)
      res <- c(rev(res),FALSE)
    }
    # remove names attribute
    names(res) <- NULL    
  }
  # reverse the TRUE/FALSEs so that TRUE means rows to keep (not rows repeated)
  !res
}

#' @title Computes standard error of the mean.
#'
#' @description Computes the standard error of the mean (i.e., standard deviation divided by the square root of the sample size).
#'
#' @details
#' The standard error of the value in vector \code{x} is simply the standard deviation of \code{x} divided by the square root of the number of valid items in \code{x}
#' 
#' @param x A numeric vector.
#' @param na.rm A logical that indicates whether missing values should be removed before computing the standard error.
#' 
#' @return A single numeric that is the standard error of the mean of \code{x}.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @seealso See \code{se} in \pkg{sciplot} for similar functionality.
#'
#' @keywords manip
#'
#' @examples
#' # example vector
#' x <- 1:20
#' se(x)
#' sd(x)/sqrt(length(x))   ## matches
#' 
#' # all return NA if missing values are not removed
#' x2 <- c(x,NA)
#' sd(x2)/sqrt(length(x2))
#' 
#' # Better if missing values are removed
#' se(x2)              ## Default behavior
#' sd(x2,na.rm=TRUE)/sqrt(length(x2[complete.cases(x2)]))  ## Matches
#' se(x2,na.rm=FALSE)  ## Result from not removing NAs
#' 
#' @export
se <- function (x,na.rm=TRUE) {
  if (!is.vector(x)) STOP("'x' must be a vector.")
  if (!is.numeric(x)) STOP("'x' must be numeric.")
  if (na.rm) x <- x[stats::complete.cases(x)]
  sqrt(stats::var(x)/length(x))
}


#' @title Finds the number of valid (non-NA) values in a vector.
#'
#' @description Finds the number of valid (non-NA) values in a vector.
#'
#' @param object A vector.
#'
#' @return A single numeric value that is the number of non-\code{NA} values in a vector.
#' 
#' @seealso See \code{\link[plotrix]{valid.n}} in \pkg{plotrix} and \code{nobs} in \pkg{gdata} for similar functionality. See \code{\link{is.na}} for finding the missing values.
#' 
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @section IFAR Chapter: 2-Basic Data Manipulations.
#' 
#' @keywords manip
#' 
#' @examples
#' junk1 <- c(1,7,2,4,3,10,NA)
#' junk2 <- c("Derek","Hugh","Ogle","Santa","Claus","Nick",NA,NA)
#' junk3 <- factor(junk2)
#' junk4 <- c(TRUE,TRUE,FALSE,FALSE,FALSE,TRUE,NA,NA)
#' junk5 <- data.frame(junk1)
#' junk6 <- data.frame(junk3)
#' 
#' validn(junk1)
#' validn(junk2)
#' validn(junk3)
#' validn(junk4)
#' validn(junk5)
#' validn(junk6)
#'  
#' @export
validn <- function(object) {
  ## Handle data.frame
  if (is.data.frame(object)) {
    if (ncol(object)==1) object <- object[,1]
    else STOP("'object' cannot be a data.frame with more than one column.")
  }
  ## Handle matrix
  if (is.matrix(object)) {
    if (ncol(object)==1) object <- object[,1]
    else STOP("'object' cannot be a matrix with more than one column.")
  }
  sum(!is.na(object))
}


#' @title Calculates the geometric mean or geometric standard deviation.
#' 
#' @description Calculates the geometric mean or standard deviation of a vector of numeric values.
#' 
#' @details The geometric mean is computed by log transforming the raw data in \code{x}, computing the arithmetic mean of the transformed data, and back-transforming this mean to the geometric mean by exponentiating.
#' 
#' The geometric standard deviation is computed by log transforming the raw data in \code{x}, computing the arithmetic standard deviation of the transformed data, and back-transforming this standard deviation to the geometric standard deviation by exponentiating.
#' 
#' @param x Vector of numeric values.
#' @param na.rm Logical indicating whether to remove missing values or not.
#' @param zneg.rm Logical indicating whether to ignore or remove zero or negative values found in \code{x}.
#' 
#' @return A numeric value that is the geometric mean or geometric standard deviation of the numeric values in \code{x}.
#' 
#' @note This function is largely an implementation of the code suggested by Russell Senior on R-help in November, 1999.
#' 
#' @seealso See \code{geometric.mean} in \pkg{psych} and \code{Gmean} for geometric mean calculators. See \code{Gsd} (documented with \code{Gmean}) from \pkg{DescTools} for geometric standard deviation calculators.
#' 
#' @keywords misc
#' 
#' @aliases geomean geosd
#' 
#' @examples
#' ## generate random lognormal data
#' d <- rlnorm(500,meanlog=0,sdlog=1)
#' # d has a mean on log scale of 0; thus, gm should be exp(0)~=1
#' # d has a sd on log scale of 1; thus, gsd should be exp(1)~=2.7
#' geomean(d)
#' geosd(d)
#' 
#' \dontrun{
#' ## Demonstrate handling of zeros and negative values
#' x <- seq(-1,5)
#' # this will given an error
#' geomean(x)
#' # this will only give a warning, but might not be what you want
#' geomean(x,zneg.rm=TRUE)
#' }
#' 
#' @rdname geomean
#' @export
geomean <- function(x,na.rm=FALSE,zneg.rm=FALSE) {
  x <- iChk4Geos(x,na.rm,zneg.rm)
  exp(mean(log(x),na.rm=na.rm))
}

#' @rdname geomean
#' @export
geosd <- function(x,na.rm=FALSE,zneg.rm=FALSE) {
  x <- iChk4Geos(x,na.rm,zneg.rm)
  exp(stats::sd(log(x),na.rm=na.rm))
}


iChk4Geos <- function(x,na.rm,zneg.rm) {
  if (!is.vector(x))
    STOP("'x' must be a vector.")
  if (!is.numeric(x))
    STOP("'x' must be a numeric vector.")
  if (any(x<=0,na.rm=na.rm) & !zneg.rm)
    STOP("'x' must contain all positive values.")
  if (any(x<=0,na.rm=na.rm) & zneg.rm) {
    WARN("Some non-positive values were ignored/removed.")
    # remove non-positive values
    x <- x[x>0]
  }
  x
}
