library(randomForest)
library(readr)
library(ggplot2)
library(splancs)
library(httr)

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

    ## Identify predicted values that are inside the USA boundaries
    usmap <- map_data("usa")
    dat$in_usa <- inout(cbind(dat$lon, dat$lat),
                        cbind(usmap$long, usmap$lat))
    dat[, c("lon", "lat", "pred", "in_usa")]
}

#* Plot PM2.5 Values on Map
#*
#* @post plot
#* @parser rds
#* @serializer png{width = 900, height = 600}
#*
function(body) {
    message("making a plot with ", nrow(dat), " points")
    api_base <- "http://127.0.0.1:8080"

    ## Great a regular grid of lon/lat at which predictions will be made
    g <- expand.grid(lon = seq(-125, -65, len = body$xgrid),
                     lat = seq(25, 50, len = body$ygrid))

    ## Get predicted values for grid
    p <- POST(paste(api_base, "predict", sep = "/"),
              body = serialize(g, NULL),
              content_type("application/rds"))

    ## Unserialize response to data frame
    p <- content(p, "raw") |>
        unserialize()
    p <- p[p$in_usa, ]

    p <- dat |>
        ggplot() +
        geom_raster(aes(lon, lat, fill = pred)) +
        scale_fill_viridis_c() +
        geom_path(aes(long, lat, group = group),
                  data = map_data("state")) +
        coord_fixed() +
        theme_bw()
    print(p)
}

