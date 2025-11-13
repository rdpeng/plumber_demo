library(randomForest)
library(readr)
library(ggplot2)

dat <- read_csv("pm25_data.csv.bz2")
fit <- randomForest(value ~ lat + lon,
                    data = dat, ntree = 1000)

#* Obtain Predicted PM2.5 Values
#*
#* @post predict
#*
#* @parser rds
#* @serializer rds
#*
function(body) {
    message("making predictions!")
    dat <- as.data.frame(body)
    pred <- predict(fit, dat)
    dat$pred <- pred
    dat[, c("lon", "lat", "pred")]
}

#* Plot PM2.5 Values on Map
#*
#* @post plot
#* @parser rds
#* @serializer png{width = 640, height = 480}
#*
function(body) {
    message("making plot!")
    dat <- as.data.frame(body)
    p <- map_data("usa") |>
        ggplot(aes(long, lat)) +
        geom_path(aes(group = group)) +
        geom_point(aes(lon, lat, color = pred),
                   data = dat, size = 2) +
        scale_color_viridis_c() +
        coord_fixed() +
        theme_bw()
    print(p)
}

