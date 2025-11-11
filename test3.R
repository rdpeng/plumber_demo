## In-Class Test

library(utils)

dataset <- read.csv("data.csv")

#* Get Variable Names
#* @get /variables
function() {
    message("getting names ", Sys.time())
    names(dataset)
}

#* Get Variable Information
#* @get /variableInfo/<varname>
function(varname) {
    message("getting variable info ", Sys.time())
    varname <- as.character(varname)
    if(!(varname %in% names(dataset))) {
        abort_bad_request(sprintf("varname '%s' not in dataset", varname))
    }
    x <- dataset[, varname]
    s <- summary(x)
    as.list(s)
}
