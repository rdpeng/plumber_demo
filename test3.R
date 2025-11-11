## In-Class Test

library(utils)

dataset <- read.csv("data.csv")

#* Get Variable Names
#* @get /variables
function() {
    message("getting names at ", Sys.time())
    names(dataset)
}

#* Get Variable Information
#* @get /variableInfo/<varname>
function(varname) {
    message(sprintf("getting variable info for '%s' at %s",
                    varname, format(Sys.time())))
    varname <- as.character(varname)
    if(!(varname %in% names(dataset))) {
        abort_bad_request(sprintf("varname '%s' not in dataset", varname))
    }
    x <- dataset[, varname]
    s <- summary(x)
    as.list(s)
}
