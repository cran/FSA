#' @title Find reasonable starting values for a von Bertalanffy growth function.
#' 
#' @description Finds reasonable starting values for the parameters in a specific parameterization of the von Bertalanffy growth function.
#' 
#' @details This function attempts to find reasonable starting values for a variety of parameterizations of the von Bertalanffy growth function. There is no guarantee that these starting values are the \sQuote{best} starting values. One should use them with caution and should perform sensitivity analyses to determine the impact of different starting values on the final model results.
#' 
#' If \code{methLinf="Walford"}, then the Linf and K parameters are estimated via the concept of the Ford-Walford plot. If \code{methLinf="oldAge"} then Linf is estimated as the mean length of the \code{num4Linf} longest observed lengths.
#' 
#' The product of the starting values for Linf and K is used as a starting value for omega in the GallucciQuinn and Mooij parameterizations. The result of log(2) divided by the starting value for K is used as the starting value for t50 in the Weisberg parameterization.
#' 
#' If \code{meth0="yngAge"}, then a starting value for t0 or L0 is found by algebraically solving the typical or original parameterization, respectively, for t0 or L0 using the mean length of the first age with more than one data point as a \dQuote{known} quantity. If \code{meth0="poly"} then a second-degree polynomial model is fit to the mean length-at-age data. The t0 starting value is set equal to the root of the polynomial that is closest to zero. The L0 starting value is set equal to the mean length at age-0 predicted from the polynomial function.
#' 
#' Starting values for the L1 and L3 parameters in the Schnute parameterization and the L1, L2, and L3 parameters in the Francis parameterization may be found in two ways. If \code{methEV="poly"}, then the starting values are the predicted length-at-age from a second-degree polynomial fit to the mean lengths-at-age data. If \code{methEV="means"} then the observed sample means at the corresponding ages are used. In the case where one of the supplied ages is fractional, then the value returned will be linearly interpolated between the mean lengths of the two closest ages. The ages to be used for L1 and L3 in the Schnute and Francis parameterizations are supplied as a numeric vector of length 2 in \code{ages2use=}. If \code{ages2use=NULL} then the minimum and maximum observed ages will be used. In the Francis method, L2 will correspond to the age half-way between the two ages in \code{ages2use=}. A warning will be given if L2<L1 for the Schnute method or if L2<L1 or L3<L2 for the Francis method.
#' 
#' Starting values for the Somers and Pauly parameterizations are the same as the traditional parameterization for Linf, K, and t0. However, for the Pauly parameterization the starting value for Kpr is the starting value for K divided by 1 minus the starting value of NGT. The starting values of C, ts, WP, and NGT are set at constants that are unlikely to work for all species. Thus, the user should use the \code{fixed} argument to fix starting values for these parameters that are more likely to result in a reliable fit.
#' 
#' @param formula A formula of the form \code{len~age}.
#' @param data A data frame that contains the variables in \code{formula}.
#' @param type,param A string that indicates the parameterization of the von Bertalanffy model.
#' @param ages2use A numerical vector of the two ages to be used in the Schnute or Francis parameterizations. See details.
#' @param meth0 A string that indicates how the t0 and L0 parameters should be derived. See details.
#' @param methLinf A string that indicates how Linf should be derived. See details.
#' @param num4Linf A single numeric that indicates how many of the longest fish (if \code{methLinf="longFish"}) or how any of the oldest ages (if \code{methLinf="oldAge"}) should be averaged to estimate a starting value for Linf.
#' @param methEV A string that indicates how the lengths of the two ages in the Schnute parameterization or the three ages in the Francis parameterization should be derived. See details.
#' @param valOgle A single named numeric that is the set Lr or tr value for use in \code{type="Ogle"}. See details.
#' @param fixed A named list that contains user-defined rather than automatically generated (i.e., fixed) starting values for one or more parameters. See details.
#' @param plot A logical that indicates whether a plot of the data with the superimposed model fit at the starting values should be created.
#' @param col.mdl A color for the model when \code{plot=TRUE}.
#' @param lwd.mdl A line width for the model when \code{plot=TRUE}.
#' @param lty.mdl A line type for the model when \code{plot=TRUE}.
#' @param cex.main A character expansion value for the main title when \code{plot=TRUE}.
#' @param col.main A color for the main title when \code{plot=TRUE}.
#' @param dynamicPlot DEPRECATED.
#' @param \dots Further arguments passed to the methods.
#' 
#' @return A list that contains reasonable starting values. Note that the parameters will be listed in the same order and with the same names as listed in \code{\link{vbFuns}}.
#' 
#' @note The \sQuote{original} and \sQuote{vonBertalanffy} and the \sQuote{typical} and \sQuote{BevertonHolt} parameterizations are synonymous.
#' 
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#' 
#' @section IFAR Chapter: 12-Individual Growth.
#' 
#' @seealso See \code{\link{growthFunShow}} to display the equations for the parameterizations used in \pkg{FSA} and \code{\link{vbFuns}} for functions that represent the von Bertalanffy parameterizations. See \code{\link{nlsTracePlot}} for help troubleshooting nonlinear models that don't converge.
#' 
#' @references Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.
#' 
#' See references in \code{\link{vbFuns}}.
#' 
#' @keywords manip
#' @examples
#' ## Simple examples of each parameterization
#' vbStarts(tl~age,data=SpotVA1)
#' vbStarts(tl~age,data=SpotVA1,type="Original")
#' vbStarts(tl~age,data=SpotVA1,type="GQ")
#' vbStarts(tl~age,data=SpotVA1,type="Mooij")
#' vbStarts(tl~age,data=SpotVA1,type="Weisberg")
#' vbStarts(tl~age,data=SpotVA1,type="Francis",ages2use=c(0,5))
#' vbStarts(tl~age,data=SpotVA1,type="Schnute",ages2use=c(0,5))
#' vbStarts(tl~age,data=SpotVA1,type="Somers")
#' vbStarts(tl~age,data=SpotVA1,type="Somers2")
#' vbStarts(tl~age,data=SpotVA1,type="Pauly")
#' vbStarts(tl~age,data=SpotVA1,type="Ogle",valOgle=c(tr=0))
#' vbStarts(tl~age,data=SpotVA1,type="Ogle",valOgle=c(Lr=8))
#' 
#' ## Using a different method to find Linf
#' vbStarts(tl~age,data=SpotVA1,methLinf="oldAge")
#' vbStarts(tl~age,data=SpotVA1,methLinf="oldAge",num4Linf=2)
#' vbStarts(tl~age,data=SpotVA1,methLinf="longFish")
#' vbStarts(tl~age,data=SpotVA1,methLinf="longFish",num4Linf=10)
#' vbStarts(tl~age,data=SpotVA1,type="Original",methLinf="oldAge")
#' vbStarts(tl~age,data=SpotVA1,type="Original",methLinf="oldAge",num4Linf=2)
#' vbStarts(tl~age,data=SpotVA1,type="Original",methLinf="longFish")
#' vbStarts(tl~age,data=SpotVA1,type="Original",methLinf="longFish",num4Linf=10)
#' vbStarts(tl~age,data=SpotVA1,type="Ogle",valOgle=c(tr=0),methLinf="oldAge",num4Linf=2)
#' vbStarts(tl~age,data=SpotVA1,type="Ogle",valOgle=c(Lr=8),methLinf="longFish",num4Linf=10)
#' 
#' ## Using a different method to find t0 and L0
#' vbStarts(tl~age,data=SpotVA1,meth0="yngAge")
#' vbStarts(tl~age,data=SpotVA1,type="original",meth0="yngAge")
#' 
#' ## Using a different method to find the L1, L2, and L3
#' vbStarts(tl~age,data=SpotVA1,type="Francis",ages2use=c(0,5),methEV="means")
#' vbStarts(tl~age,data=SpotVA1,type="Schnute",ages2use=c(0,5),methEV="means")
#' 
#' ## Examples with a Plot
#' vbStarts(tl~age,data=SpotVA1,plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="original",plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="GQ",plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Mooij",plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Weisberg",plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Francis",ages2use=c(0,5),plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Schnute",ages2use=c(0,5),plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Somers",plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Somers2",plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Pauly",plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Ogle",valOgle=c(tr=0),plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Ogle",valOgle=c(Lr=8),plot=TRUE)
#' 
#' ## Examples where some parameters are fixed by the user
#' vbStarts(tl~age,data=SpotVA1,fixed=list(Linf=15))
#' vbStarts(tl~age,data=SpotVA1,fixed=list(Linf=15,K=0.3))
#' vbStarts(tl~age,data=SpotVA1,fixed=list(Linf=15,K=0.3,t0=-1))
#' vbStarts(tl~age,data=SpotVA1,fixed=list(Linf=15,K=0.3,t0=-1),plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Pauly",fixed=list(t0=-1.5),plot=TRUE)
#' vbStarts(tl~age,data=SpotVA1,type="Ogle",valOgle=c(tr=2),fixed=list(Lr=10),plot=TRUE)
#' 
#' ## See examples in vbFuns() for use of vbStarts() when fitting Von B models
#' 
#' @export vbStarts
vbStarts <- function(formula,data=NULL,
                     param=c("Typical","typical","Traditional",
                             "traditional","BevertonHolt",
                             "Original","original","vonBertalanffy",
                             "GQ","GallucciQuinn","Mooij","Weisberg","Ogle",
                             "Schnute","Francis",
                             "Somers","Somers2","Pauly"),type=param,
                     fixed=NULL,
                     meth0=c("yngAge","poly"),
                     methLinf=c("Walford","oldAge","longFish"),num4Linf=1,
                     ages2use=NULL,methEV=c("means","poly"),valOgle=NULL,
                     plot=FALSE,col.mdl="gray70",lwd.mdl=3,lty.mdl=1,
                     cex.main=0.9,col.main="red",dynamicPlot=FALSE,...) {
  ## some checks of arguments
  type <- match.arg(type,c("Typical","typical","Traditional",
                           "traditional","BevertonHolt",
                           "Original","original","vonBertalanffy",
                           "GQ","GallucciQuinn","Mooij","Weisberg","Ogle",
                           "Schnute","Francis",
                           "Somers","Somers2","Pauly"))
  meth0 <- match.arg(meth0)
  methLinf <- match.arg(methLinf)
  methEV <- match.arg(methEV)
  if (!is.null(fixed)) {
    if(!is.list(fixed)) STOP("'fixed' must be a list.")
    if (any(names(fixed)=="")) STOP("Items in 'fixed' must be named.")
  }
  ## handle the formula with some checks
  tmp <- iHndlFormula(formula,data,expNumR=1,expNumE=1)
  if (!tmp$metExpNumR) STOP("'vbStarts' must have only one LHS variable.")
  if (!tmp$Rclass %in% c("numeric","integer")) 
    STOP("LHS variable must be numeric.")
  if (!tmp$metExpNumE) STOP("'vbStarts' must have only one RHS variable.")
  if (!tmp$Eclass %in% c("numeric","integer")) 
    STOP("RHS variable must be numeric.")
  ## get the length and age vectors
  len <- tmp$mf[,tmp$Rname[1]]
  age <- tmp$mf[,tmp$Enames[1]]
  ## get starting values depending on type
  switch(type,
    Ogle={ sv <- iVBStarts.Ogle(age,len,type,meth0,methLinf,num4Linf,valOgle,fixed)},
    Typical=,typical=,Traditional=,traditional=,BevertonHolt= {
      type <- "Typical"
      sv <- iVBStarts.typical(age,len,type,meth0,methLinf,num4Linf,fixed) },
    Original=,original=,vonBertalanffy={
      type <- "Original"
      sv <- iVBStarts.original(age,len,type,meth0,methLinf,num4Linf,fixed) },
    GQ=,GallucciQuinn= {
      type <- "GQ"
      sv <- iVBStarts.GQ(age,len,type,meth0,methLinf,num4Linf,fixed) },
    Mooij= { sv <- iVBStarts.Mooij(age,len,type,meth0,methLinf,num4Linf,fixed) },
    Weisberg= { sv <- iVBStarts.Weisberg(age,len,type,meth0,methLinf,num4Linf,fixed) },
    Francis= { sv <- iVBStarts.Francis(age,len,type,methEV,ages2use,fixed) },
    Schnute= { sv <- iVBStarts.Schnute(age,len,type,meth0,methLinf,num4Linf,
                                       methEV,ages2use,fixed) },
    Somers= { sv <- iVBStarts.Somers(age,len,type,meth0,methLinf,num4Linf,fixed) },
    Somers2= { sv <- iVBStarts.Somers2(age,len,type,meth0,methLinf,num4Linf,fixed) },
    Pauly= { sv <- iVBStarts.Pauly(age,len,type,meth0,methLinf,num4Linf,fixed) }
  ) # end 'type' switch
  ## make the static plot if asked for
  if (plot) iVBStartsPlot(age,len,type,sv,ages2use,valOgle,
                          col.mdl,lwd.mdl,lty.mdl,cex.main,col.main)
  ## Check if user wants to choose starting values from an interactive plot
  if (dynamicPlot) 
    WARN("The 'dynamicPlot' functionality has been moved to 'vbStartsDP' in the 'FSAsim' package.")
  ## return starting values list
  sv
}



################################################################################
# INTERNAL FUNCTIONS
################################################################################
#===============================================================================
# Find starting values for Linf and K from a Walford Plot
#===============================================================================
iVBStarts.LinfK <- function(age,len,type,methLinf,num4Linf,fixed,check=TRUE) {
  ## compute mean lengths-at-age and numbers-at-age
  meanL <- tapply(len,age,mean)
  ns <- tapply(len,age,length)
  ## fit Walford plot regression
  if (length(meanL)<3) 
    STOP("The 'Linf' parameter cannot be automatically determined with less than 3 observed ages.")
  cfs <- stats::coef(stats::lm(meanL[-1]~meanL[-length(meanL)]))
  ## If a fixed value was sent then return it, else find starting values
  ## from either the Walford plot regression coefficients or mean length of
  ## largest fish. Then check for reasonableness)
  if ("Linf" %in% names(fixed)) {
    sLinf <- fixed[["Linf"]]
  } else {
    if (methLinf=="Walford") sLinf <- cfs[[1]]/(1-cfs[[2]])
    else {
      if (num4Linf<1) STOP("'num4Linf' must be at least 1.")
      if (methLinf=="longFish") {
        if (num4Linf>length(len)) 
          STOP("'num4Linf' must be less than the number of recorded lengths.")
        sLinf <- mean(len[rev(order(len))][1:num4Linf])
      } else {
        ages <- rev(unique(age))
        if (num4Linf>length(ages)) 
          STOP("'num4Linf' must be less than the number of observed ages.")
        sLinf <- mean(len[age %in% ages[1:num4Linf]])
      }
    }
    if (check) iCheckLinf(sLinf,len)
  }
  if ("K" %in% names(fixed)) {
    sK <- fixed[["K"]]
  } else {
    sK <- -log(cfs[[2]])
    if (check) iCheckK(sK,type,len)
  }
  ## return the starting values
  c(Linf=sLinf,K=sK)
}

#===============================================================================
# Perform some checks for "bad" values of Linf and K
#===============================================================================
iCheckLinf <- function(sLinf,len) {
  if ((sLinf<0.5*max(len,na.rm=TRUE)) | sLinf>1.5*max(len,na.rm=TRUE)) {
    WARN("Starting value for Linf is very different from the observed maximum\n",
         "length, which suggests a model fitting problem. See a Walford or\n",
         "Chapman plot to examine the problem. Consider either using the mean\n",
         "length for several of the largest fish (i.e., use 'oldAge' in \n",
         "'methLinf=') or manually setting Linf in the starting value list\n",
         "to the maximum observed length.\n")
  }
}

iCheckK <- function(sK,type,len) {
    if (sK<0) {
    if (type %in% c("Typical","typical","Original","original","BevertonHolt",
                    "vonBertalanffy","GQ","GallucciQuinn","Schnute")) {
      msg <- "The suggested starting value for K is negative, "
    } else {
      msg <- "One suggested starting value is based on a negative K, "
    }
    msg <- paste0(msg,"which suggests a model fitting problem.\n")
    msg <- paste0(msg,"See a Walford or Chapman Plot to examine the problem.\n")
    msg <- paste0(msg,"Consider manually setting K=0.3 in the starting value list.\n")
    WARN(msg)
  }
}

#===============================================================================
# Find starting values for t0 and L0
#===============================================================================
iVBStarts.t0 <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  if ("t0" %in% names(fixed)) {
    st0 <- fixed[["t0"]]
  } else {
    ## compute mean lengths-at-age and numbers-at-age
    meanL <- tapply(len,age,mean)
    ns <- tapply(len,age,length)
    ## find ages represented
    ages <- as.numeric(names(meanL))
    ## find values depending on method
    if(meth0=="poly") {
      # fit polynomial regression
      respoly <- stats::lm(meanL~stats::poly(ages,2,raw=TRUE))
      # get real component of roots to polynomial equation
      resroots <- Re(polyroot(stats::coef(respoly)))
      # find starting value for t0 as polynomial root closest to zero
      st0 <- resroots[which(abs(resroots)==min(abs(resroots)))]
      # removes the attributes and will return only the first
      #  root if a "double root" was found
      st0 <- st0[[1]]
    } else {
      # find starting values for Linf and K
      tmp <- iVBStarts.LinfK(age,len,type,methLinf,num4Linf,fixed,FALSE)
      # find the youngest age with a n>=1
      if (all(ns==1)) yngAge <- min(ages)
      else yngAge <- min(ages[which(ns>=1)])
      # find starting values for t0 from re-arrangement of typical VonB and yngAge
      st0 <- yngAge+(1/tmp[["K"]])*log((tmp[["Linf"]]-meanL[[which(ages==yngAge)]])/tmp[["Linf"]])
    }
  }
  ## Return starting values
  st0
}

iVBStarts.L0 <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  if ("L0" %in% names(fixed)) {
    sL0 <- fixed[["L0"]]
  } else {
    ## compute mean lengths-at-age and numbers-at-age
    meanL <- tapply(len,age,mean)
    ns <- tapply(len,age,length)
    ## find ages represented
    ages <- as.numeric(names(meanL))
    ## find values depending on method
    if(meth0=="poly") {
      # fit polynomial regression
      respoly <- stats::lm(meanL~stats::poly(ages,2,raw=TRUE))
      # get real component of roots to polynomial equation
      resroots <- Re(polyroot(stats::coef(respoly)))
      # find starting value for L0 as predicted value from polynomial at age=0
      sL0 <- stats::predict(respoly,data.frame(ages=0))
      # removes the attributes and will return only the first
      # root if a "double root" was found
      sL0 <- sL0[[1]]
    } else {
      # find starting values for Linf and K
      tmp <- iVBStarts.LinfK(age,len,type,methLinf,num4Linf,fixed,FALSE)
      # find the youngest age with a n>=1
      if (all(ns==1)) yngAge <- min(ages)
      else yngAge <- min(ages[which(ns>=1)])
      # find starting values for L0 from re-arrangement of original VonB model and yngAge
      sL0 <- tmp[["Linf"]]+(meanL[[which(ages==yngAge)]]-tmp[["Linf"]])/exp(-tmp[["K"]]*yngAge)
    }
  }
  ## Return starting values
  sL0
}

#===============================================================================
# find starting values for L1, L2, and L3 (of the Francis and Schnute methods)
#===============================================================================
iVBStarts.Ls <- function(age,len,type,methEV,ages2use,fixed) {
  ## compute mean lengths-at-age and numbers-at-age
  meanL <- tapply(len,age,mean)
  ns <- tapply(len,age,length)
  ## find ages represented
  ages <- as.numeric(names(meanL))
  ## Handle ages2use
  # if none given then use the min and max
  if (is.null(ages2use)) ages2use <- range(ages)
  # if too many given then send an error
  if (length(ages2use)!=2) STOP("'ages2use=' must be NULL or have only two ages.")
  # if order is backwards then warn and flip
  if (ages2use[2]<=ages2use[1]) {
    WARN("'ages2use' should be in ascending order; order reversed to continue.")
    ages2use <- rev(ages2use)
  }
  # if using the Francis parameterization then must find the intermediate age
  if (type=="Francis") ages2use <- c(ages2use[1],mean(ages2use),ages2use[2])
  ## Find mean lengths at ages2use
  if (methEV=="poly") {
    # fit polynomial regression
    respoly <- stats::lm(meanL~stats::poly(ages,2))
    # predict length at ages2use
    vals <- stats::predict(respoly,data.frame(ages=ages2use))
  } else {
    # fit an interpolating functions
    meanFnx <- stats::approxfun(ages,meanL)
    # find ages from that function
    vals <- meanFnx(ages2use)
  }
  if (type=="Francis") {
    if ("L1" %in% names(fixed)) vals[[1]] <- fixed[["L1"]]
    if ("L2" %in% names(fixed)) vals[[2]] <- fixed[["L2"]]
    if ("L3" %in% names(fixed)) vals[[3]] <- fixed[["L3"]]
    if (any(diff(vals)<=0))
      WARN("At least one of the starting values for an older age\n",
           "  is smaller than the starting value for a younger age.")
    ## Return the values
    list(L1=vals[[1]],L2=vals[[2]],L3=vals[[3]])
  } else { # Schnute
    if ("L1" %in% names(fixed)) vals[[1]] <- fixed[["L1"]]
    if ("L3" %in% names(fixed)) vals[[2]] <- fixed[["L3"]]    
    if (any(diff(vals)<=0)) 
      WARN("At least one of the starting values for an older age\n",
           "  is smaller than the starting value for a younger age.")
    list(L1=vals[[1]],L3=vals[[2]])
  }
}


#===============================================================================
# Find starting values for the Ogle VB parameterization
#===============================================================================
iVBStarts.Ogle <- function(age,len,type,meth0,methLinf,num4Linf,valOgle,fixed) {
  if (is.null(valOgle)) STOP("'valOgle' must contain a value for 'Lr' or 'tr'")
  if (!is.numeric(valOgle)) STOP("'valOgle' must be numeric")
  if (!is.vector(valOgle)) STOP("'valOgle' must be a named vector")
  if (length(valOgle)!=1) STOP("'valOgle' must contain only one value")
  if (is.null(names(valOgle))) STOP("'valOgle' must be a named vector")
  setParam <- names(valOgle)
  if (!setParam %in% c("Lr","tr"))
    STOP("Name in 'valOgle' must be 'Lr' or 'tr'")
  LK <- iVBStarts.LinfK(age,len,type,methLinf,num4Linf,fixed,FALSE)
  if (setParam=="tr") {
    ## an age was given, fit polynomial and predict length at that age
    if (valOgle<min(age) & is.null(fixed))
      WARN("'valAge' is less than minimum observed age.\n",
           "Starting value for Lr may be suspect; considering using 'fixed'.")
    # fit polynomial regression
    respoly <- stats::lm(len~stats::poly(age,2,raw=TRUE))
    # find starting value for L0 as predicted value from polynomial at age in tr
    sLr <- stats::predict(respoly,data.frame(age=valOgle))
    # return starting values
    if (!is.null(fixed)) {
      if (names(fixed)!="Lr") 
        WARN("Name in 'fixed' must be 'Lr' if 'tr' is in 'valOgle'.\n",
             "Value in 'fixed' was ignored.")
      else sLr <- fixed
    }
    as.list(c(LK,Lr=sLr[[1]]))
  } else {
    ## a length was given, fit polynomial and predict age at that length
    if (valOgle<min(len) & is.null(fixed)) 
      WARN("'valAge' is less than minimum observed length.\n",
           "Starting value for tr may be suspect; considering using 'fixed'.")
    # fit polynomial regression
    respoly <- stats::lm(age~stats::poly(len,2,raw=TRUE))
    # find starting value for L0 as predicted value from polynomial at age in tr
    str <- stats::predict(respoly,data.frame(len=valOgle))
    # return starting values
    if (!is.null(fixed)) {
      if (names(fixed)!="tr")
        WARN("Name in 'fixed' must be 'tr' if 'Lr' is in 'valOgle'.\n",
             "Value in 'fixed' was ignored.")
      else str <- fixed
    }
    as.list(c(LK,tr=str[[1]]))
  }
}


#===============================================================================
# Find starting values the typical VB parameterization
#===============================================================================
iVBStarts.typical <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  LK <- iVBStarts.LinfK(age,len,type,methLinf,num4Linf,fixed)
  t0 <- iVBStarts.t0(age,len,type,meth0,methLinf,num4Linf,fixed)
  as.list(c(LK,t0=t0))
}

#===============================================================================
# Find starting values the original VB parameterization
#===============================================================================
iVBStarts.original <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  tmp <- iVBStarts.LinfK(age,len,type,methLinf,num4Linf,fixed)
  as.list(c(tmp["Linf"],tmp["K"],L0=iVBStarts.L0(age,len,type,meth0,methLinf,
                                                 num4Linf,fixed)))
}

#===============================================================================
# Find starting values the GQ VB parameterization
#===============================================================================
iVBStarts.GQ <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  tmp <- iVBStarts.typical(age,len,type,meth0,methLinf,num4Linf,fixed)
  omega <- ifelse("omega" %in% names(fixed),fixed[["omega"]],tmp[["Linf"]]*tmp[["K"]])
  as.list(c(omega=omega,tmp["K"],tmp["t0"]))
}

#===============================================================================
# Find starting values the Mooij VB parameterization
#===============================================================================
iVBStarts.Mooij <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  tmp <- iVBStarts.original(age,len,type,meth0,methLinf,num4Linf,fixed)
  omega <- ifelse("omega" %in% names(fixed),fixed[["omega"]],tmp[["Linf"]]*tmp[["K"]])
  as.list(c(tmp["Linf"],tmp["L0"],omega=omega))
}

#===============================================================================
# Find starting values the Weisberg VB parameterization
#===============================================================================
iVBStarts.Weisberg <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  tmp <- iVBStarts.typical(age,len,type,meth0,methLinf,num4Linf,fixed)
  t50 <- ifelse("t50" %in% names(fixed),fixed[["t50"]],log(2)/tmp[["K"]]+tmp[["t0"]])
  as.list(c(Linf=tmp[["Linf"]],t50=t50,t0=tmp[["t0"]]))
}

#===============================================================================
# Find starting values the Francis VB parameterization
#===============================================================================
iVBStarts.Francis <- function(age,len,type,methEV,ages2use,fixed) {
  iVBStarts.Ls(age,len,type,methEV,ages2use,fixed)
}

#===============================================================================
# Find starting values the Schnute VB parameterization
#===============================================================================
iVBStarts.Schnute <- function(age,len,type,meth0,methLinf,num4Linf,methEV,
                              ages2use,fixed) {
  as.list(c(iVBStarts.Ls(age,len,type,methEV,ages2use,fixed),
            iVBStarts.LinfK(age,len,type,methLinf,num4Linf,fixed)["K"]))
}

#===============================================================================
# Find starting values the Somers VB parameterization
#===============================================================================
iVBStarts.Somers <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  C <- ifelse("C" %in% names(fixed),fixed[["C"]],0.5)
  ts <- ifelse("ts" %in% names(fixed),fixed[["ts"]],0.3)
  as.list(c(iVBStarts.typical(age,len,type,meth0,methLinf,num4Linf,fixed),C=C,ts=ts))
}

#===============================================================================
# Find starting values the Somers2 VB parameterization
#===============================================================================
iVBStarts.Somers2 <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  C <- ifelse("C" %in% names(fixed),fixed[["C"]],0.5)
  WP <- ifelse("WP" %in% names(fixed),fixed[["WP"]],0.8)
  as.list(c(iVBStarts.typical(age,len,type,meth0,methLinf,num4Linf,fixed),C=C,WP=WP))
}

#===============================================================================
# Find starting values the Pauly VB parameterization
#===============================================================================
iVBStarts.Pauly <- function(age,len,type,meth0,methLinf,num4Linf,fixed) {
  NGT <- ifelse("NGT" %in% names(fixed),fixed[["NGT"]],0.3)
  ts <- ifelse("ts" %in% names(fixed),fixed[["ts"]],0.3)
  tmp <- iVBStarts.typical(age,len,type,meth0,methLinf,num4Linf,fixed)
  Kpr <- ifelse("Kpr" %in% names(fixed),fixed[["Kpr"]],tmp[["K"]]/(1-NGT))
  as.list(c(Linf=tmp[["Linf"]],Kpr=Kpr,t0=tmp[["t0"]],ts=ts,NGT=NGT))
}


#===============================================================================
# Static plot of starting values
#===============================================================================
iVBStartsPlot <- function(age,len,type,sv,ages2use,valOgle,
                          col.mdl,lwd.mdl,lty.mdl,cex.main,col.main) { # nocov start
  ## attempting to get by bindings warning in RCMD CHECK
  x <- NULL
  ## Plot the data
  # create a transparency value that attempts to not be too transparent
  tmp <- max(table(age,len))
  clr <- grDevices::rgb(0,0,0,ifelse(tmp>2 & tmp<20,2/tmp,0.1))
  # Make the base plot
  graphics::plot(age,len,pch=19,col=clr,xlab="Age",ylab="Length",
                 main=paste0("von B (",type,") STARTING VALUES"),
                 cex.main=cex.main,col.main=col.main)
  ## Plot the model
  mdl <- vbFuns(type)
  min.age <- min(age,na.rm=TRUE)
  max.age <- max(age,na.rm=TRUE)
  if (!type %in% c("Schnute","Francis","Ogle")) {
    graphics::curve(mdl(x,unlist(sv)),from=min.age,to=max.age,
                    col=col.mdl,lwd=lwd.mdl,lty=lty.mdl,add=TRUE)
  } else if (type=="Ogle") {
    # Ogle requires valOgle
    sv <- unlist(c(sv,valOgle))[c("Linf","K","tr","Lr")]
    graphics::curve(mdl(x,sv),from=min.age,to=max.age,
                    col=col.mdl,lwd=lwd.mdl,lty=lty.mdl,add=TRUE)
  } else {
    # Schnute/Francis requires t1 argument
    graphics::curve(mdl(x,unlist(sv),t1=ages2use),from=min.age,to=max.age,
                    col=col.mdl,lwd=lwd.mdl,lty=lty.mdl,add=TRUE)
  }
  ## Put the starting values to put on the plot
  graphics::legend("bottomright",
                   paste(names(sv),formatC(unlist(sv),format="f",digits=2),
                         sep="="),bty="n")
} # nocov end
