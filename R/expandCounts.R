#' @title Repeat individual fish data (including lengths) from tallied counts.
#' 
#' @description Repeat individual fish data, including lengths, from tallied counts and, optionally, add a random digit to length measurements to simulate actual length of fish in the bin. This is useful as a precursor to summaries that require information, e.g., lengths, of individual fish (e.g., length frequency histograms, means lengths).
#' 
#' @details Fisheries data may be recorded as tallied counts in the field. For example, field biologists may have simply recorded that there were 10 fish in one group, 15 in another, etc. More specifically, the biologist may have recorded that there were 10 male Bluegill from the first sampling event between 100 and 124 mm, 15 male Bluegill from the first sampling event between 125 and 149 mm, and so on. At times, it may be necessary to expand these counts such that the repeated information appears in individual rows in a new data.frame. In this specific example, the tallied counts would be repeated such that the male, Bluegill, first sampling event, 100-124 mm information would be repeated 10 times; the male, Bluegill, first sampling event, 125-149 mm information would be repeated 15 times, and so on. This function facilitates this type of expansion.
#' 
#' Length data has often been collected in a \dQuote{binned-and-tallied} format (e.g., 10 fish in the 100-124 mm group, 15 in the 125-149 mm group, etc.). This type of data collection does not facilitate easy or precise calculations of summary statistics of length (i.e., mean and standard deviations of length). Expanding the data as described above does not solve this problem because the length data are still essentially categorical (i.e., which group the fish belongs to rather than what it's actual length is). To facilitate computation of summary statistics, the data can be expanded as described above and then a length can be randomly selected from within the recorded length bin to serve as a \dQuote{measured} length for that fish. This function performs this type of expansion by randomly selecting the length from a uniform distribution within the length bin (e.g., each value between 100 and 124 mm has the same probability of being selected).
#' 
#' This function makes some assumptions for some coding situations. First, it assumes that all \code{lowerbin} values are actually lower than all \code{upperbin} values. The function will throw an error if this is not true. Second, it assumes that if a \code{lowerbin} but no \code{upperbin} value is given then the \code{lowerbin} value is the exact measurement for those fish. Third, it assumes that if an \code{upperbin} but no \code{lowerbin} value is given that this is a data entry error and that the \code{upperbin} value should be the \code{lowerbin} value. Fourth, it assumes that it is a data entry error if \code{varcount} is zero or \code{NA} and \code{lowerbin} or \code{upperbin} contains values (i.e., why would there be lengths if no fish were captured?).
#' 
#' @param cform A formula of the form \code{~countvar} where \code{countvar} generically represents the variable in \code{data} that contains the counts of individuals. See details.
#' @param lform An optional formula of the form \code{~lowerbin+upperbin} where \code{lowerbin} and \code{upperbin} generically represent the variables in \code{data} that identify the lower- and upper-values of the length bins. See details.
#' @param data A data.frame that contains variables in \code{cform} and \code{lform}.
#' @param removeCount A single logical that indicates if the variable that contains the counts of individuals (as given in \code{cform}) should be removed form the returned data.frame. The default is \code{TRUE} such that the variable will be removed as the returned data.frame contains individuals and the counts of individuals in tallied bins is not relevant to an individual.
#' @param lprec A single numeric that controls the precision to which the random lengths are recorded. See details.
#' @param new.name A single string that contains a name for the new length variable if random lengths are to be created.
#' @param cwid A single positive numeric that will be added to the lower length bin value in instances where the count exceeds one but only a lower (and not an upper) length were recorded. See details.
#' @param verbose A logical indicating whether progress message should be printed or not.
#' @param \dots Not yet implemented.
#' 
#' @return A data.frame of the same structure as \code{data} except that the variable in \code{cform} may be deleted and the variable in \code{new.name} may be added. The returned data.frame will have more rows than \code{data} because of the potential addition of new individuals expanded from the counts in \code{cform}.
#' 
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#' 
#' @seealso See \code{\link{expandLenFreq}} for expanding length frequencies where individual fish measurements were made on individual fish in a subsample and the remaining fish were simply counted.
#' 
#' @keywords manip
#'
#' @examples
#' # all need expansion
#' ( d1 <- data.frame(name=c("Johnson","Johnson","Jones","Frank","Frank","Max"),
#'                    lwr.bin=c(15,15.5,16,16,17,17),
#'                    upr.bin=c(15.5,16,16.5,16.5,17.5,17.5),
#'                    freq=c(6,4,2,3,1,1)) )
#' expandCounts(d1,~freq)
#' expandCounts(d1,~freq,~lwr.bin+upr.bin)
#' 
#' # some need expansion
#' ( d2 <- data.frame(name=c("Johnson","Johnson","Jones","Frank","Frank","Max"),
#'                    lwr.bin=c(15,15.5,16,16,17.1,17.3),
#'                    upr.bin=c(15.5,16,16.5,16.5,17.1,17.3),
#'                    freq=c(6,4,2,3,1,1)) )
#' expandCounts(d2,~freq)
#' expandCounts(d2,~freq,~lwr.bin+upr.bin)
#' 
#' # none need expansion
#' ( d3 <- data.frame(name=c("Johnson","Johnson","Jones","Frank","Frank","Max"),
#'                    lwr.bin=c(15,15.5,16,16,17.1,17.3),
#'                    upr.bin=c(15,15.5,16,16,17.1,17.3),
#'                    freq=c(6,4,2,3,1,1)) )
#' expandCounts(d3,~freq)
#' expandCounts(d3,~freq,~lwr.bin+upr.bin)
#' 
#' # some need expansion, but different bin widths
#' ( d4 <- data.frame(name=c("Johnson","Johnson","Jones","Frank","Frank","Max"),
#'                    lwr.bin=c(15,  15,  16,  16,  17.1,17.3),
#'                    upr.bin=c(15.5,15.9,16.5,16.9,17.1,17.3),
#'                    freq=c(6,4,2,3,1,1)) )
#' expandCounts(d4,~freq)
#' expandCounts(d4,~freq,~lwr.bin+upr.bin)
#' 
#' # some need expansion but include zeros and NAs for counts
#' ( d2a <- data.frame(name=c("Johnson","Johnson","Jones","Frank","Frank","Max","Max","Max","Max"),
#'                     lwr.bin=c(15,  15.5,16  ,16  ,17.1,17.3,NA,NA,NA),
#'                     upr.bin=c(15.5,16  ,16.5,16.5,17.1,17.3,NA,NA,NA),
#'                     freq=c(6,4,2,3,1,1,NA,0,NA)) )
#' expandCounts(d2a,~freq,~lwr.bin+upr.bin)
#'  
#' # some need expansion but include NAs for upper values
#' ( d2b <- data.frame(name=c("Johnson","Johnson","Jones","Frank","Frank","Max"),
#'                     lwr.bin=c(15,  15.5,16  ,16  ,17.1,17.3),
#'                     upr.bin=c(NA  ,NA  ,16.5,16.5,17.1,17.3),
#'                     freq=c(6,4,2,3,1,1)) )
#' expandCounts(d2b,~freq,~lwr.bin+upr.bin)
#'  
#' # some need expansion but include NAs for upper values
#' ( d2c <- data.frame(name=c("Johnson","Johnson","Jones","Frank","Frank","Max"),
#'                     lwr.bin=c(NA,NA,  16  ,16  ,17.1,17.3),
#'                     upr.bin=c(15,15.5,16.5,16.5,17.1,17.3),
#'                     freq=c(6,4,2,3,1,1)) )
#' expandCounts(d2c,~freq,~lwr.bin+upr.bin)
#' 
#' \dontrun{
#' ##!!##!!## Change path to where example file is and then run to demo
#' 
#' ## Read in datafile (note periods in names)
#' df <- read.csv("c:/aaawork/consulting/R_WiDNR/Statewide/Surveysummaries2010.csv")
#' str(df) 
#' ## narrow variables for simplicity
#' df1 <- df[,c("County","Waterbody.Name","Survey.Year","Gear","Species",
#'              "Number.of.Fish","Length.or.Lower.Length.IN","Length.Upper.IN",
#'              "Weight.Pounds","Gender")]
#' ## Sum the count to see how many fish there should be after expansion
#' sum(df1$Number.of.Fish)
#' 
#' ## Simple expansion
#' df2 <- expandCounts(df1,~Number.of.Fish)
#' 
#' ## Same expansion but include random component to lengths (thus new variable)
#' ##   also note default lprec=0.1
#' df3 <- expandCounts(df1,~Number.of.Fish,~Length.or.Lower.Length.IN+Length.Upper.IN)
#' 
#' }
#' 
#' @export
expandCounts <- function(data,cform,lform=NULL,removeCount=TRUE,lprec=0.1,
                         new.name="newlen",cwid=0,verbose=TRUE,...) {
  ## do some error checking on cform (cform changes from a pure formula)
  cform <- iHndlFormula(cform,data)
  if (cform$vnum>1) STOP("'cform' must be only one variable.")
  if (!cform$vclass %in% c("integer","numeric")) STOP("'cform' must be a 'numeric' or 'integer' variable.")
  ## initialize the message
  msg <- "Results messages from expandCounts():\n"
  
  ## find those fish with zero counts or missing value in counts
  zerocounts <- which(data[,cform$vname]==0 | is.na(data[,cform$vname]))
  if (length(zerocounts)>0) {
    if (length(zerocounts)>5) msg <- paste0(msg,length(zerocounts)," rows")
    else msg <- paste0(msg,"  Rows ",iStrCollapse(zerocounts))
    msg <- paste0(msg," had zero or no counts in ",cform$vname,".\n")
  }
  
  ## Expand the rows based on the counts
  #  First, identify Which rows have a count of 1 ...
  onecounts <- which(data[,cform$vname]==1)
  msg <- paste0(msg,"  ",length(onecounts)," rows had an individual measurement.\n")
  #  Second, identify which rows have a count >1
  morecounts <- which(data[,cform$vname]>1)
  tmp <- length(morecounts)
  #  Third, Repeat the row numbers 'count' times for those rows with a count > 1
  morecounts <- rep(morecounts,data[morecounts,cform$vname])
  msg <- paste0(msg,"  ",tmp," rows with multiple measurements were expanded to ",
                length(morecounts)," rows of individual measurements.\n")
  # Fourth, create a new data.frame that combines the original rows
  # that had zero counts, the original rows that had one count, and
  # the original rows with more than one count but with each of these
  # repeated by the count number of times.
  newdf <- rbind(data[zerocounts,],data[onecounts,],data[morecounts,])
  # Fifth, clean-up the new data.frame as requested or needed
  #   remove the counts variable if asked for
  if (removeCount) newdf <- newdf[,names(data)!=cform$vname]
  #   get integer rownames
  row.names(newdf) <- NULL

  ## If lform is provided then create random lengths (create a random
  ## number of the same digits between lwr and upr).
  if (!is.null(lform)) {
    ## do some error checking on lform (lform changes from a pure formula)
    lform <- iHndlFormula(lform,newdf,expNumR=0,expNumE=2,expNumENums=2)
    if (lform$vnum!=2) STOP("'lform' must have two variables on the right-hand-side")
    if (!lform$metExpNumR) STOP("'lform' must not have a left-hand-side")
    if (!lform$metExpNumE) STOP("'lform' must have two variables on the right-hand-side")
    if (!lform$metExpNumENums) STOP("'lform' must have two NUMERIC variables on the right-hand-side")

    ## isolate the lower and upper length variable names (assumed
    ## to be put in formula in order)
    lwr <- lform$Enames[1]
    upr <- lform$Enames[2]
    # error check that lwr>upr ... stop if so.
    tmp <- which(data[,lwr]>data[,upr])
    if (length(tmp)>0) STOP("Rows ",iStrCollapse(tmp)," have '",
                            lwr,"' greater than '",upr,"'.")
    
    ## error check if the rows with zero or missing counts in the
    ## original data.frame had non-missing lwr or upr values. This
    ## implies an odd data entry. Send a warning.
    if (length(zerocounts)>0) {
      tmp <- zerocounts[which(!is.na(data[zerocounts,lwr]) | !is.na(data[zerocounts,upr]))]
      if (length(tmp)>0) {
        emsg <- paste0("Rows ",iStrCollapse(tmp)," had zero or no ",cform$vname)
        emsg <- paste0(emsg," but had non-missing\n values for ",lwr," and ",upr,".")
        emsg <- paste0(emsg,"  This implies a data entry error.")
        STOP(emsg)
      }
    }

    ## Fill the lwr and upr if one or the other is missing
    #  If fish has an upr but no lwr then put upr in lwr
    tmp <- which(is.na(newdf[,lwr]) & !is.na(newdf[,upr]))
    if (length(tmp)>0) newdf[tmp,lwr] <- newdf[tmp,upr]
    #  If fish has a lwr but no upr then either put the lwr in the  upr or put lwr+cwid into upr
    tmp <- which(!is.na(newdf[,lwr]) & is.na(newdf[,upr]))
    if (length(tmp)>0) newdf[tmp,upr] <- newdf[tmp,lwr]+cwid
    
    ## Identify fish that don't need a random digit    
    #  Identify which fish have neither a lower or upper measurement
    nolowup <- which(is.na(newdf[,lwr]) & is.na(newdf[,upr]))
    #  Fish with same lwr and upr (i.e., exact measurements)
    samelowup <- which(newdf[,lwr]==newdf[,upr])
    #  Put together ... these are fish that don't need a random digit
    norand <- c(nolowup,samelowup)

    ## Get a data.frame of fish that don't need a random digit
    ## and add a new variable for length (put lwr length in it)
    ## and add a length note variable
    dfnorand <- newdf[norand,]
    dfnorand[,new.name] <- dfnorand[,lwr]
    if (nrow(dfnorand)>0) dfnorand[,"lennote"] <- "Observed length"
    
    ## Get a data.frame of fish that do need a random length
    ## and if it is not empty then create a new variable with
    ## the random lengths and add a length note variable
    if (length(norand)>0) dfrand <- newdf[-norand,]
      else dfrand <- newdf
    if (nrow(dfrand)>0) {
      ## add uniform random number to fish that need it
      dfrand[,new.name] <- apply(as.matrix(dfrand[,c(lwr,upr)]),1,
                                 function(x) sample(seq(x[1],x[2],lprec),1))
      dfrand[,"lennote"] <- "Expanded length"
    }
    newdf <- rbind(dfnorand,dfrand)
  }
  ## print message about what happened if verbose=TRUE
  if (verbose) message(msg)
  ## return the new data.frame
  newdf
}
