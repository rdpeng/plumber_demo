library(shiny)
library(magick)
library(httr)

## api_base <- "http://164.90.154.116:8080"
api_base <- "http://127.0.0.1:8080"

ui <- fluidPage(
    titlePanel("Map PM2.5 Data in the USA"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("xgrid",
                        "Size of x-grid:",
                        min = 10,
                        max = 140,
                        value = 40),
            sliderInput("ygrid",
                        "Size of y-grid:",
                        min = 10,
                        max = 140,
                        value = 20)
        ),
        mainPanel(
           plotOutput("pmMap")
        )
    )
)

server <- function(input, output) {
    output$pmMap <- renderPlot({
        gridsize <- list(xgrid = input$xgrid,
                         ygrid = input$ygrid)
        r <- POST(paste(api_base, "plot", sep = "/"),
                  body = serialize(gridsize, NULL),
                  content_type("application/rds"))
        content(r, "raw") |>
            image_read() |>
            plot()
    })
}

# Run the application
shinyApp(ui = ui, server = server)
