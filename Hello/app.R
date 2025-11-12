library(shiny)

ui <- fluidPage(
    titlePanel("Say Hello!"),
    sidebarLayout(
        sidebarPanel(
            textInput(inputId = "name",
                      label = "Enter Name:")
        ),
        mainPanel(
           h2(textOutput("message"))
        )
    )
)

server <- function(input, output) {
    output$message <- renderText({
        if(nchar(input$name) == 0L)
            return("")
        url_string <- paste("http://127.0.0.1:8080/hello",
                            input$name, sep = "/")
        r <- GET(url_string)
        content(r, "text") |>
            fromJSON()
    })
}

shinyApp(ui = ui, server = server)
