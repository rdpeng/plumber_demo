## Test 2

library(datasets)
library(stats)
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
    s <- summary(x)
    as.numeric(s)
}


#* Get Variable Information
#* @get /variableInfo2/<varname>
function(varname) {
    varname <- as.character(varname)
    x <- airquality[, varname]
    s <- summary(x)
    as.list(s)
}


#* Predict Ozone Values With Wind
#* @param wind numeric vector of wind values
#* @get /predict1/<wind>
function(wind) {
    input <- data.frame(Wind = as.numeric(wind))
    pred <- predict(fit, input)
    as.numeric(pred)
}

#* Predict Ozone Values With Wind and Temp (GET)
#* @get /predict
function(query) {
    wind <- as.numeric(query$wind)
    input <- data.frame(Wind = wind)
    pred <- predict(fit, input)
    as.numeric(pred)
}


#* Predict Ozone Values With Wind and Temp (GET)
#* @get /predict2
function(query) {
    wind <- as.numeric(query$wind)
    temp <- as.numeric(query$temp)
    input <- data.frame(Wind = wind, Temp = temp)
    pred <- predict(fit2, input)
    as.numeric(pred)
}


#* Predict Ozone Values With Wind and Temp
#* @body body a data frame containing values for Wind and Temp
#* @post /predict3
function(body) {
    body <- as.data.frame(body)
    pred <- predict(fit2, body)
    as.numeric(pred)
}
