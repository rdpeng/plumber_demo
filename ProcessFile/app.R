library(shiny)
library(png)
library(httr)
library(magick)

ui <- fluidPage(
    titlePanel("Upload Your File"),

    sidebarLayout(
        sidebarPanel(
            fileInput(inputId = "upload",
                      label = "Upload Image File:"),
            sliderInput(inputId = "compress",
                        label = "Compression:",
                        min = 1, max = 100,
                        value = 3)
        ),
        mainPanel(
           plotOutput("image_original"),
           plotOutput("image_compress")

        )
    )
)

api_base <- "http://127.0.0.1:8080"

server <- function(input, output) {
    imgdata <- reactive({
        req(input$upload)
        img_file <- input$upload$datapath
        img <- readPNG(img_file)
        img[, , 1]
    })
    output$image_original <- renderPlot({
        plot.new()
        rasterImage(imgdata(), 0, 0, 1, 1)
    })
    output$image_compress <- renderPlot({
        body <- list(imgdata = imgdata(),
                     compression = input$compress)
        body_ser <- serialize(body, NULL)
        r <- POST(paste(api_base, "compress", sep = "/"),
                  body = body_ser,
                  content_type("application/rds"))
        img_comp <- content(r, "raw") |>
            unserialize()
        plot.new()
        rasterImage(img_comp, 0, 0, 1, 1)
    })
}

shinyApp(ui = ui, server = server)
