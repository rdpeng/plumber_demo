## Test 2

library(datasets)
library(stats)
library(jsonlite)
data(airquality)
fit <- lm(Ozone ~ Wind, data = airquality)

#* Predict Ozone Values
#* @param wind numeric vector of wind values
#* @post /predict
function(wind) {
    wind <- fromJSON(wind) |>
        as.numeric()
    input <- data.frame(Wind = wind)
    pred <- predict(fit, input)
    as.numeric(pred)
}
