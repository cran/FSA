% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wrAdd.R
\name{wrAdd}
\alias{wrAdd}
\alias{wrAdd.default}
\alias{wrAdd.formula}
\title{Computes a vector of relative weights specific to a species in an entire data frame.}
\usage{
wrAdd(wt, ...)

\method{wrAdd}{default}(wt, len, spec, units = c("metric", "English"), WsOpts = NULL, ...)

\method{wrAdd}{formula}(wt, data, units = c("metric", "English"), ...)
}
\arguments{
\item{wt}{A numeric vector that contains weight measurements or a formula of the form \code{wt~len+spec} where \dQuote{wt} generically represents the weight variable, \dQuote{len} generically represents the length variable, and \dQuote{spec} generically represents the species variable. Note that this formula can only contain three variables and they must be in the order of weight first, length second, species third.}

\item{\dots}{Not used.}

\item{len}{A numeric vector that contains length measurements. Not used if \code{wt} is a formula.}

\item{spec}{A character or factor vector that contains the species names. Not used if \code{wt} is a formula.}

\item{units}{A string that indicates whether the weight and length data in \code{formula} are in \code{"metric"} (DEFAULT; mm and g) or \code{"English"} (in and lbs) units.}

\item{WsOpts}{A named list that provides specific choices for \code{group}, \code{ref}, or \code{method} for species for which more than one standard weight equation exists in \code{\link{WSlit}}.}

\item{data}{A data.frame that minimally contains variables of the the observed lengths, observed weights, and the species names given in the \code{formula=}.}
}
\value{
A numeric vector that contains the computed relative weights, in the same order as in \code{data=}.
}
\description{
Returns a vector that contains the relative weight specific to each species for all individuals in an entire data frame.
}
\details{
This computes a vector that contains the relative weight specific to each species for all individuals in an entire data frame. The vector can be appended to an existing data.frame to create a variable that contains the relative weights for each individual. The relative weight value will be \code{NA} for each individual for which a standard weight equation does not exist in \code{\link{WSlit}}, a standard weight equation for the units given in \code{units=} does not exist in \code{\link{WSlit}}, or if the individual is shorter or longer than the lengths for which the standard weight equation should be applied. Either the linear or quadratic equation has been listed as preferred for each species, so only that equation will be used.

The species names in \code{species} must match the spelling and capitalization of \code{species} in \code{\link{WSlit}}. Use \code{wsVal()} to see a list of all species for which standard weight equations exist in \code{\link{WSlit}} and, more importantly, how the species names are spelled and capitalized.

Some (few) species have more than one equation listed in \code{\link{WSlit}} (for the specified units). In these instances the user must select one of the equations to use with \code{WsOpts}. \code{WsOpts} is a list of lists where the inside list contains one or more of \code{group}, \code{ref}, or \code{method} (see \code{\link{WSlit}}) required to specify a single equation for a particular species, which is the name of the inner list. See the examples for an illustration of how to use \code{WsOpts}.

See examples and \href{https://fishr-core-team.github.io/FSA/articles/Computing_Relative_Weights.html}{this article} for a demonstration.
}
\section{IFAR Chapter}{
 8-Condition.
}

\examples{
#===== Create random data for three species
#----- just to control the randomization
set.seed(345234534)
dbt <- data.frame(species=factor(rep(c("Bluefin Tuna"),30)),
                  tl=round(rnorm(30,1900,300),0))
dbt$wt <- round(4.5e-05*dbt$tl^2.8+rnorm(30,0,6000),1)
dbg <- data.frame(species=factor(rep(c("Bluegill"),30)),
                  tl=round(rnorm(30,130,50),0))
dbg$wt <- round(4.23e-06*dbg$tl^3.316+rnorm(30,0,10),1)
dlb <- data.frame(species=factor(rep(c("Largemouth Bass"),30)),
                  tl=round(rnorm(30,350,60),0))
dlb$wt <- round(2.96e-06*dlb$tl^3.273+rnorm(30,0,60),1)
df <- rbind(dbt,dbg,dlb)
str(df)

#===== Add Wr variable
#----- using formula interface
df$Wr1 <- wrAdd(wt~tl+species,data=df)

#----- same but with non-formula interface
df$Wr2 <- wrAdd(df$wt,df$tl,df$species)

#----- same but using dplyr
if (require(dplyr)) {
  df <- df \%>\%
    mutate(Wr3=wrAdd(wt,tl,species))
}

#----- examine results
peek(df,n=10)
 
#===== Example with only one species in the data.frame
bg <- droplevels(subset(df,species=="Bluegill"))
bg$Wr4 <- wrAdd(wt~tl+species,data=bg)
bg

#===== Example with a species that has Ws eqns for multiple groups and a
#      group needs to be specified with WsOpts
wae <- data.frame(species=factor(rep(c("Walleye"),30)),
                  tl=round(rnorm(30,500,200),0))
wae$wt <- round(3.33e-06*wae$tl^3.16+rnorm(30,0,50),1)
# wae$Wr <- wrAdd(wt~tl+species,data=wae) # will err b/c multiple groups
wae$Wr <- wrAdd(wt~tl+species,data=wae,
                WsOpts=list(Walleye=list(group="overall")))
peek(wae,n=10)

}
\references{
Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.
}
\seealso{
See \code{\link{wsVal}}, \code{\link{WSlit}}, and \code{\link{psdAdd}} for related functionality. See \code{\link[plyr]{mapvalues}} for help in changing species names to match those in \code{\link{WSlit}}.
}
\author{
Derek H. Ogle, \email{DerekOgle51@gmail.com}
}
\keyword{manip}
