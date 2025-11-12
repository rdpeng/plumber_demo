data(airquality)

#* Make a Scatterplot
#*
#* @get /scatterplot
#* @query xvar:string x-variable for plotting
#* @query yvar:string y-variable for plotting
#* @serializer png
#*
function(query) {
    message("making scatterplot!")
    x <- airquality[, query$xvar]
    y <- airquality[, query$yvar]
    plot(x, y, xlab = query$xvar, ylab = query$yvar)
}
