#' @title Computes Chapman-Robson estimates of S and Z.
#'
#' @description Computes the Chapman-Robson estimates of annual survival rate (S) and instantaneous mortality rate (Z) from catch-at-age data on the descending limb of a catch-curve. Method functions extract estimates with associated standard errors and confidence intervals. A plot method highlights the descending-limb, shows the linear model on the descending limb, and, optionally, prints the estimated Z and A.
#'
#' @details The default is to use all ages in the age vector. This is only appropriate if the age and catch vectors contain only the ages and catches on the descending limb of the catch curve. Use \code{ages2use} to isolate only the catch and ages on the descending limb.
#'
#' The Chapman-Robson method provides an estimate of the annual survival rate, with the annual mortality rate (A) determined by 1-S. The instantaneous mortality rate is often computed as -log(S). However, Hoenig \emph{et al.} (1983) showed that this produced a biased (over)estimate of Z and provided a correction. The correction is applied by setting \code{zmethod="Hoenigetal"}. Smith \emph{et al.} (2012) showed that the Hoenig \emph{et al.} method should be corrected for a variance inflation factor. This correction is applied by setting \code{zmethod="Smithetal"} (which is the default behavior). Choose \code{zmethod="original"} to use the original estimates for Z and it's SE as provided by Chapman and Robson.
#' 
#' @param x A numerical vector of the assigned ages in the catch curve or a formula of the form \code{catch~age} when used in \code{chapmanRobson}. An object saved from \code{chapmanRobson} (i.e., of class \code{chapmanRobson}) when used in the methods.
#' @param object An object saved from the \code{chapmanRobson} call (i.e., of class \code{chapmanRobson}).
#' @param catch A numerical vector of the catches or CPUEs for the ages in the catch curve. Not used if \code{x} is a formula.
#' @param data A data frame from which the variables in the \code{x} formula can be found. Not used if \code{x} is not a formula.
#' @param ages2use A numerical vector of the ages that define the descending limb of the catch curve.
#' @param zmethod  A string that indicates the method to use for estimating Z. See details.
#' @param as.df A logical that indicates whether the results of \code{coef}, \code{confint}, or \code{summary} should be returned as a data.frame. Ignored in \code{summary} if \code{parm="lm"}.
#' @param incl.est A logical that indicated whether the parameter point estimate should be included in the results from \code{confint}. Defaults to \code{FALSE}.
#' @param verbose A logical that indicates whether the method should return just the estimate (\code{FALSE}; default) or a more verbose statement.
#' @param pos.est A string to identify where to place the estimated mortality rates on the plot. Can be set to one of \code{"bottomright"}, \code{"bottom"}, \code{"bottomleft"}, \code{"left"}, \code{"topleft"}, \code{"top"}, \code{"topright"}, \code{"right"} or \code{"center"} for positioning the estimated mortality rates on the plot. Typically \code{"bottomleft"} (DEFAULT) and \code{"topright"} will be \dQuote{out-of-the-way} placements. Set \code{pos.est} to \code{NULL} to remove the estimated mortality rates from the plot.
#' @param cex.est A single numeric character expansion value for the estimated mortality rates on the plot.
#' @param round.est A numeric that indicates the number of decimal place to which Z (first value) and S (second value) should be rounded. If only one value then it will be used for both Z and S.
#' @param ylab A label for the y-axis (\code{"Catch"} is the default).
#' @param xlab A label for the x-axis (\code{"Age"} is the default).
#' @param ylim A numeric for the limits of the y-axis. If \code{NULL} then will default to 0 or the lowest catch and a maximum of the maximum catch. If a single value then it will be the maximum of the y-axis. If two values then these will the minimum and maximum values of the y-axis.
#' @param col.pt A string that indicates the color of the plotted points.
#' @param axis.age A string that indicates the type of x-axis to display. The \code{age} will display only the original ages, \code{recoded age} will display only the recoded ages, and \code{both} (DEFAULT) displays the original ages on the main axis and the recoded ages on the secondary axis.
#' @param parm A numeric or string (of parameter names) vector that specifies which parameters are to be given confidence intervals  If missing, all parameters are considered.
#' @param conf.level A number representing the level of confidence to use for constructing confidence intervals.
#' @param level Same as \code{conf.level}. Used for compatibility with the generic \code{confint} function.
#' @param \dots Additional arguments for methods.
#'
#' @return A list with the following items:
#'  \itemize{
#'    \item age the original vector of assigned ages.
#'    \item catch the original vector of observed catches or CPUEs.
#'    \item age.e a vector of assigned ages used to estimate mortalities.
#'    \item catch.e a vector of catches or CPUEs used to estimate mortalities.
#'    \item age.r a vector of recoded ages used to estimate mortalities. See references.
#'    \item n a numeric holding the intermediate calculation of n. See references.
#'    \item T a numeric holding the intermediate calculation of T. See references.
#'    \item est A 2x2 matrix that contains the estimates and standard errors for S and Z.
#'  }
#'
#' @section Testing: Tested the results of chapmanRobson against the results in Miranda and Bettoli (2007). The point estimates of S matched perfectly but the SE of S did not because Miranda and Bettoli used a rounded estimate of S in the calculation of the SE of S but chapmanRobson does not.
#' 
#' Tested the results against the results from \code{agesurv} in \pkg{fishmethods} using the \code{rockbass} data.frame in \pkg{fishmethods}. Results for Z and the SE of Z matched perfectly for non-bias-corrected results. The estimate of Z, but not the SE of Z, matched for the bias-corrected (following Smith \emph{et al.} (2012)) results. \pkg{FSA} uses equation 2 from Smith \emph{et al.} (2012) whereas \pkg{fishmethods} appears to use equation 5 from the same source to estimate the SE of Z.
#'
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @section IFAR Chapter: 11-Mortality.
#'
#' @seealso See \code{\link[fishmethods]{agesurv}} in \pkg{fishmethods} for similar functionality. See \code{\link{catchCurve}} and \code{\link[fishmethods]{agesurvcl}} in \pkg{fishmethods} for alternative methods. See \code{\link{metaM}} for empirical methods to estimate natural mortality.
#' 
#' @references Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.
#' 
#' Chapman, D.G. and D.S. Robson. 1960. The analysis of a catch curve. Biometrics. 16:354-368.
#'
#' Hoenig, J.M. and W.D. Lawing, and N.A. Hoenig. 1983. Using mean age, mean length and median length data to estimate the total mortality rate. International Council for the Exploration of the Sea, CM 1983/D:23, Copenhagen.
#'
#' Ricker, W.E. 1975. Computation and interpretation of biological statistics of fish populations. Technical Report Bulletin 191, Bulletin of the Fisheries Research Board of Canada. [Was (is?) from http://www.dfo-mpo.gc.ca/Library/1485.pdf.]
#'
#' Robson, D.S. and D.G. Chapman. 1961. Catch curves and mortality rates. Transactions of the American Fisheries Society. 90:181-189.
#' 
#' Smith, M.W., A.Y. Then, C. Wor, G. Ralph, K.H. Pollock, and J.M. Hoenig. 2012. Recommendations for catch-curve analysis. North American Journal of Fisheries Management. 32:956-967.
#'
#' @keywords htest manip
#'
#' @aliases chapmanRobson chapmanRobson.default chapmanRobson.formula plot.chapmanRobson summary.chapmanRobson confint.chapmanRobson
#'
#' @examples
#' plot(catch~age,data=BrookTroutTH,pch=19)
#' 
#' ## demonstration of formula notation
#' cr1 <- chapmanRobson(catch~age,data=BrookTroutTH,ages2use=2:6)
#' summary(cr1)
#' summary(cr1,verbose=TRUE)
#' coef(cr1)
#' confint(cr1)
#' confint(cr1,incl.est=TRUE)
#' plot(cr1)
#' plot(cr1,axis.age="age")
#' plot(cr1,axis.age="recoded age")
#' summary(cr1,parm="Z")
#' coef(cr1,parm="Z")
#' confint(cr1,parm="Z",incl.est=TRUE)
#' 
#' ## demonstration of excluding ages2use
#' cr2 <- chapmanRobson(catch~age,data=BrookTroutTH,ages2use=-c(0,1))
#' summary(cr2)
#' plot(cr2)
#' 
#' ## demonstration of ability to work with missing age classes
#' age <- c(  2, 3, 4, 5, 7, 9,12)
#' ct  <- c(100,92,83,71,56,35, 1)
#' cr3 <- chapmanRobson(age,ct,4:12)
#' summary(cr3)
#' plot(cr3)
#'
#' ## Demonstration of computation for multiple groups
#' ##   only ages on the descending limb for each group are in the data.frame
#' # Get example data
#' data(FHCatfish,package="FSAdata")
#' FHCatfish
#' 
#' # Note use of incl.est=TRUE and as.df=TRUE
#' if (require(dplyr)) {
#'   res <- FHCatfish %>%
#'     dplyr::group_by(river) %>%
#'     dplyr::group_modify(~confint(chapmanRobson(abundance~age,data=.x),
#'                                  incl.est=TRUE,as.df=TRUE)) %>%
#'     as.data.frame() # removes tibble and grouping structure
#'   res
#' }
#' 
#' ## Demonstration of computation for multiple groups
#' ##   ages not on descending limb are in the data.frame, but use same
#' ##     ages.use= for each group
#' # Get example data
#' data(WalleyeKS,package="FSAdata")
#' 
#' # Note use of incl.est=TRUE and as.df=TRUE
#' if (require(dplyr)) {
#'   res <- WalleyeKS %>%
#'     dplyr::group_by(reservoir) %>%
#'     dplyr::group_modify(~confint(chapmanRobson(catch~age,data=.x,ages2use=2:10),
#'                                  incl.est=TRUE,as.df=TRUE)) %>%
#'     as.data.frame() # removes tibble and grouping structure
#'   res
#' }
#'
#' @rdname chapmanRobson
#' @export
chapmanRobson <- function (x,...) {
  UseMethod("chapmanRobson") 
}

#' @rdname chapmanRobson
#' @export
chapmanRobson.default <- function(x,catch,ages2use=age,
                                  zmethod=c("Smithetal","Hoenigetal","original"),
                                  ...) {
  ## Put x into age variable for rest of function
  age <- x
  
  ## Some Checks
  zmethod <- match.arg(zmethod)
  if (!is.numeric(x)) STOP("'x' must be numeric.")
  if (!is.numeric(catch)) STOP("'catch' must be numeric.")
  if (length(age)!=length(catch)) STOP("'age' and 'catch' are different lengths.")
  # Check to make sure enough ages and catches exist
  if (length(age)<2) STOP("Fewer than 2 data points.")

  ## Isolate the ages and catches to be used
  # Find rows to use according to ages to use, adjust if missing values occur
  rows2use <- iCheck_ages2use(ages2use,age)
  # Create new vectors with just the data to use
  age.e <- age[rows2use]
  catch.e <- catch[rows2use]
  # Check to make sure enough ages and catches exist
  if (length(age.e)<2) STOP("Fewer than 2 data points after applying 'ages2use'.")
  # Create re-coded ages
  age.r <- age.e-min(age.e,na.rm=TRUE)
  
  ## Compute intermediate statistics
  n <- sum(catch.e,na.rm=TRUE)
  T <- sum(age.r*catch.e,na.rm=TRUE)
  ## Estimate S and SE (eqns 6.4 & 6.5 from Miranda & Bettoli (2007))
  S.est <- T/(n+T-1)
  S.SE <- sqrt(S.est*(S.est-((T-1)/(n+T-2))))
  ## Estimate Z and SE
  switch(zmethod,
         original= {
           Z.est <- -log(S.est)
           # from Jensen (1985)
           Z.SE <- S.SE/S.est },
         Hoenigetal= {
           # From eqn 1 in Smith et al. (2012) but noting that their
           #   Tbar is T/n, N is n, and Tc is ignored b/c of the re-coding
           Z.est <- -log(S.est) - ((n-1)*(n-2))/(n*(T+1)*(n+T-1))
           # Square root of eqn 2 in Smith et al. (2012)
           Z.SE <- (1-exp(-Z.est))/sqrt(n*exp(-Z.est)) },
         Smithetal= {
           # Same as for Hoenig et al. but including the chi-square
           #   VIF noted on last full paragraph in the left column
           #   on page 960 of Smith et al.
           Z.est <- -log(S.est) - ((n-1)*(n-2))/(n*(T+1)*(n+T-1))
           Z.SE <- (1-exp(-Z.est))/sqrt(n*exp(-Z.est))
           # Create the VIF as the usual chi-square GOF test 
           #   statistics divided by number of age-groups-1
           exp <- catch.e[1]*S.est^age.r
           chi <- sum(((catch.e-exp)^2)/exp,na.rm=TRUE)
           VIF <- chi/(length(catch[!is.na(catch)])-1)
           # Adjust the Z SE by the square root of the VIF
           Z.SE <- Z.SE*sqrt(VIF) }
  ) # end switch
  ## Prepare result to return
  mres <- cbind(c(100*S.est,Z.est),c(100*S.SE,Z.SE))
  rownames(mres) <- c("S","Z")
  colnames(mres) <- c("Estimate","Std. Error")
  cr <- list(age=age,catch=catch,age.e=age.e,catch.e=catch.e,
             age.r=age.r,n=n,T=T,est=mres)
  class(cr) <- "chapmanRobson"
  cr
}

#' @rdname chapmanRobson
#' @export
chapmanRobson.formula <- function(x,data,ages2use=age,
                                  zmethod=c("Smithetal","Hoenigetal","original"),
                                  ...) {
  ## Handle the formula and perform some checks
  tmp <- iHndlFormula(x,data,expNumR=1,expNumE=1)
  if (!tmp$metExpNumR)
    STOP("'chapmanRobson' must have only one LHS variable.")
  if (!tmp$Rclass %in% c("numeric","integer"))
    STOP("LHS variable must be numeric.")
  if (!tmp$metExpNumE)
    STOP("'chapmanRobson' must have only one RHS variable.")
  if (!tmp$Eclass %in% c("numeric","integer"))
    STOP("RHS variable must be numeric.")
  ## Get variables from model frame
  age <- tmp$mf[,tmp$Enames]
  catch <- tmp$mf[,tmp$Rname]
  ## Call the default function
  chapmanRobson.default(age,catch,ages2use=ages2use,zmethod=zmethod,...)
}

#' @rdname chapmanRobson
#' @export
summary.chapmanRobson <- function(object,parm=c("all","both","Z","S"),
                                  verbose=FALSE,as.df=FALSE,...) {
  parm <- match.arg(parm)
  if (verbose) message("Intermediate statistics: ","n=",object$n,"; T=",object$T)
  # matrix of all possible results
  resm <- object$est
  # data.frame of all possible results
  resd <- data.frame(cbind(t(resm[1,c("Estimate","Std. Error")]),
                           t(resm[2,c("Estimate","Std. Error")])))
  names(resd) <- c("S","S_SE","Z","Z_SE")
  # remove parameters not asked for
  if (!parm %in% c("all","both")) {
    resm <- resm[parm,,drop=FALSE]
    resd <- resd[substr(names(resd),1,1)==parm]
  }
  # prepare to return data.frame if asked for, otherwise matrix
  if (as.df) res <- resd
    else res <- resm
  res
} 

#' @rdname chapmanRobson
#' @export
coef.chapmanRobson <- function(object,parm=c("all","both","Z","S"),as.df=FALSE,...) {
  parm <- match.arg(parm)
  tmp <- summary(object,parm)
  # matrix of lm results
  resm <- tmp[,1]
  names(resm) <- rownames(tmp)
  # data.frame of all possible results
  resd <- data.frame(cbind(t(resm[1]),t(resm[2])))
  names(resd) <- names(resm)
  # remove parameters not asked for
  if (!parm %in% c("all","both")) {
    resm <- resm[parm,drop=FALSE]
    resd <- resd[grepl(parm,names(resd))]
  }
  # prepare to return data.frame if asked for, otherwise matrix
  if (as.df) res <- resd
    else res <- resm
  res
}

#' @rdname chapmanRobson
#' @export
confint.chapmanRobson <- function(object,parm=c("all","both","S","Z"),
                                  level=conf.level,conf.level=0.95,
                                  as.df=FALSE,incl.est=FALSE,...) {
  parm <- match.arg(parm)
  ## Check on conf.level
  iCheckConfLevel(conf.level) 
  
  # matrix of all possible results
  z <- c(-1,1)*stats::qnorm((1-(1-conf.level)/2))
  resm <- cbind(coef.chapmanRobson(object),
                rbind(S=object$est["S","Estimate"]+z*object$est["S","Std. Error"],
                      Z=object$est["Z","Estimate"]+z*object$est["Z","Std. Error"]))
  colnames(resm) <- c("Est",iCILabel(conf.level))
  # data.frame of all possible results
  resd <- data.frame(cbind(t(resm[1,]),t(resm[2,])))
  names(resd) <- c("S","S_LCI","S_UCI","Z","Z_LCI","Z_UCI")
  ## remove estimates if not asked for
  if (!incl.est) {
    resm <- resm[,colnames(resm)!="Est",drop=FALSE]
    resd <- resd[!names(resd) %in% c("S","Z")]
  }
  ## remove unasked for parameters
  if (!parm %in% c("all","both")) {
    resm <- resm[parm,,drop=FALSE]
    resd <- resd[grepl(parm,names(resd))]
  }
  ## Return the appropriate matrix or data.frame
  if (as.df) res <- resd
    else res <- resm
  res
}

#' @rdname chapmanRobson
#' @export
plot.chapmanRobson <- function(x,pos.est="topright",cex.est=0.95,round.est=c(3,1),
                               ylab="Catch",xlab="Age",ylim=NULL,
                               col.pt="gray30",
                               axis.age=c("both","age","recoded age"),...) {
  # nocov start
  # Get axis type
  axis.age <- match.arg(axis.age)
  # May need to make area below x-axis larger to hold both age scales
  npar <- graphics::par(c("mar","mgp"))
  if (axis.age=="both") {
    npar$mar[1] <- 2.25*npar$mar[1]
    withr::local_par(list(mar=npar$mar))
  }
  # Handle ylim ... if null then set at range of log catch (or min at 0)
  #   if only one value then treat that value as the maximum for y-axis
  #   if more than two values then send error
  if (is.null(ylim)) ylim <- c(min(0,min(x$catch,na.rm=TRUE)),
                               max(x$catch,na.rm=TRUE))
  else if (length(ylim)==1) ylim <- c(min(0,min(x$catch,na.rm=TRUE)),ylim)
  else if (length(ylim)>2)
    STOP("'ylim' may not have more than two values.")
  # Plot raw data
  graphics::plot(x$catch~x$age,col=col.pt,
                 xlab="",ylab=ylab,ylim=ylim,xaxt="n",...)
  # Highlight descending limb portion
  graphics::points(x$age.e,x$catch.e,col=col.pt,pch=19)
  # Handle age-axis
  if (axis.age %in% c("both","age")) {
    # Put age (original) on main x-axis of plot 
    graphics::axis(1,at=x$age,labels=x$age,line=npar$mgp[3])
    graphics::mtext(xlab,side=1,line=npar$mgp[1])
  }
  if (axis.age %in% c("both","recoded age")) {
    # Put recoded ages on secondary x-axis of plot
    graphics::axis(1,at=x$age.e,labels=x$age.r,
                   line=ifelse(axis.age=="both",npar$mgp[1]+1.5,npar$mgp[3]))
    graphics::mtext(paste("Recoded",xlab),side=1,
                    line=ifelse(axis.age=="both",2*npar$mgp[1]+1.5,npar$mgp[1]))
  }
  # Put mortality values on plot
  if (!is.null(pos.est)) {
    # Check round.est values first
    if (length(round.est)==1) round.est <- rep(round.est,2)
    else if (length(round.est)>2)
      WARN("'round.est' has more than two values; only first two were used.")
    Z <- round(x$est["Z","Estimate"],round.est[1])
    S <- round(x$est["S","Estimate"],round.est[2])
    graphics::legend(pos.est,legend=paste0("Z=",Z,"\nS=",S,"%"),
                     bty="n",cex=cex.est)
  }
} # nocov end

##############################################################
# INTERNAL FUNCTIONS
##############################################################
# Note that iCheck_age2use() is in catchCurve()
