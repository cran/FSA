#' @title Adds zeros for catches of species not collected in some sampling events.
#'
#' @description Adds zeros for catches of species that were not captured in a sampling event but were captured in at least one other sampling event (i.e., adds zeros to the data.frame for capture events where a species was not observed).
#'
#' @details The data.frame in \code{df} must contain a column that identifies a unique capture event (given in \code{eventvar}), a column with the name for the species captured (given in \code{specvar}), and a column that contains the number of that species captured (potentially given to \code{zerovar}; see details). All sampling event and species combinations where catch information does not exist is identified and a new data.frame that contains a zero for the catch for all of these combinations is created. This new data.frame is appended to the original data.frame to construct a data.frame that contains complete catch information -- i.e., including zeros for species in events where that species was not captured.
#'
#' The data.frame may contain other information related to the catch, such as number of recaptured fish, number of fish released, etc. These additional variables can be included in \code{zerovar} so that zeros will be added to these variables as well (e.g., if the catch of the species is zero, then the number of recaptures must also be zero). All variables not given in \code{eventvar}, \code{specvar}, or \code{zerovar} will be assumed to be related to \code{eventvar} and \code{specvar} (e.g., date, gear type, and habitat) and, thus, will be repeated with these variables.
#' 
#' In situations where no fish were captured in some events, the \code{df} may contain rows that have a value for \code{eventvar} but not for \code{specvar}. These rows are important because zeros need to be added for each observed species for these events. However, in these situations, a \code{<NA>} species will appear in the resulting data.frame. It is unlikely that these \dQuote{missing} species are needed so they will be removed if \code{na.rm=TRUE} (DEFAULT) is used.
#' 
#' One should test the results of this function by creating a frequency table of the \code{eventvar} or \code{specvar}. In either case, the table should contain the same value in each cell of the table. See the examples.
#'
#' @note An error will be returned if either \code{specvar} or \code{eventvar} are factors with any \code{NA} levels. This usually arises if the data.frame was subsetted/filtered prior to using \code{addZeroCatch}. See \code{\link[base]{droplevels}} for descriptions of how to drop unused levels.
#' 
#' @param df A data.frame that contains the capture summary data as described in the details.
#' @param eventvar A string for the variable that identifies unique capture events.
#' @param specvar A string or vector of strings for the variable(s) that identify the \dQuote{species} (if multiple variables, could be species, sex, and life stage, for example) captured. See examples.
#' @param zerovar A string or vector of strings for the variable(s) that should be set equal to zero. See details and examples.
#' @param na.rm A logical that indicates if rows where \code{specvar} that are \code{NA} should be removed after adding the zeros. See details.
#' @return A data.frame with the same structure as \code{df} but with rows of zero observation data appended.
#' 
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @section IFAR Chapter: 2-Basic Data Manipulations
#' 
#' @seealso \code{complete} in \pkg{tidyr} package.
#'
#' @references Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.
#' 
#' @keywords manip
#'
#' @examples
#' ## Example Data #1 (some nets missing some fish, ancillary net data)
#' df1 <- data.frame(net=c(1,1,1,2,2,3),
#'                   eff=c(1,1,1,1,1,1),
#'                   species=c("BKT","LKT","RBT","BKT","LKT","RBT"),
#'                   catch=c(3,4,5,5,4,3))
#' df1
#' # not all 1s
#' xtabs(~net+species,data=df1)
#'
#' df1mod1 <- addZeroCatch(df1,"net","species",zerovar="catch")
#' df1mod1
#' # check, should all be 3
#' xtabs(~net,data=df1mod1)
#' # check, should all be 1
#' xtabs(~net+species,data=df1mod1)
#' # correct mean/sd of catches
#' Summarize(catch~species,data=df1mod1)
#' # incorrect mean/sd of catches (no zeros)
#' Summarize(catch~species,data=df1)
#'
#' # Same as example 1 but with no ancillary data specific to the net number
#' df2 <- df1[,-2]
#' df2
#' df1mod2 <- addZeroCatch(df2,"net","species",zerovar="catch")
#' df1mod2
#' # check, should all be 1
#' xtabs(~net+species,data=df1mod2)
#'
#' ## Example Data #3 (All nets have same species ... no zeros needed)
#' df3 <- data.frame(net=c(1,1,1,2,2,2,3,3,3),
#'                   eff=c(1,1,1,1,1,1,1,1,1),
#'                   species=c("BKT","LKT","RBT","BKT","LKT",
#'                             "RBT","BKT","LKT","RBT"),
#'                   catch=c(3,4,5,5,4,3,3,2,7))
#' df3
#' # should all be 1 for this example
#' xtabs(~net+species,data=df3)
#'
#' # should receive a warning and table should still all be 1
#' df3mod1 <- addZeroCatch(df3,"net","species",zerovar="catch")
#' xtabs(~net+species,data=df3mod1)
#'
#' ## Example Data #4 (another variable that needs zeros)
#' df4 <- df1
#' df4$recaps <- c(0,0,0,1,2,1)
#' df4
#' # not all 1s
#' xtabs(~net+species,data=df4)
#'
#' df4mod1 <- addZeroCatch(df4,"net","species",zerovar=c("catch","recaps"))
#' # note zeros in both variables
#' df4mod1
#' # check, should all be 1
#' xtabs(~net+species,data=df4mod1)
#' # observe difference from next
#' Summarize(catch~species,data=df4)
#' Summarize(catch~species,data=df4mod1)
#' # observe difference from next
#' Summarize(recaps~species,data=df4)
#' Summarize(recaps~species,data=df4mod1)
#'
#' ## Example Data #5 (two "specvar"s)
#' df5 <- df1
#' df5$sex <- c("m","m","f","m","f","f")
#' df5
#' # not all 1s
#' xtabs(~sex+species+net,data=df5)
#' 
#' df5mod1 <- addZeroCatch(df5,"net",c("species","sex"),zerovar="catch")
#' df5mod1
#' # all 1s
#' xtabs(~sex+species+net,data=df5mod1)
#' str(df5mod1) 
#'
#' ## Example Data #6 (three "specvar"s)
#' df6 <- df5
#' df6$size <- c("lrg","lrg","lrg","sm","lrg","sm")
#' df6
#' 
#' df6mod1 <- addZeroCatch(df6,"net",c("species","sex","size"),zerovar="catch")
#' df6mod1
#'  
#' @export
addZeroCatch <- function(df,eventvar,specvar,zerovar,na.rm=TRUE) {
  ## assure that df is a data.frame
  if (!is.data.frame(df)) STOP("'df' must be a data.frame.")
  ## remove "tibble" if it was (tibbles cause problems below)
  if (inherits(df,"tbl_df")) df <- as.data.frame(df)
  ## assure that xvar arguments are not missing
  if (missing(eventvar)) STOP("'eventvar' cannot be missing.")
  if (missing(specvar)) STOP("'specvar' cannot be missing.")
  if (missing(zerovar)) STOP("'zerovar' cannot be missing.")
  ## get names of the variables in df, used at the end to make sure
  ##   that the df is returned with the same order of variables
  dfnames <- names(df)
  ## assure that xvar variables are in the data.frame
  if (!all(eventvar %in% dfnames)) STOP("Not all 'eventvar' found in 'df'.")
  if (!all(specvar %in% dfnames)) STOP("Not all 'specvar' found in 'df'.")
  if (!all(zerovar %in% dfnames)) STOP("Not all 'zerovar' found in 'df'.")
  ## Handle multiple specvar variables
  multSpec <- FALSE
  if (length(specvar)>1) {
    multSpec <- TRUE
    # allow converting back to factors later if only two variables
    if (length(specvar)==2) {
      lvls1 <- lvls2 <- NULL
      if (is.factor(df[,specvar[1]])) lvls1 <- levels(df[,specvar[1]])
      if (is.factor(df[,specvar[2]])) lvls2 <- levels(df[,specvar[2]])
    }
    # keep the old names for later
    ospecvar <- specvar
    # combine the multiple variables into one
    df$speccomb <- interaction(df[,specvar])
    # remove the original variables
    df <- df[,!names(df) %in% specvar]
    # state the new name
    specvar <- "speccomb"
  }
  ## get vectors of event and species names, catches to force
  ##   each to be numeric if it was numeric in the original df
  tmp <- table(df[,eventvar],df[,specvar])
  events <- rownames(tmp)
  if (is.numeric(df[,eventvar])) events <- as.numeric(events)
  species <- colnames(tmp)
  ## identify combos of events and species in df that need zeros
  tmp <- expand.grid(events,species)
  colnames(tmp) <- c(eventvar,specvar)
  all.combos <- paste(tmp[,eventvar],tmp[,specvar],sep=":")
  combos.in.df <- paste(df[,eventvar],df[,specvar],sep=":")
  need0s <- tmp[!(all.combos %in% combos.in.df),]
  ## Catch if there are no need for zeros, send warning, return df
  if (nrow(need0s)==0) {
    WARN("All 'eventvar' have all species in 'specvar'; thus, there are no ",
         "zeros to add. The original data.frame was returned.")
    df
  } else { ## Process because some zeros need to be added
    ## creates vector of names not in eventvar, specvar, or zerovar
    ## these variables are just repeated for each zero that is added
    idvar <- names(df)[!names(df) %in% c(eventvar,specvar,zerovar)]
    ## create a vector full of zeros for zerovar
    zeros <- matrix(0,ncol=length(zerovar),nrow=1)  
    ## Create new rows for the data.frame that contain zeros
    if (length(idvar)==0) { # idvar is empty
      # reorders columns for simplicity
      df <- df[,c(eventvar,specvar,zerovar)]
      # prepare an empty data.frame to receive zeros
      newdf <- df[FALSE,]
      for (i in seq_len(nrow(need0s))) {
        newrow <- data.frame(need0s[i,eventvar],need0s[i,specvar],zeros)
        newdf <- rbind(newdf,newrow)
      }    
    } else { # idvar is not empty
      # reorders columns for simplicity
      df <- df[,c(eventvar,specvar,idvar,zerovar)]
      # prepare an empty data.frame to receive zeros
      newdf <- df[FALSE,]
      for (i in seq_len(nrow(need0s))) {
        newrow <- data.frame(need0s[i,eventvar],need0s[i,specvar],
                             unique(df[df[,eventvar]==need0s[i,eventvar],
                                       idvar]),zeros)
        newdf <- rbind(newdf,newrow)
      }
    }
    ## give newdf the same names as old (re-arranged) df
    names(newdf) <- names(df)
    ## combine new zero rows with original rows
    df <- rbind(df,newdf)
    ## If original specvar contained multiple variables then we
    ##   need to split back out to the original variables
    ##   delete the speccomb variable
    ##   if only two specvar then potentially change back to factors
    ##     with the original levels.
    if (multSpec) {
      specvar <- ospecvar
      df <- cbind(df,do.call(rbind,lapply(strsplit(as.character(df$speccomb),
                                                   "\\."),rbind)))
      names(df)[(ncol(df)-(length(ospecvar)-1)):ncol(df)] <- specvar
      df <- df[,!names(df)=="speccomb"]
      if (length(specvar)==2) {
        if (!is.null(lvls1))
          df[,specvar[1]] <- factor(df[,specvar[1]],levels=lvls1)
        if (!is.null(lvls2))
          df[,specvar[2]] <- factor(df[,specvar[2]],levels=lvls2)
      }

    }
    ## remove NAs in specvar if they exist
    if (na.rm) df <- df[stats::complete.cases(df[,specvar]),]
    ## puts the order of the variables back to the original order
    df[,dfnames]
  }
}
