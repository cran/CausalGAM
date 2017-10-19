.onAttach <- function(...) {
 
   # figure out year automatically (probably could be done more elegantly)
   date <- date()
   x <- regexpr("[0-9]{4}", date)
   this.year <- substr(date, x[1], x[1] + attr(x, "match.length") - 1)
   
   # echo output to screen
   packageStartupMessage("##\n## CausalGAM Package\n")
#   cat("## Copyright (C) 2009-", this.year,
   packageStartupMessage("## Copyright (C) 2009",
   " Adam Glynn and Kevin Quinn\n", sep="")
   #require(gam, quietly=TRUE)
}


