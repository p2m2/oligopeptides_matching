#!/usr/bin/Rscript

install.packages('rsconnect')

library(devtools)
library(roxygen2)
document()
install()

library(rsconnect)

if ( nchar(Sys.getenv("SHINYAPPSIO_TOKEN"))<=0 ) {
    write("** SHINYAPPSIO_TOKEN empty **",stderr())
    stop(1)
}

if ( nchar(Sys.getenv("SHINYAPPSIO_SECRET"))<=0 ) {
    write("** SHINYAPPSIO_SECRET empty **",stderr())
    stop(1)
}

rsconnect::setAccountInfo(name='p2m2',
			  token=Sys.getenv("SHINYAPPSIO_TOKEN"),
			  secret=Sys.getenv("SHINYAPPSIO_SECRET"))


APP_NAME = Sys.getenv("APP_NAME")

if ( nchar(APP_NAME)<=0 ) {
    APP_NAME='oligopeptides_matching'
}

rsconnect::deployApp('oligopeptides_matching',appName=APP_NAME,forceUpdate = TRUE)