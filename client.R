library(httr)
library(splancs)

## Write out binary PNG data to a temporary file and the open in Preview
viewImage <- function(response) {
    bytes <- content(response, "raw")
    tfile <- paste(tempfile(), "png", sep = ".")
    writeBin(bytes, tfile)
    system(paste("open", tfile))
}

## Great a regular grid of lon/lat at which predictions will be made
g <- expand.grid(lon = seq(-125, -65, len = 120),
                 lat = seq(25, 50, len = 60))

## Get predicted values for grid
p <- POST("http://127.0.0.1:8080/predict",
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
r <- POST("http://127.0.0.1:8080/plot",
          body = serialize(p, NULL),
          content_type("application/rds"))

## View the image
r |> viewPNG()
