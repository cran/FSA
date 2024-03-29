#' @title Adds model fits from nls iterations to active plot.
#'
#' @description Adds model fits from iterations of the \code{\link[stats]{nls}} algorithm as returned when \code{trace=TRUE}. Useful for diagnosing model fitting problems or issues associated with starting values.
#'
#' @details Nonlinear models fit with the \code{\link[stats]{nls}} function start with starting values for model parameters and iteratively search for other model parameters that continuously reduce the residual sum-of-squares (RSS) until some pre-determined criterion suggest that the RSS cannot be (substantially) further reduced. With good starting values and well-behaved data, the minimum RSS may be found in a few (<10) iterations. However, poor starting values or poorly behaved data may lead to a prolonged and possibly failed search. An understanding of the iterations in a prolonged or failed search may help identify the failure and lead to choices that may result in a successful search. The \code{trace=TRUE} argument of \code{\link[stats]{nls}} allows one to see the values at each iterative step. The function documented here plots the \dQuote{trace} results at each iteration on a previously existing plot of the data. This creates a visual of the iterative process.
#' 
#' The \code{object} argument may be an object saved from a successful run of \code{\link[stats]{nls}}. See the examples with \code{SpotVA1} and \code{CodNorwegion}.
#' 
#' However, if \code{\link[stats]{nls}} fails to converge to a solution then no useful object is returned. In this case, \code{trace=TRUE} must be added to the failed \code{\link[stats]{nls}} call. The call is then wrapped in \code{\link{try}} to work-around the failed convergence error. This is also wrapped in \code{\link[utils]{capture.output}} to capture the \dQuote{trace} results. This is then saved to an object that which can then be the \code{object} of the function documented here. This process is illustrated with the example using \code{BSkateGB}.
#' 
#' The function in \code{fun} is used to make predictions given the model parameter values at each step of the iteration. This function must accept the explanatory/independent variable as its first argument and values for all model parameters in a vector as its second argument. These types of functions are returned by \code{\link{vbFuns}}, \code{\link{GompertzFuns}}, \code{\link{logisticFuns}}, and \code{\link{RichardsFuns}} for common growth models and \code{\link{srFuns}} for common stock-recruitment models. See the examples.
#'
#' @note The position of the \dQuote{legend} can be controlled in three ways. First, if \code{legend=TRUE}, then the R console is suspended until the user places the legend on the plot by clicking on the point where the upper-left corner of the legend should appear. Second, \code{legend=} can be set to one of \code{"bottomright"}, \code{"bottom"}, \code{"bottomleft"}, \code{"left"}, \code{"topleft"}, \code{"top"}, \code{"topright"}, \code{"right"} and \code{"center"}. In this case, the legend will be placed inside the plot frame at the given location. Finally, \code{legend=} can be set to a vector of length two which identifies the plot coordinates for the upper-left corner of where the legend should be placed. A legend will not be drawn if \code{legend=FALSE} or \code{legend=NULL}.
#' 
#' @param object An object saved from \code{\link[stats]{nls}} or from \code{\link[utils]{capture.output}} using \code{\link{try}} with \code{\link[stats]{nls}}. See details.
#' @param fun A function that represents the model being fit in \code{\link[stats]{nls}}. This must take the x-axis variable as the first argument and model parameters as a vector in the second argument. See details.
#' @param from,to The range over which the function will be plotted. Defaults to range of the x-axis of the active plot.
#' @param n The number of value at which to evaluate the function for plotting (i.e., the number of values from \code{from} to \code{to}). Larger values make smoother lines.
#' @param lwd A numeric used to indicate the line width of the fitted line.
#' @param col A single character string that is a palette from \code{\link[grDevices]{hcl.pals}} or a vector of character strings containing colors for the fitted lines at each trace.
#' @param rev.col A logical that indicates that the order of colors for plotting the lines should be reversed.
#' @param legend Controls use and placement of the legend. See details.
#' @param cex.leg A single numeric value that represents the character expansion value for the legend. Ignored if \code{legend=FALSE}.
#' @param box.lty.leg A single numeric values that indicates the type of line to use for the box around the legend. The default is to not plot a box.
#' @param add A logical indicating whether the lines should be added to the existing plot (defaults to \code{=TRUE}).
#' 
#' @return A matrix with the residual sum-of-squares in the first column and parameter estimates in the remaining columns for each iteration (rows) of \code{\link[stats]{nls}} as provided when \code{trace=TRUE}.
#' 
#' @author Derek H. Ogle, \email{DerekOgle51@gmail.com}
#'
#' @keywords plot
#'
#' @examples
#' ## Examples following a successful fit
#' vb1 <- vbFuns()
#' fit1 <- nls(tl~vb1(age,Linf,K,t0),data=SpotVA1,start=list(Linf=12,K=0.3,t0=0))
#' plot(tl~age,data=SpotVA1,pch=21,bg="gray40")
#' nlsTracePlot(fit1,vb1,legend="bottomright")
#' 
#' r1 <- srFuns("Ricker")
#' fitSR1 <- nls(log(recruits)~log(r1(stock,a,b)),data=CodNorwegian,start=list(a=3,b=0.03))
#' plot(recruits~stock,data=CodNorwegian,pch=21,bg="gray40",xlim=c(0,200))
#' nlsTracePlot(fitSR1,r1)
#' 
#' # no plot, but returns trace results as a matrix
#' ( tmp <- nlsTracePlot(fitSR1,r1,add=FALSE) )
#' 
#' \dontrun{
#' if (require(FSAdata)) {
#'   data(BSkateGB,package="FSAdata")
#'   wtr <- droplevels(subset(BSkateGB,season=="winter"))
#'   bh1 <- srFuns()
#'   trc <- capture.output(try(
#'   fitSR1 <- nls(recruits~bh1(spawners,a,b),wtr,
#'                 start=srStarts(recruits~spawners,data=wtr),trace=TRUE)
#'   ))
#'   plot(recruits~spawners,data=wtr,pch=21,bg="gray40")
#'   nlsTracePlot(trc,bh1)
#'   # zoom in on y-axis
#'   plot(recruits~spawners,data=wtr,pch=21,bg="gray40",ylim=c(0.02,0.05))
#'   nlsTracePlot(trc,bh1,legend="top")
#'   # return just the trace results
#'   ( tmp <- nlsTracePlot(trc,bh1,add=FALSE) )
#' }
#' }
#' 
#' @export
nlsTracePlot <- function(object,fun,from=NULL,to=NULL,n=199,
                         lwd=2,col=NULL,rev.col=FALSE,
                         legend="topright",cex.leg=0.9,box.lty.leg=0,
                         add=TRUE) {
  ## Checks
  if (!inherits(object,c("nls","character")))
    STOP("'object' must be from 'nls()' or from 'capture.output()'.")
  fun <- match.fun(fun)
  if (n<2) STOP("'n' must be greater than 2.")
  ## Determine if need to capture trace (if object is object from nls())
  if (inherits(object,"nls")) {
    object <- utils::capture.output( try(tmp <- stats::update(object,.~.,
                                                              trace=TRUE),
                                         silent=TRUE) )
  }
  ## parse trace into a data.frame
  ## The output of nls() when trace=TRUE changed with R version 4.1 ... thus
  ## we need to handle pre-4.1 different from 4.1+
  newTraceVersion <- getRversion() >= "4.1"
  if (newTraceVersion) {
    trcDF <- sub(".*par = ","",object)
    trcDF <- substring(trcDF,2,nchar(trcDF)-1)
    trcDF <- unlist(strsplit(trcDF," "))
  } else {
    trcDF <- sub(".*:  ","",object)
    trcDF <- unlist(strsplit(trcDF," "))
    trcDF <- trcDF[trcDF!=""]
  }
  trcDF <- matrix(as.numeric(trcDF),nrow=length(object),byrow=TRUE)
  ## plot each iteration onto existing plot
  if (add) {
    ## process legend
    leg <- iLegendHelp(legend)
    if (!iPlotExists()) STOP("An active plot does not exist.")
    niter <- nrow(trcDF)
    col <- iCheckMultColor(col,niter)
    if (rev.col) col <- rev(col)
    if (is.null(from)) from <- graphics::par("usr")[1L] # nocov start
    if (is.null(to)) to <- graphics::par("usr")[2L]
    xs <- seq(from,to,length.out=n)
    for (i in 1:niter) {
      ys <- do.call(fun,list(xs,trcDF[i,]))
      graphics::lines(xs,ys,lwd=lwd,col=col[i])
    }
    ## add legend if asked for
    if (leg$do.legend) {
      lbls <- c("start",paste0("end (",niter,")"))
      graphics::legend(x=leg$x,y=leg$y,legend=lbls,
                       col=col[c(1,niter)],lwd=lwd,
                       bty="n",cex=cex.leg,box.lty=box.lty.leg)
    } # nocov end
  }
  ## return trace data.frame
  invisible(trcDF)
}
