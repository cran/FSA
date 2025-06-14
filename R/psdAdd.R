#' @title Creates a vector of Gabelhouse lengths for each species in an entire data frame.
#'
#' @description Creates a vector of the Gabelhouse lengths specific to a species for all individuals in an entire data frame.
#' 
#' @param len A numeric vector that contains lengths measurements or a formula of the form \code{len~spec} where \dQuote{len} generically represents the length variable and \dQuote{spec} generically represents the species variable. Note that this formula can only contain two variables and must have the length variable on the left-hand-side and the species variable on the right-hand-side.
#' @param species A character or factor vector that contains the species names. Ignored if \code{len} is a formula.
#' @param group A named list that provides specific choices for \code{group} for species for which more than one set of Gabelhouse lengths exists in \code{\link{PSDlit}}.
#' @param data A data.frame that minimally contains the length measurements and species names if \code{len} is a formula.
#' @param units A string that indicates the type of units used for the lengths. Choices are \code{mm} for millimeters (DEFAULT), \code{cm} for centimeters, and \code{in} for inches.
#' @param use.names A logical that indicates whether the vector returned is numeric (\code{=FALSE}) or string (\code{=TRUE}; default) representations of the Gabelhouse lengths. See details.
#' @param as.fact A logical that indicates that the new variable should be returned as a factor (\code{=TRUE}) or not (\code{=FALSE}). Defaults to same as \code{use.names} unless \code{addLens} is not \code{NULL}, in which case it will default to \code{FALSE}. See details.
#' @param addLens A named list with (possibly named) numeric vectors of lengths that should be used in addition to the Gabelhouse lengths for the species that form the names in the list. See examples.
#' @param verbose A logical that indicates whether detailed messages about species without Gabelhouse lengths or with no recorded values should be printed or not.
#' @param \dots Not used.
#'
#' @details This computes a vector that contains the Gabelhouse lengths specific to each species for all individuals in an entire data frame. The vector can be appended to an existing data.frame to create a variable that contains the Gabelhouse lengths for each individual. The Gabelhouse length value will be \code{NA} for each individual for which Gabelhouse length definitions do not exist in \code{\link{PSDlit}}. Species names in the data.frame must be the same as those used in \code{\link{PSDlit}} (i.e., same spelling and capitalization; use \code{psdVal()} to see the list of species).
#' 
#' Some species have Gabelhouse lengths for sub-groups (e.g., \dQuote{lentic} vs \dQuote{lotic}). For these species, choose which sub-group to use with \code{group}.
#' 
#' Individuals shorter than \dQuote{stock} length will be listed as \code{substock} if \code{use.names=TRUE} or \code{0} if \code{use.names=FALSE}.
#' 
#' Additional lengths to be used for a species may be included by giving a named list with vectors of additional lengths in \code{addLens}. Note, however, that \code{as.fact} will be reset to \code{FALSE} if \code{addLens} are specified, as there is no way to order the names (i.e., factor levels) for all species when additional lengths are used.
#' 
#' See examples and \href{https://fishr-core-team.github.io/FSA/articles/Computing_PSDs.html}{this article} for a demonstration.
#'
#' @return A numeric or factor vector that contains the Gabelhouse length categories.
#' 
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @section IFAR Chapter: 6-Size Structure.
#' 
#' @seealso \code{\link{psdVal}}, \code{\link{psdCalc}}, \code{\link{psdPlot}}, \code{\link{PSDlit}}, and \code{\link{wrAdd}} for related functions. See \code{\link[plyr]{mapvalues}} for help in changing species names to match those in \code{\link{PSDlit}}.
#' 
#' @references Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.
#' 
#' Guy, C.S., R.M. Neumann, and D.W. Willis. 2006. New terminology for proportional stock density (PSD) and relative stock density (RSD): proportional size structure (PSS). Fisheries 31:86-87. [Was (is?) from http://pubstorage.sdstate.edu/wfs/415-F.pdf.]
#'
#' Guy, C.S., R.M. Neumann, D.W. Willis, and R.O. Anderson. 2006. Proportional size distribution (PSD): A further refinement of population size structure index terminology. Fisheries 32:348. [Was (is?) from http://pubstorage.sdstate.edu/wfs/450-F.pdf.]
#'
#' Willis, D.W., B.R. Murphy, and C.S. Guy. 1993. Stock density indices: development, use, and limitations. Reviews in Fisheries Science 1:203-222. [Was (is?) from http://web1.cnre.vt.edu/murphybr/web/Readings/Willis\%20et\%20al.pdf.]
#'
#' @keywords manip
#' 
#' @examples
#' #===== Create random data for three species
#' set.seed(345234534)
#' dbg <- data.frame(species=factor(rep(c("Bluegill"),30)),
#'                   tl=round(rnorm(30,130,50),0))
#' dlb <- data.frame(species=factor(rep(c("Largemouth Bass"),30)),
#'                   tl=round(rnorm(30,350,60),0))
#' dbt <- data.frame(species=factor(rep(c("Bluefin Tuna"),30)),
#'                   tl=round(rnorm(30,1900,300),0))
#' df <- rbind(dbg,dlb,dbt)
#'
#' #===== Simple examples
#' #----- Add variable using category names -- non-formula notation
#' df$PSD <- psdAdd(df$tl,df$species)
#' peek(df,n=6)
#' 
#' #----- Add variable using category names -- formula notation
#' df$PSD1 <- psdAdd(tl~species,data=df)
#' peek(df,n=6)
#' 
#' #----- Add variable using length values as names
#' #      Also turned off messaging of fish not in PSDlit
#' df$PSD2 <- psdAdd(tl~species,data=df,use.names=FALSE,verbose=FALSE)
#' peek(df,n=6)
#' 
#' #----- Same as above but using dplyr
#' if (require(dplyr)) {
#'   df <- df %>%
#'     mutate(PSD1A=psdAdd(tl,species,verbose=FALSE),
#'            PSD2A=psdAdd(tl,species,use.names=FALSE,verbose=FALSE))
#'   peek(df,n=6)
#' }
#' 
#' #===== Adding lengths besides the Gabelhouse lengths
#' #----- Add a "minimum length" for Bluegill
#' df$PSD3 <- psdAdd(tl~species,data=df,verbose=FALSE,
#'                   addLens=list("Bluegill"=c("minLen"=175)))
#' df$PSD3A <- psdAdd(tl~species,data=df,verbose=FALSE,
#'                    addLens=list("Bluegill"=175))
#' df$PSD3B <- psdAdd(tl~species,data=df,verbose=FALSE,
#'                    addLens=list("Bluegill"=c("minLen"=175)),use.names=FALSE)
#' head(df,n=6)
#' 
#' #----- Add add'l lengths and names for Bluegill and Largemouth Bass
#' df$psd4 <- psdAdd(tl~species,data=df,verbose=FALSE,
#'                   addLens=list("Bluegill"=175,
#'                                "Largemouth Bass"=c(254,356)))
#' peek(df,n=20)
#' 
#' #===== Example for a species with sub-groups
#' dbt <- data.frame(species=factor(rep(c("Brown Trout"),30)),
#'                   tl=round(rnorm(30,230,50),0))
#' dlt <- data.frame(species=factor(rep(c("Lake Trout"),30)),
#'                   tl=round(rnorm(30,550,60),0))
#' df2 <- rbind(dbt,dlt)
#' 
#' df2$psd <- psdAdd(tl~species,data=df2,group=list("Brown Trout"="lentic"))
#' peek(df2,n=6)
#' 
#' @rdname psdAdd
#' @export
psdAdd <- function (len,...) {
  UseMethod("psdAdd") 
}

#' @rdname psdAdd
#' @export
psdAdd.default <- function(len,species,group=NULL,units=c("mm","cm","in"),
                           use.names=TRUE,
                           as.fact=ifelse(is.null(addLens),use.names,FALSE),
                           addLens=NULL,verbose=TRUE,...) {
  ## Some checks
  units <- match.arg(units)
  if (!is.numeric(len)) STOP("'len' must be numeric.")
  if (!inherits(species,c("character","factor")))
    STOP("'species' must be character or factor.")
  ## Prepare the PSD literature values data frame
  PSDlit <- FSA::PSDlit
  ##  Find species that have known Gabelhouse lengths
  # get list of species in data
  specs <- unique(species)
  GLHSspecs <- specs[specs %in% unique(PSDlit$species)]
  ## Create data.frames with species that are NA and w/o Gabelhouse lengths and
  ## one with Gabelhouse lengths. The loop below will then start with a 
  ## the non-Gabelhouse species and sequentially add the Gabelhouse fish 
  # Create data.frame with length, species, rownumbers, and PSD values (blank)
  # - rownumbers is needed to get back the original order
  # - PSD will eventually have the Gabelhouse length categories
  data <- data.frame(len,species,rownums=seq_along(len),PSD=rep(NA,length(len)))
  # data.frame where species is NA and doesn't have Gabelhousee length
  ndata <- data[is.na(data$species) | !data$species %in% GLHSspecs,]
  if (verbose & nrow(ndata)>0)
    MESSAGE("Species in the data with no Gabelhouse (PSD) lengths in `PSDlit`: ",
            iStrCollapse(unique(ndata$species)),".")
  # data.frame where species have Gabelhouse lengths ... make sure no NAs
  data <- data[data$species %in% GLHSspecs,]
  data <- data[!is.na(data$species),]

  ## Cycle through each species where PSD values are known, add PSD categories
  ## and append to data.frame that contained species w/o Gabelhouse lengths
  for (i in seq_along(GLHSspecs)) {
    # isolate a data.frame with the current species
    tmpdf <- data[data$species==GLHSspecs[i],]
    # add Gabelhouse lengths ... put in additional lengths if they are provided
    if (GLHSspecs[i] %in% names(addLens))
      tmpAddLens <- addLens[[GLHSspecs[i]]]
    else tmpAddLens <- NULL
    # get the Gabelhouse length categories
    if (!is.null(group)) {
      if (GLHSspecs[i] %in% names(group)) group <- group[[GLHSspecs[i]]]
      else group <- NULL
    }
    glhse <- psdVal(GLHSspecs[i],group=group,units=units,addLens=tmpAddLens)
    # computes the Gabelhouse length categories and adds to the data frame
    if (all(is.na(tmpdf$len))) {
      if (verbose) message("All values in 'len' were missing for ",GLHSspecs[i])
      tmpdf$PSD <- tmpdf$len
    } else tmpdf$PSD <- lencat(tmpdf$len,breaks=glhse,
                               use.names=use.names,as.fact=FALSE)
    # bind current species to the new data frame being created
    ndata <- rbind(ndata,tmpdf)
  }
  ## reorder the data.frame to match original rows
  ndata <- ndata[order(ndata$rownums),]
  ## factor the PSD variable if using category names
  if (as.fact)
    ndata$PSD <- factor(ndata$PSD,
                        levels=c("substock","stock","quality",
                                 "preferred","memorable","trophy"))
  ## return just the vector of PSD values
  ndata$PSD
}

#' @rdname psdAdd
#' @export
psdAdd.formula <- function(len,data=NULL,group=NULL,units=c("mm","cm","in"),
                           use.names=TRUE,
                           as.fact=ifelse(is.null(addLens),use.names,FALSE),
                           addLens=NULL,verbose=TRUE,...) {
  ## Perform some checks on the formula
  tmp <- iHndlFormula(len,data,expNumR=1,expNumE=1,expNumENums=0,expNumEFacts=1)
  if (tmp$vnum!=2)
    STOP("'len' must have one variable on the left-hand-side ",
         "and one variable on the right-hand-side.")
  if (!tmp$metExpNumR)
    STOP("'len' must have a left-hand-side with one and only one variable.")
  if (!(tmp$Rclass %in% c("numeric","integer")))
    STOP("Variable on left-hand-side of 'len' is not numeric",
         " (thus, not lengths).")
  if (!tmp$metExpNumE)
    STOP("'len' must have a right-hand-side with one and only one variable.")
  if (!tmp$metExpNumEFacts)
    STOP("'len' must have one and only one factor variable (species)",
         " on right-hand-side.")
  ## Send to default method
  psdAdd.default(tmp$mf[[tmp$Rpos]],tmp$mf[[tmp$EFactPos]],group,units,
                 use.names,as.fact,addLens,verbose,...)
}
