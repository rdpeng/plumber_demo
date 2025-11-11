## Run local

## Run server

library(plumber2)

args <- commandArgs(TRUE)
rfile <- args
if(length(rfile) > 1L) {
    stop("only one file please!")
}
if(!file.exists(rfile)) {
    stop("can't find file ", rfile)
}

pa <- api(rfile, port = 8080)
api_run(pa)
