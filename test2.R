## Test 2

library(datasets)
library(stats)
library(jsonlite)
data(airquality)
fit <- lm(Ozone ~ Wind, data = airquality)
fit2 <- lm(Ozone ~ Wind + Temp, data = airquality)


#* Get Variable Names
#* @get /variables
function() {
    names(airquality)
}

#* Get Variable Information
#* @get /variableInfo/<varname>
function(varname) {
    varname <- as.character(varname)
    x <- airquality[, varname]
    as.numeric(summary(x))
}

#* Predict Ozone Values With Wind
#* @param wind numeric vector of wind values
#* @get /predict/<wind>
function(wind) {
    input <- data.frame(Wind = as.numeric(wind))
    pred <- predict(fit, input)
    as.numeric(pred)
}


## When you need to send more complex data; use POST

#* Predict Ozone Values With Wind and Temp
#* @body body a data frame containing values for Wind and Temp
#* @post /predict2
function(body) {
    body <- as.data.frame(body)
    pred <- predict(fit2, body)
    as.numeric(pred)
}
