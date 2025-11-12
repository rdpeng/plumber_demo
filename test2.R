## Test 2

library(datasets)
library(stats)
data(airquality)
fit <- lm(Ozone ~ Wind, data = airquality)
fit2 <- lm(Ozone ~ Wind + Temp, data = airquality)

#* Predict Ozone Values With Wind
#* @param wind numeric vector of wind values
#* @serializer json
#* @get /predict1/<wind>
function(wind) {
    input <- data.frame(Wind = as.numeric(wind))
    pred <- predict(fit, input)
    as.numeric(pred)
}

#* Predict Ozone Values With Wind (query)
#* @query wind:numeric vector of wind values
#* @serializer json
#* @get /predict
function(query) {
    wind <- as.numeric(query$wind)
    input <- data.frame(Wind = wind)
    pred <- predict(fit, input)
    as.numeric(pred)
}


#* Predict Ozone Values With Wind and Temp (query)
#* @query wind:numeric vector of wind values
#* @query temp:numeric vector of temperature values
#* @serializer json
#* @get /predict2
function(query) {
    wind <- as.numeric(query$wind)
    temp <- as.numeric(query$temp)
    input <- data.frame(Wind = wind, Temp = temp)
    pred <- predict(fit2, input)
    as.numeric(pred)
}


#* Predict Ozone Values With Wind and Temp (POST)
#* @post /predict3
#* @serializer json
function(body) {
    body <- as.data.frame(body)
    pred <- predict(fit2, body)
    as.numeric(pred)
}

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

