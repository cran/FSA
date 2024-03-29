% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/growthModels.R
\name{growthModels}
\alias{growthModels}
\alias{vbFuns}
\alias{GompertzFuns}
\alias{RichardsFuns}
\alias{logisticFuns}
\alias{growthFunShow}
\title{Creates a function for a specific parameterization of the von Bertalanffy, Gompertz, Richards, and logistic growth functions.}
\usage{
vbFuns(
  param = c("Typical", "typical", "Traditional", "traditional", "BevertonHolt",
    "Original", "original", "vonBertalanffy", "GQ", "GallucciQuinn", "Mooij", "Weisberg",
    "Ogle", "Schnute", "Francis", "Laslett", "Polacheck", "Somers", "Somers2", "Pauly",
    "Fabens", "Fabens2", "Wang", "Wang2", "Wang3", "Francis2", "Francis3"),
  simple = FALSE,
  msg = FALSE
)

GompertzFuns(
  param = c("Ricker1", "Ricker2", "Ricker3", "QuinnDeriso1", "QuinnDeriso2",
    "QuinnDeriso3", "QD1", "QD2", "QD3", "Original", "original", "Troynikov1",
    "Troynikov2"),
  simple = FALSE,
  msg = FALSE
)

RichardsFuns(param = 1, simple = FALSE, msg = FALSE)

logisticFuns(
  param = c("CJ1", "CJ2", "Karkach", "Haddon", "CampanaJones1", "CampanaJones2"),
  simple = FALSE,
  msg = FALSE
)

growthFunShow(
  type = c("vonBertalanffy", "Gompertz", "Richards", "Logistic", "Schnute",
    "SchnuteRichards"),
  param = NULL,
  case = param,
  plot = FALSE,
  ...
)
}
\arguments{
\item{param}{A string (for von Bertalanffy, Gompertz, and logistic) or numeric (for Richards) that indicates the specific parameterization of the growth function. See details.}

\item{simple}{A logical that indicates whether the function will accept all parameter values in the first parameter argument (\code{=FALSE}; DEFAULT) or whether all individual parameters must be specified in separate arguments (\code{=TRUE}).}

\item{msg}{A logical that indicates whether a message about the growth function and parameter definitions should be output (\code{=TRUE}) or not (\code{=FALSE}; DEFAULT).}

\item{type}{A string (in \code{growthFunShow}) that indicates the type of growth function to show.}

\item{case}{A numeric that indicates the specific case of the Schnute function to use. See details.}

\item{plot}{A logical that indicates whether the growth function expression should be shown as an equation in a simple plot.}

\item{\dots}{Not implemented.}
}
\value{
The functions ending in \code{xxxFuns} return a function that can be used to predict fish size given a vector of ages and values for the growth function parameters and, in some parameterizations, values for constants. The result should be saved to an object that is then the function name. When the resulting function is used, the parameters are ordered as shown when the definitions of the parameters are printed after the function is called (if \code{msg=TRUE}). If \code{simple=FALSE} (DEFAULT), then the values for all parameters may be included as a vector in the first parameter argument (but in the same order). Similarly, the values for all constants may be included as a vector in the first constant argument (i.e., \code{t1}). If \code{simple=TRUE}, then all parameters and constants must be declared individually. The resulting function is somewhat easier to read when \code{simple=TRUE}, but is less general for some applications.

An expression of the equation for each growth function may be created with \code{growthFunShow}. In this function \code{type=} is used to select the major function type (e.g., von Bertalanffy, Gompertz, Richards, Logistic, Schnute) and \code{param=} is used to select a specific parameterization of that growth function. If \code{plot=TRUE}, then a simple graphic will be created with the equation using \code{\link{plotmath}} for a pretty format.
}
\description{
Creates a function for a specific parameterizations of the von Bertalanffy, Gompertz, Richards, and logistic growth functions. Use \code{growthFunShow()} to see the equations for each growth function.
}
\note{
Take note of the following for parameterizations (i.e., \code{param}) of each growth function:
\itemize{
  \item von Bertalanffy
  \itemize{
    \item The \sQuote{Original} and \sQuote{vonBertalanffy} are synonymous as are \sQuote{Typical}, \sQuote{Traditional}, and \sQuote{BevertonHolt}. Further note that the \sQuote{Ogle} parameterization has the \sQuote{Original}/\sQuote{vonBertalanffy} and \sQuote{Typical}/\sQuote{Traditional}/\sQuote{BevertonHolt} parameterizations as special cases.
  }
  \item Gompertz
  \itemize{
    \item The \sQuote{Ricker2} and \sQuote{QuinnDeriso1} are synonymous, as are \sQuote{Ricker3} and \sQuote{QuinnDeriso2}.
    \item The parameterizations and parameters for the Gompertz function are varied and confusing in the literature. I have attempted to use a uniform set of parameters in these functions, but that makes a direct comparison to the literature difficult. Common sources for Gompertz models are listed in the references below. I make some comments here to aid comparisons to the literature.
    \item Within FSA, L0 is the mean length at age 0, Linf is the mean asymptotic length, ti is the age at the inflection point, gi is the instantaneous growth rate at the inflection point, t* is a dimensionless parameter related to time/age, and a is a dimensionless parameter related to growth.
    \item In the Quinn and Deriso (1999) functions (the \sQuote{QuinnDerisoX} functions), the a parameter here is equal to lambda/K there and the gi parameter here is equal to the K parameter there. Also note that their Y is L here.
    \item In the Ricker (1979)[p. 705] functions (the \sQuote{RickerX} functions), the a parameter here is equal to k there and the gi parameter here is equal to the g parameter there. Also note that their w is L here. In the Ricker (1979) functions as presented in Campana and Jones (1992), the a parameter here is equal to k parameter there and the gi parameter here is equal to the G parameter there. Also note that their X is L here.
    \item The function in Ricker (1975)[p. 232] is the same as \sQuote{Ricker2} where the a parameter here is qual to G there and the gi parameter here is equal to the g parameter there. Also note that their w is L here.
    \item The function in Quist \emph{et al.} (2012)[p. 714] is the same as \sQuote{Ricker1} where the gi parameter here is equal to the G parameter there and the ti parameter here is equal to the t0 parameter there.
    \item The function in Katsanevakis and Maravelias (2008) is the same as \sQuote{Ricker1} where the gi parameter here is equal to k2 parameter there and the ti parameter here is equal to the t2 parameter there.
  }
  \item Richards
  \itemize{
    \item Within FSA, Linf is the mean asymptotic length, ti is the age at the inflection point, k controls the slope at the inflection point (maximum relative growth rate), b is dimensionless but related to the vertical position (i.e., size) of the inflection point, a is dimensionless but related to the horizontal position (i.e., age) of the inflection point, and L0 is the mean length at age-0.
    \item The parameterizations (1-6) correspond to functions/equations 1, 4, 5, 6, 7, and 8, respectively, in Tjorve and Tjorve (2010). Note that their A, S, k, d, and B are Linf, a, k, b, and L0, respectively, here (in FSA). THeir (Tjorve and Tjorve 2010) K does not appear here.
  }
  \item logistic
  \itemize{
    \item Within FSA, L0 is the mean length at age 0, Linf is the mean asymptotic length, ti is the age at the inflection point, and gninf is the instantaneous growth rate at negative infinity.
  }
}
}
\section{IFAR Chapter}{
 12-Individual Growth.
}

\examples{
###########################################################
## Simple Examples -- Von B
( vb1 <- vbFuns() )
ages <- 0:20
plot(vb1(ages,Linf=20,K=0.3,t0=-0.2)~ages,type="b",pch=19)
( vb2 <- vbFuns("Francis") )
plot(vb2(ages,L1=10,L2=19,L3=20,t1=2,t3=18)~ages,type="b",pch=19)
( vb2c <- vbFuns("Francis",simple=TRUE) )   # compare to vb2

## Simple Examples -- Gompertz
( gomp1 <- GompertzFuns() )
plot(gomp1(ages,Linf=800,gi=0.5,ti=5)~ages,type="b",pch=19)
( gomp2 <- GompertzFuns("Ricker2") )
plot(gomp2(ages,L0=2,a=6,gi=0.5)~ages,type="b",pch=19)
( gomp2c <- GompertzFuns("Ricker2",simple=TRUE) )   # compare to gomp2
( gompT <- GompertzFuns("Troynikov1"))

## Simple Examples -- Richards
( rich1 <- RichardsFuns() )
plot(rich1(ages,Linf=800,k=0.5,a=1,b=6)~ages,type="b",pch=19)
( rich2 <- RichardsFuns(2) )
plot(rich2(ages,Linf=800,k=0.5,ti=3,b=6)~ages,type="b",pch=19)
( rich3 <- RichardsFuns(3) )
plot(rich3(ages,Linf=800,k=0.5,ti=3,b=0.15)~ages,type="b",pch=19)
( rich4 <- RichardsFuns(4) )
plot(rich4(ages,Linf=800,k=0.5,ti=3,b=0.95)~ages,type="b",pch=19)
lines(rich4(ages,Linf=800,k=0.5,ti=3,b=1.5)~ages,type="b",pch=19,col="blue")
( rich5 <- RichardsFuns(5) )
plot(rich5(ages,Linf=800,k=0.5,L0=50,b=1.5)~ages,type="b",pch=19)
( rich6 <- RichardsFuns(6) )
plot(rich6(ages,Linf=800,k=0.5,ti=3,Lninf=50,b=1.5)~ages,type="b",pch=19)
( rich2c <- RichardsFuns(2,simple=TRUE) ) # compare to rich2

## Simple Examples -- Logistic
( log1 <- logisticFuns() )
plot(log1(ages,Linf=800,gninf=0.5,ti=5)~ages,type="b",pch=19)
( log2 <- logisticFuns("CJ2") )
plot(log2(ages,Linf=800,gninf=0.5,a=10)~ages,type="b",pch=19)
( log2c <- logisticFuns("CJ2",simple=TRUE) ) # compare to log2
( log3 <- logisticFuns("Karkach") )
plot(log3(ages,L0=10,Linf=800,gninf=0.5)~ages,type="b",pch=19)
( log4 <- logisticFuns("Haddon") )


###########################################################
## Examples of fitting
##   After the last example a plot is constructed with three
##   or four lines on top of each other illustrating that the
##   parameterizations all produce the same fitted values.
##   However, observe the correlations in the summary() results.

## Von B
plot(tl~age,data=SpotVA1,pch=19)

# Fitting the typical parameterization of the von B function
fit1 <- nls(tl~vb1(age,Linf,K,t0),data=SpotVA1,
            start=vbStarts(tl~age,data=SpotVA1))
summary(fit1,correlation=TRUE)
curve(vb1(x,Linf=coef(fit1)),from=0,to=5,col="red",lwd=10,add=TRUE)

# Fitting the Francis parameterization of the von B function
fit2 <- nls(tl~vb2c(age,L1,L2,L3,t1=0,t3=5),data=SpotVA1,
            start=vbStarts(tl~age,data=SpotVA1,type="Francis",ages2use=c(0,5)))
summary(fit2,correlation=TRUE)
curve(vb2c(x,L1=coef(fit2)[1],L2=coef(fit2)[2],L3=coef(fit2)[3],t1=0,t3=5),
      from=0,to=5,col="blue",lwd=5,add=TRUE)

# Fitting the Schnute parameterization of the von B function
vb3 <- vbFuns("Schnute")
fit3 <- nls(tl~vb3(age,L1,L3,K,t1=0,t3=4),data=SpotVA1,
            start=vbStarts(tl~age,data=SpotVA1,type="Schnute",ages2use=c(0,4)))
summary(fit3,correlation=TRUE)
curve(vb3(x,L1=coef(fit3),t1=c(0,4)),from=0,to=5,col="green",lwd=2,add=TRUE)

## Gompertz
# Make some fake data using the original parameterization
gompO <- GompertzFuns("original")
# setup ages, sample sizes (general reduction in numbers with
# increasing age), and additive SD to model
t <- 1:15
n <- c(10,40,35,25,12,10,10,8,6,5,3,3,3,2,2)
sd <- 15
# expand ages
ages <- rep(t,n)
# get lengths from gompertz and a random error for individuals
lens <- gompO(ages,Linf=450,a=1,gi=0.3)+rnorm(length(ages),0,sd)
# put together as a data.frame
df <- data.frame(age=ages,len=round(lens,0))

plot(len~age,data=df,pch=19,col=rgb(0,0,0,1/5))
  
# Fit first Ricker parameterization
fit1 <- nls(len~gomp1(age,Linf,gi,ti),data=df,start=list(Linf=500,gi=0.3,ti=3))
summary(fit1,correlation=TRUE)
curve(gomp1(x,Linf=coef(fit1)),from=0,to=15,col="red",lwd=10,add=TRUE)

# Fit third Ricker parameterization
fit2 <- nls(len~gomp2(age,L0,a,gi),data=df,start=list(L0=30,a=3,gi=0.3))
summary(fit2,correlation=TRUE)
curve(gomp2(x,L0=coef(fit2)),from=0,to=15,col="blue",lwd=5,add=TRUE)

# Fit third Quinn and Deriso parameterization (using simple=TRUE model)
gomp3 <- GompertzFuns("QD3",simple=TRUE)
fit3 <- nls(len~gomp3(age,Linf,gi,t0),data=df,start=list(Linf=500,gi=0.3,t0=0))
summary(fit3,correlation=TRUE)
curve(gomp3(x,Linf=coef(fit3)[1],gi=coef(fit3)[2],t0=coef(fit3)[3]),
      from=0,to=15,col="green",lwd=2,add=TRUE)

## Richards

\dontrun{
# Fit first Richards parameterization ... DOES NOT CONVERGE
fit1 <- nls(len~rich1(age,Linf,k,a,b),data=df,
            start=list(Linf=450,k=0.3,a=0.2,b=3))
summary(fit1,correlation=TRUE)
curve(rich1(x,Linf=coef(fit1)),from=0,to=15,col="red",lwd=10,add=TRUE)

# Fit second Richards parameterization ... DOES NOT CONVERGE
fit2 <- nls(len~rich2(age,Linf,k,ti,b),data=df,
            start=list(Linf=450,k=0.25,ti=3,b=3))
summary(fit2,correlation=TRUE)
curve(rich2(x,Linf=coef(fit2)),from=0,to=15,col="blue",lwd=7,add=TRUE)
}

plot(len~age,data=df,pch=19,col=rgb(0,0,0,1/5))

# Fit third Richards parameterization
fit3 <- nls(len~rich3(age,Linf,k,ti,b),data=df,
            start=list(Linf=450,k=0.25,ti=3,b=-0.1))
summary(fit3,correlation=TRUE)
curve(rich3(x,Linf=coef(fit3)),from=0,to=15,col="green",lwd=4,add=TRUE)

# Fit fourth Richards parameterization
fit4 <- nls(len~rich4(age,Linf,k,ti,b),data=df,
            start=list(Linf=450,k=0.25,ti=3,b=0.7))
summary(fit4,correlation=TRUE)
curve(rich4(x,Linf=coef(fit4)),from=0,to=15,col="black",lwd=1,add=TRUE)

## Logistic
plot(len~age,data=df,pch=19,col=rgb(0,0,0,1/5))

# Fit first Campana-Jones parameterization
fit1 <- nls(len~log1(age,Linf,gninf,ti),data=df,
            start=list(Linf=450,gninf=0.45,ti=4))
summary(fit1,correlation=TRUE)
curve(log1(x,Linf=coef(fit1)),from=0,to=15,col="red",lwd=10,add=TRUE)

# Fit second Campana-Jones parameterization
fit2 <- nls(len~log2(age,Linf,gninf,a),data=df,
            start=list(Linf=450,gninf=0.45,a=7))
summary(fit2,correlation=TRUE)
curve(log2(x,Linf=coef(fit2)),from=0,to=15,col="blue",lwd=5,add=TRUE)

# Fit Karkach parameterization (using simple=TRUE model)
log3 <- logisticFuns("Karkach",simple=TRUE)
fit3 <- nls(len~log3(age,Linf,L0,gninf),data=df,
            start=list(Linf=450,L0=30,gninf=0.45))
summary(fit3,correlation=TRUE)
curve(log3(x,Linf=coef(fit3)[1],L0=coef(fit3)[2],gninf=coef(fit3)[3]),
      from=0,to=15,col="green",lwd=2,add=TRUE)


#############################################################################
## Create expressions of the models
#############################################################################
# Typical von Bertalanffy ... Show as a stand-alone plot
growthFunShow("vonBertalanffy","Typical",plot=TRUE)
# Get and save the expression
( tmp <- growthFunShow("vonBertalanffy","Typical") )
# Use expression as title on a plot
lens <- vb1(ages,Linf=20,K=0.3,t0=-0.2)
plot(lens~ages,type="b",pch=19,main=tmp)
# Put expression in the main plot
text(10,5,tmp)
# Put multiple expressions on a plot
op <- par(mar=c(0.1,0.1,0.1,0.1))
plot(0,type="n",xlab="",ylab="",xlim=c(0,1),ylim=c(0,3),xaxt="n",yaxt="n")
text(0,2.5,"Original:",pos=4)
text(0.5,2.5,growthFunShow("vonBertalanffy","Original"))
text(0,1.5,"Typical:",pos=4)
text(0.5,1.5,growthFunShow("vonBertalanffy","Typical"))
text(0,0.5,"Francis:",pos=4)
text(0.5,0.5,growthFunShow("vonBertalanffy","Francis"))
par(op)
}
\references{
Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.

Campana, S.E. and C.M. Jones. 1992. Analysis of otolith microstructure data. Pages 73-100 In D.K. Stevenson and S.E. Campana, editors. Otolith microstructure examination and analysis. Canadian Special Publication of Fisheries and Aquatic Sciences 117. [Was (is?) from http://www.dfo-mpo.gc.ca/Library/141734.pdf.]

Fabens, A. 1965. Properties and fitting of the von Bertalanffy growth curve. Growth 29:265-289.

Francis, R.I.C.C. 1988. Are growth parameters estimated from tagging and age-length data comparable?  Canadian Journal of Fisheries and Aquatic Sciences, 45:936-942.

Gallucci, V.F. and T.J. Quinn II. 1979. Reparameterizing, fitting, and testing a simple growth model. Transactions of the American Fisheries Society, 108:14-25.

Garcia-Berthou, E., G. Carmona-Catot, R. Merciai, and D.H. Ogle. A technical note on seasonal growth models. Reviews in Fish Biology and Fisheries 22:635-640. [Was (is?) from https://www.researchgate.net/publication/257658359_A_technical_note_on_seasonal_growth_models.]

Gompertz, B. 1825. On the nature of the function expressive of the law of human mortality, and on a new method of determining the value of life contingencies. Philosophical Transactions of the Royal Society of London. 115:513-583.

Haddon, M., C. Mundy, and D. Tarbath. 2008. Using an inverse-logistic model to describe growth increments of Blacklip Abalone (\emph{Haliotis rubra}) in Tasmania. Fishery Bulletin 106:58-71. [Was (is?) from http://aquaticcommons.org/8857/1/haddon_Fish_Bull_2008.pdf.]

Karkach, A. S. 2006. Trajectories and models of individual growth. Demographic Research 15:347-400. [Was (is?) from http://www.demographic-research.org/volumes/vol15/12/15-12.pdf.]

Katsanevakis, S. and C.D. Maravelias. 2008. Modeling fish growth: multi-model inference as a better alternative to a priori using von Bertalanffy equation. Fish and Fisheries 9:178-187.

Mooij, W.M., J.M. Van Rooij, and S. Wijnhoven. 1999. Analysis and comparison of fish growth from small samples of length-at-age data: Detection of sexual dimorphism in Eurasian Perch as an example. Transactions of the American Fisheries Society 128:483-490.

Polacheck, T., J.P. Eveson, and G.M. Laslett. 2004. Increase in growth rates of southern Bluefin Tuna (\emph{Thunnus maccoyii}) over four decades: 1960 to 2000. Canadian Journal of Fisheries and Aquatic Sciences, 61:307-322.

Quinn, T. J. and R. B. Deriso. 1999. Quantitative Fish Dynamics. Oxford University Press, New York, New York. 542 pages.

Quist, M.C., M.A. Pegg, and D.R. DeVries. 2012. Age and Growth. Chapter 15 in A.V. Zale, D.L Parrish, and T.M. Sutton, Editors  Fisheries Techniques, Third Edition. American Fisheries Society, Bethesda, MD.

Richards, F. J. 1959. A flexible growth function for empirical use. Journal of Experimental Biology 10:290-300.

Ricker, W.E. 1975. Computation and interpretation of biological statistics of fish populations. Technical Report Bulletin 191, Bulletin of the Fisheries Research Board of Canada. [Was (is?) from http://www.dfo-mpo.gc.ca/Library/1485.pdf.]

Ricker, W.E. 1979. Growth rates and models. Pages 677-743 In W.S. Hoar, D.J. Randall, and J.R. Brett, editors. Fish Physiology, Vol. 8: Bioenergetics and Growth. Academic Press, NY, NY. [Was (is?) from https://books.google.com/books?id=CB1qu2VbKwQC&pg=PA705&lpg=PA705&dq=Gompertz+fish&source=bl&ots=y34lhFP4IU&sig=EM_DGEQMPGIn_DlgTcGIi_wbItE&hl=en&sa=X&ei=QmM4VZK6EpDAgwTt24CABw&ved=0CE8Q6AEwBw#v=onepage&q=Gompertz\%20fish&f=false.]

Schnute, J. 1981. A versatile growth model with statistically stable parameters. Canadian Journal of Fisheries and Aquatic Sciences, 38:1128-1140.

Somers, I. F. 1988. On a seasonally oscillating growth function. Fishbyte 6(1):8-11. [Was (is?) from http://www.worldfishcenter.org/Naga/na_2914.pdf.]

Tjorve, E. and K. M. C. Tjorve. 2010. A unified approach to the Richards-model family for use in growth analyses: Why we need only two model forms. Journal of Theoretical Biology 267:417-425. [Was (is?) from https://www.researchgate.net/profile/Even_Tjorve/publication/46218377_A_unified_approach_to_the_Richards-model_family_for_use_in_growth_analyses_why_we_need_only_two_model_forms/links/54ba83b80cf29e0cb04bd24e.pdf.]

Troynikov, V. S., R. W. Day, and A. M. Leorke. Estimation of seasonal growth parameters using a stochastic Gompertz model for tagging data. Journal of Shellfish Research 17:833-838. [Was (is?) from https://www.researchgate.net/profile/Robert_Day2/publication/249340562_Estimation_of_seasonal_growth_parameters_using_a_stochastic_gompertz_model_for_tagging_data/links/54200fa30cf203f155c2a08a.pdf.]

Vaughan, D. S. and T. E. Helser. 1990. Status of the Red Drum stock of the Atlantic coast: Stock assessment report for 1989. NOAA Technical Memorandum NMFS-SEFC-263, 117 p. [Was (is?) from http://docs.lib.noaa.gov/noaa_documents/NMFS/SEFSC/TM_NMFS_SEFSC/NMFS_SEFSC_TM_263.pdf.]

Wang, Y.-G. 1998. An improved Fabens method for estimation of growth parameters in the von Bertalanffy model with individual asymptotes. Canadian Journal of Fisheries and Aquatic Sciences 55:397-400.

Weisberg, S., G.R. Spangler, and L. S. Richmond. 2010. Mixed effects models for fish growth. Canadian Journal of Fisheries And Aquatic Sciences 67:269-277.

Winsor, C.P. 1932. The Gompertz curve as a growth curve. Proceedings of the National Academy of Sciences. 18:1-8. [Was (is?) from http://www.ncbi.nlm.nih.gov/pmc/articles/PMC1076153/pdf/pnas01729-0009.pdf.]
}
\seealso{
See \code{\link{Schnute}} for an implementation of the Schnute (1981) model.
}
\author{
Derek H. Ogle, \email{DerekOgle51@gmail.com}, thanks to Gabor Grothendieck for a hint about using \code{get()}.
}
\keyword{hplot}
\keyword{manip}
