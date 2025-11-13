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
    dat <- as.data.frame(body)
    message(sprintf("making predictions with %d points", nrow(dat)))
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
    dat <- as.data.frame(body)
    message("making a plot with ", nrow(dat), " points")
    p <- map_data("state") |>
        ggplot(aes(long, lat)) +
        geom_point(aes(lon, lat, color = pred),
                   data = dat, size = 2) +
        scale_color_viridis_c() +
        geom_path(aes(group = group)) +
        coord_fixed() +
        theme_bw()
    print(p)
}

