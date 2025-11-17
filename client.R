################################################################################
## ml_example.R

library(httr)
library(splancs)
library(ggplot2)
library(readr)

pmdat <- read_csv("pm25_data.csv.bz2")
map_data("state") |>
    ggplot(aes(long, lat)) +
    geom_path(aes(group = group)) +
    geom_point(aes(lon, lat, color = value),
               shape = 15, data = pmdat) +
    scale_color_viridis_c() +
    coord_fixed()

################################################################################

## api_base <- "http://164.90.154.116:8080"
api_base <- "http://127.0.0.1:8080"

## Great a regular grid of lon/lat at which predictions will be made
g <- expand.grid(lon = seq(-125, -65, len = 40),
                 lat = seq(25, 50, len = 20))

## Get predicted values for grid
p <- POST(paste(api_base, "predict", sep = "/"),
          body = serialize(g, NULL),
          content_type("application/rds"))

## Unserialize response to data frame
p <- content(p, "raw") |>
    unserialize()
p |> head(10)

## Subset points to continental US
p <- p[p$in_usa, ]

## Send predicted values to obtain plot
r <- POST(paste(api_base, "plot", sep = "/"),
          body = serialize(p, NULL),
          content_type("application/rds"))

## Write out binary PNG data to a temporary file and the open in Preview
viewImage <- function(response) {
    bytes <- content(response, "raw")
    tfile <- paste(tempfile(), "png", sep = ".")
    writeBin(bytes, tfile)
    system(paste("open", tfile))
}

## View the image file
r |> viewImage()

## View the image directly/
library(magick)
content(r, "raw") |>
    image_read() |>
    plot()


################################################################################
## Texas only

g <- expand.grid(lon = seq(-115, -90, len = 100),
                 lat = seq(25, 37, len = 80))
p <- POST(paste(api_base, "predict", sep = "/"),
          body = serialize(g, NULL),
          content_type("application/rds"))
p <- content(p, "raw") |>
    unserialize()
p |> head(10)

tx <- map_data("state", "texas")
p$in_tx <- splancs::inout(cbind(x = p$lon, y = p$lat),
                          cbind(x = tx$long, tx$lat))
head(p)
p |>
    dplyr::filter(in_tx) |>
    ggplot() +
    geom_raster(aes(lon, lat, fill = pred)) +
    geom_path(aes(long, lat), data = map_data("state", "texas"),
              linewidth = 1) +
    scale_fill_viridis_c() +
    coord_fixed() +
    theme_bw()


