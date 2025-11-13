################################################################################
## test3.R

r <- GET("http://127.0.0.1:8080/variableInfo/denom")
content(r, "text") |>
    fromJSON()

r <- GET("http://127.0.0.1:8080/variableInfo/Ozone")
content(r, "text") |>
    fromJSON()

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
    geom_point(aes(lon, lat, color = value), data = pmdat) +
    scale_color_viridis_b() +
    coord_fixed()

################################################################################

## api_base <- "http://164.90.154.116:8080"
api_base <- "http://127.0.0.1:8080"

## Write out binary PNG data to a temporary file and the open in Preview
viewImage <- function(response) {
    bytes <- content(response, "raw")
    tfile <- paste(tempfile(), "png", sep = ".")
    writeBin(bytes, tfile)
    system(paste("open", tfile))
}

## Great a regular grid of lon/lat at which predictions will be made
g <- expand.grid(lon = seq(-125, -65, len = 80),
                 lat = seq(25, 50, len = 40))

## Get predicted values for grid
p <- POST(paste(api_base, "predict", sep = "/"),
          body = serialize(g, NULL),
          content_type("application/rds"))

## Unserialize response to data frame
p <- content(p, "raw") |>
    unserialize()
p |> head()

## Subset to predicted values that are inside the USA boundaries
usmap <- map_data("usa")
p$in_usa <- inout(cbind(p$lon, p$lat),
                  cbind(usmap$long, usmap$lat))
p <- p[p$in_usa, ]

## Send predicted values to obtain plot
r <- POST(paste(api_base, "plot", sep = "/"),
          body = serialize(p, NULL),
          content_type("application/rds"))

## View the image
r |> viewImage()
