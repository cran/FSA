% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FSAUtils.R
\name{fishR}
\alias{fishR}
\title{Opens web pages associated with the fishR website.}
\usage{
fishR(
  where = c("home", "IFAR", "general", "books", "AIFFD", "posts", "news"),
  open = TRUE
)
}
\arguments{
\item{where}{A string that indicates a particular page on the fishR website to open.}

\item{open}{A logical that indicates whether the webpage should be opened in the default browser. Defaults to \code{TRUE}; \code{FALSE} is used for unit testing.}
}
\value{
None, but a webpage will be opened in the default browser.
}
\description{
Opens web pages associated with the \href{https://derekogle.com/fishR/}{fishR website} in a browser. The user can open the main page or choose a specific page to open.
}
\examples{
\dontrun{
## Opens an external webpage ... only run interactively
fishR()            # home page
fishR("IFAR")      # Introduction to Fisheries Analysis with R page
fishR("general")   # examples page
fishR("books")     # examples page
fishR("AIFFD")     # Analysis & Interpretation of Freshw. Fisher. Data page
fishR("posts")     # blog posts (some examples) page
}

}
\author{
Derek H. Ogle, \email{derek@derekogle.com}
}
\keyword{misc}
