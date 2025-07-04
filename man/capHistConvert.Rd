% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/capHistConvert.R
\name{capHistConvert}
\alias{capHistConvert}
\title{Convert between capture history data.frame formats.}
\usage{
capHistConvert(
  df,
  cols2use = NULL,
  cols2ignore = NULL,
  in.type = c("frequency", "event", "individual", "MARK", "marked", "RMark"),
  out.type = c("individual", "event", "frequency", "MARK", "marked", "RMark"),
  id = NULL,
  event.ord = NULL,
  freq = NULL,
  var.lbls = NULL,
  var.lbls.pre = "event",
  include.id = ifelse(is.null(id), FALSE, TRUE)
)
}
\arguments{
\item{df}{A data.frame that contains the capture histories and, perhaps, a unique fish identifier or frequency variable. See details.}

\item{cols2use}{A string or numeric vector that indicates columns in \code{df} to use. Negative numeric values will not use those columns. Cannot use both \code{cols2use} and \code{col2ignore}.}

\item{cols2ignore}{A string or numeric vector that indicates columns in \code{df} to ignore. Typical columns to ignore are those that are not either in \code{id=} or \code{freq=} or part of the capture history data. Cannot use both \code{cols2use} and \code{col2ignore}.}

\item{in.type}{A single string that indicates the type of capture history format to convert \bold{FROM}.}

\item{out.type}{A single string that indicates the type of capture history format to convert \bold{TO}.}

\item{id}{A string or numeric that indicates the column in \code{df} that contains the unique identifier for an individual fish. This argument is only used if \code{in.type="event"}, \code{in.type="individual"}, or, possibly, \code{in.type="RMark"}.}

\item{event.ord}{A string that contains a vector of ordered levels to be used when \code{in.type="event"}. The default is to order alphabetically which may not be desirable if, for example, the events are labeled as \sQuote{first}, \sQuote{second}, \sQuote{third}, and \sQuote{fourth}. In this case, use \code{event.ord=c("first","second","third","fourth")}.}

\item{freq}{A string or numeric that indicates the column in \code{df} that contains the frequency of individual fish corresponding to a capture history. This argument is only used if \code{in.type="MARK"}, \code{in.type="frequency"}, or, possibly, \code{in.type="RMark"}.}

\item{var.lbls}{A string vector of labels for the columns that contain the returned individual or frequency capture histories. If \code{var.lbls=NULL} or the length is different then the number of events then default labels using \code{var.lbls.pre} will be used. This argument is only used if \code{out.type="frequency"} or \code{out.type="individual"}.}

\item{var.lbls.pre}{A single string used as a prefix for the labels of the columns that contain the returned individual or frequency capture histories. This prefix will be appended with a number corresponding to the sample event. This argument is only used if \code{out.type="frequency"} or \code{out.type="individual"} and will be ignored if a proper vector is given in \code{var.lbls}.}

\item{include.id}{A logical that indicates whether a unique fish identifier variable/column should be included in the output data.frame. This argument is only used if \code{out.type="individual"} or \code{out.type="RMark"}.}
}
\value{
A data frame of the proper type given in \code{out.type} is returned. See details.
}
\description{
Use to convert between simple versions of several capture history data.frame formats -- \dQuote{individual}, \dQuote{frequency}, \dQuote{event}, \dQuote{MARK}, and \dQuote{RMark}. The primary use is to convert to the \dQuote{individual} format for use in \code{\link{capHistSum}}.
}
\details{
\code{\link{capHistSum}} requires capture histories to be recorded in the \dQuote{individual} format. In this format, the data frame contains (at least) as many columns as sample events and as many rows as individually tagged fish. Optionally, the data.frame may also contain a column with unique fish identifiers (e.g., tag numbers). Each cell in the capture history portion of the data.frame contains a \sQuote{0} if the fish of that row was NOT seen in the event of that column and a \sQuote{1} if the fish of that row WAS seen in the event of that column. For example, suppose that five fish were marked on four sampling events; fish \sQuote{17} was captured on the first two events; fish \sQuote{18} was captured on the first and third events; fish \sQuote{19} was captured on only the third event; fish \sQuote{20} was captured on only the fourth event; and fish \sQuote{21} was captured on the first and second events. The \dQuote{individual} capture history date.frame for these data looks like:

\tabular{ccccc}{
fish \tab event1 \tab event2 \tab event3 \tab event4 \cr
17 \tab 1 \tab 1 \tab 0 \tab 0 \cr
18 \tab 1 \tab 0 \tab 1 \tab 0 \cr
19 \tab 0 \tab 0 \tab 1 \tab 0 \cr
20 \tab 0 \tab 0 \tab 0 \tab 1 \cr 
21 \tab 1 \tab 1 \tab 0 \tab 0 \cr
}

The \dQuote{frequency} format data.frame (this format is used in \pkg{Rcapture}) has unique capture histories in separate columns, as in the \dQuote{individual} format, but also includes a column with the frequency of individuals that had the capture history of that row. It will not contain a fish identifier variable. The same data from above looks like:

\tabular{ccccc}{
event1 \tab event2 \tab event3 \tab event4 \tab freq \cr
1 \tab 1 \tab 0 \tab 0 \tab 2 \cr
1 \tab 0 \tab 1 \tab 0 \tab 1 \cr
0 \tab 0 \tab 1 \tab 0 \tab 1 \cr
0 \tab 0 \tab 0 \tab 1 \tab 1 \cr
}

The \dQuote{event} format data.frame has a column with the unique fish identifier and a column with the event in which the fish of that row was observed. The same data from above looks like:

\tabular{cc}{
fish \tab event \cr
17 \tab 1 \cr
18 \tab 1 \cr
21 \tab 1 \cr
17 \tab 2 \cr
21 \tab 2 \cr
18 \tab 3 \cr
19 \tab 3 \cr
20 \tab 4 \cr
}

MARK (http://www.phidot.org/software/mark/index.html) is the \dQuote{gold-standard} software for analyzing complex capture history information. In the \dQuote{MARK} format the 0s and 1s of the capture histories are combined together as a string without any spaces. Thus, the \dQuote{MARK} format has the capture history strings in one column with an additional column that contains the frequency of individuals that exhibited the capture history of that row. The final column ends with a semi-colon. The same data from above looks like:

\tabular{cc}{
ch \tab freq \cr
0001 \tab 1; \cr
0010 \tab 1; \cr
1010 \tab 1; \cr
1100 \tab 2; \cr
}

The \code{RMark} and \pkg{marked} are packages used to replace some of the functionality of MARK or to interact with MARK. The \dQuote{RMark} or \dQuote{marked} format requires the capture histories as one string (must be a character string and called \sQuote{ch}), as in the \dQuote{MARK} format, but without the semicolon. The data.frame may be augmented with an identifier for individual fish OR with a frequency variable. If augmented with a unique fish identification variable then the same data from above looks like:

\tabular{cc}{
fish \tab ch \cr
17 \tab 1100 \cr
18 \tab 1010 \cr
19 \tab 0010 \cr
20 \tab 0001 \cr 
21 \tab 1100 \cr
}

However, if augmented with a frequency variable then the same data from above looks like:

\tabular{cc}{
ch \tab freq \cr
0001 \tab 1 \cr
0010 \tab 1 \cr
1010 \tab 1 \cr
1100 \tab 2 \cr
}

Each of the formats can be used to convert from (i.e., in \code{in.type=}) or to convert to (i.e., in \code{out.type=}) with the exception that only the individual fish identifier version can be converted to when \code{out.type="RMark"}.
}
\note{
The formats as used here are simple in the sense that one is only allowed to have the individual fish identifier or the frequency variable in addition to the capture history information. More complex analyses may use a number of covariates. For these more complex analyses, one should work directly with the \pkg{Rcapture}, \code{RMark}, or \pkg{marked} packages.

This function also assumes that all unmarked captured fish are marked and returned to the population (i.e., no losses at the time of marking are allowed).
}
\section{Warning}{
 \code{capHistConvert} may give unwanted results if the data are \code{in.type="event"} but there are unused levels for the variable, as would result if the data.frame had been subsetted on the event variable. The unwanted results can be corrected by using \code{droplevels} before \code{capHistConvert}. See the last example for an example.
}

\section{IFAR Chapter}{
 9-Abundance from Capture-Recapture Data.
}

\examples{
## A small example of 'event' format
( ex1 <- data.frame(fish=c(17,18,21,17,21,18,19,20),yr=c(1987,1987,1987,1988,1988,1989,1989,1990)) )
# convert to 'individual' format
( ex1.E2I <- capHistConvert(ex1,id="fish",in.type="event") )
# convert to 'frequency' format
( ex1.E2F <- capHistConvert(ex1,id="fish",in.type="event",out.type="frequency") )
# convert to 'MARK' format
( ex1.E2M <- capHistConvert(ex1,id="fish",in.type="event",out.type="MARK") )
# convert to 'RMark' format
( ex1.E2R <- capHistConvert(ex1,id="fish",in.type="event",out.type="RMark") )

## convert converted 'individual' format ...
# to 'frequency' format (must ignore "id")
( ex1.I2F <- capHistConvert(ex1.E2I,id="fish",in.type="individual",out.type="frequency") )
# to 'MARK' format
( ex1.I2M <- capHistConvert(ex1.E2I,id="fish",in.type="individual",out.type="MARK") )
# to 'RMark' format
( ex1.I2R <- capHistConvert(ex1.E2I,id="fish",in.type="individual",out.type="RMark") )
# to 'event' format
( ex1.I2E <- capHistConvert(ex1.E2I,id="fish",in.type="individual",out.type="event") )

#' ## convert converted 'frequency' format ...
# to 'individual' format
( ex1.F2I <- capHistConvert(ex1.E2F,freq="freq",in.type="frequency") )
( ex1.F2Ia <- capHistConvert(ex1.E2F,freq="freq",in.type="frequency",include.id=TRUE) )
# to 'Mark' format
( ex1.F2M <- capHistConvert(ex1.E2F,freq="freq",in.type="frequency",
                            out.type="MARK") )
# to 'RMark' format
( ex1.F2R <- capHistConvert(ex1.E2F,freq="freq",in.type="frequency",
                            out.type="RMark") )
( ex1.F2Ra <- capHistConvert(ex1.E2F,freq="freq",in.type="frequency",
                             out.type="RMark",include.id=TRUE) )
# to 'event' format
( ex1.F2E <- capHistConvert(ex1.E2F,freq="freq",in.type="frequency",
                            out.type="event") )

## convert converted 'MARK' format ...
# to 'individual' format
( ex1.M2I <- capHistConvert(ex1.E2M,freq="freq",in.type="MARK") )
( ex1.M2Ia <- capHistConvert(ex1.E2M,freq="freq",in.type="MARK",include.id=TRUE) )
# to 'frequency' format
( ex1.M2F <- capHistConvert(ex1.E2M,freq="freq",in.type="MARK",out.type="frequency") )
# to 'RMark' format
( ex1.M2R <- capHistConvert(ex1.E2M,freq="freq",in.type="MARK",out.type="RMark") )
( ex1.M2Ra <- capHistConvert(ex1.E2M,freq="freq",in.type="MARK",out.type="RMark",include.id=TRUE) )
# to 'event' format
( ex1.M2E <- capHistConvert(ex1.E2M,freq="freq",in.type="MARK",out.type="event") )
 
## convert converted 'RMark' format ...
# to 'individual' format
( ex1.R2I <- capHistConvert(ex1.E2R,id="fish",in.type="RMark") )
# to 'frequency' format
( ex1.R2F <- capHistConvert(ex1.E2R,id="fish",in.type="RMark",out.type="frequency") )
# to 'MARK' format
( ex1.R2M <- capHistConvert(ex1.E2R,id="fish",in.type="RMark",out.type="MARK") )
# to 'event' format
( ex1.R2E <- capHistConvert(ex1.E2R,id="fish",in.type="RMark",out.type="event") )

## Remove semi-colon from MARK format to make a RMark 'frequency' format
ex1.E2R1 <- ex1.E2M
ex1.E2R1$freq <- as.numeric(sub(";","",ex1.E2R1$freq))
ex1.E2R1
# convert this to 'individual' format
( ex1.R2I1 <- capHistConvert(ex1.E2R1,freq="freq",in.type="RMark") )
( ex1.R2I1a <- capHistConvert(ex1.E2R1,freq="freq",in.type="RMark",include.id=TRUE) )
# convert this to 'frequency' format
( ex1.R2F1 <- capHistConvert(ex1.E2R1,freq="freq",in.type="RMark",out.type="frequency") )
# convert this to 'MARK' format
( ex1.R2M1 <- capHistConvert(ex1.E2R1,freq="freq",in.type="RMark",out.type="MARK") )
# convert this to 'event' format
( ex1.R2E1 <- capHistConvert(ex1.E2R1,freq="freq",in.type="RMark",out.type="event") )


########################################################################
## A small example using character ids
( ex2 <- data.frame(fish=c("id17","id18","id21","id17","id21","id18","id19","id20"),
                    yr=c(1987,1987,1987,1988,1988,1989,1989,1990)) )
# convert to 'individual' format
( ex2.E2I <- capHistConvert(ex2,id="fish",in.type="event") )
# convert to 'frequency' format
( ex2.E2F <- capHistConvert(ex2,id="fish",in.type="event",out.type="frequency") )
# convert to 'MARK' format
( ex2.E2M <- capHistConvert(ex2,id="fish",in.type="event",out.type="MARK") )
# convert to 'RMark' format
( ex2.E2R <- capHistConvert(ex2,id="fish",in.type="event",out.type="RMark") )

## convert converted 'individual' format ...
# to 'frequency' format
( ex2.I2F <- capHistConvert(ex2.E2I,id="fish",in.type="individual",out.type="frequency") )
# to 'MARK' format
( ex2.I2M <- capHistConvert(ex2.E2I,id="fish",in.type="individual",out.type="MARK") )
# to 'RMark' format
( ex2.I2R <- capHistConvert(ex2.E2I,id="fish",in.type="individual",out.type="RMark") )
# to 'event' format
( ex2.I2E <- capHistConvert(ex2.E2I,id="fish",in.type="individual",out.type="event") )

## demo use of var.lbls
( ex2.E2Ia <- capHistConvert(ex2,id="fish",in.type="event",var.lbls.pre="Sample") )
( ex2.E2Ib <- capHistConvert(ex2,id="fish",in.type="event",
              var.lbls=c("first","second","third","fourth")) )

## demo use of event.ord
( ex2.I2Ea <- capHistConvert(ex2.E2Ib,id="fish",in.type="individual",out.type="event") )
( ex2.E2Ibad <- capHistConvert(ex2.I2Ea,id="fish",in.type="event") )
( ex2.E2Igood <- capHistConvert(ex2.I2Ea,id="fish",in.type="event",
                 event.ord=c("first","second","third","fourth")) )

## ONLY RUN IN INTERACTIVE MODE
\dontrun{

########################################################################
  if (require(Rcapture)) {
    ## A larger example of 'frequency' format (data from Rcapture package)
    data(bunting,package="Rcapture")
    head(bunting)
    # convert to 'individual' format
    bun.F2I <- capHistConvert(bunting,in.type="frequency",freq="freq")
    head(bun.F2I)
    # convert to 'MARK' format
    bun.F2M <- capHistConvert(bunting,id="id",in.type="frequency",freq="freq",out.type="MARK")
    head(bun.F2M)
    # convert converted 'individual' back to 'MARK' format
    bun.I2M <- capHistConvert(bun.F2I,id="id",in.type="individual",out.type="MARK")
    head(bun.I2M)
    # convert converted 'individual' back to 'frequency' format
    bun.I2F <- capHistConvert(bun.F2I,id="id",in.type="individual",
               out.type="frequency",var.lbls.pre="Sample")
    head(bun.I2F)
  }


########################################################################
if (require(marked)) {
    ## A larger example of 'marked' or 'RMark' format, but with a covariate
    ##   and when the covariate is removed there is no frequency or individual
    ##   fish identifier.
    data(dipper,package="marked")
    head(dipper)
    # isolate males and females
    dipperF <- subset(dipper,sex=="Female")
    dipperM <- subset(dipper,sex=="Male")
    # convert females to 'individual' format
    dipF.R2I <- capHistConvert(dipperF,cols2ignore="sex",in.type="RMark")
    head(dipF.R2I)
    # convert males to 'individual' format
    dipM.R2I <- capHistConvert(dipperM,cols2ignore="sex",in.type="RMark")
    head(dipM.R2I)
    # add sex variable to each data.frame and then combine
    dipF.R2I$sex <- "Female"
    dipM.R2I$sex <- "Male"
    dip.R2I <- rbind(dipF.R2I,dipM.R2I)
    head(dip.R2I)
    tail(dip.R2I)
 }
} # end \dontrun


## An example of problem with unused levels
## Create a set of test data with several groups
( df <- data.frame(fish=c("id17","id18","id21","id17","id21","id18","id19","id20","id17"),
                   group=c("B1","B1","B1","B2","B2","B3","B4","C1","C1")) )
#  Let's assume the user wants to subset the data from the "B" group
( df1 <- subset(df,group \%in\% c("B1","B2","B3","B4")) )
#  Looks like capHistConvert() is still using the unused factor
#  level from group C
capHistConvert(df1,id="fish",in.type="event")
# use droplevels() to remove the unused groups and no problem
df1 <- droplevels(df1)
capHistConvert(df1,id="fish",in.type="event")

}
\references{
Ogle, D.H. 2016. \href{https://fishr-core-team.github.io/fishR/pages/books.html#introductory-fisheries-analyses-with-r}{Introductory Fisheries Analyses with R}. Chapman & Hall/CRC, Boca Raton, FL.
}
\seealso{
See \code{\link{capHistSum}} to summarize \dQuote{individual} capture histories into a format usable in \code{\link{mrClosed}} and \code{\link{mrOpen}}. Also see \pkg{Rcapture}, \code{RMark}, or \pkg{marked} packages for handling more complex analyses.
}
\author{
Derek H. Ogle, \email{DerekOgle51@gmail.com}
}
\keyword{manip}
