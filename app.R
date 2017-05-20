library(shiny)

var_options <- names(final)[sapply(final, is.numeric) & !grepl("^i\\.", names(final))]
names(var_options) <- var_options
# names(var_options[var_options == "perc_damaged_houses_pred"]) <- "% damaged houses (predicted)"

ui <- pageWithSidebar(
  headerPanel("Typhoon impact"),
  sidebarPanel(selectInput(inputId = "variable",
                           label = "Select variable to plot:",
                           # choices = c("Mun_Code", "test", "do not select"),
                           choices = var_options,
                           selected = "total_damaged_houses_true")),
  mainPanel(tabsetPanel(tabPanel("Map", plotOutput(outputId = "main_plot", height = "600px")),
                        tabPanel("Histogram",  plotOutput(outputId = "barplot", height = "300px")))
  )
)

server <- function(input, output, session) {
  output$main_plot <- renderPlot({
    p <- ggplot(final) + 
      aes(long, lat, group = group, fill = get(input$variable)) + 
      geom_polygon() +
      # coord_cartesian(xlim = c(119, 127), ylim = c(10, 17)) +
      coord_quickmap() +
      scale_fill_continuous("") #+
      # guides(fill = F, color = F)
    p
  })
  
  output$barplot <- renderPlot({
    if (input$variable %in% names(actuals)) {
      q <- ggplot(actuals[!is.na(get(input$variable))][
        order(-get(input$variable))][1:50]) 
    } else if (input$variable %in% names(predictions)) {
      q <- ggplot(predictions[!is.na(get(input$variable))][
        order(-get(input$variable))][1:50])
    } else if (input$variable %in% names(dt)) {
      q <- ggplot(dt[!is.na(get(input$variable))][
        order(-get(input$variable))][1:50])
    }
    q <- q + aes(x = factor(admin_L3_code, 
                            levels = admin_L3_code[order(-get(input$variable))]), 
                 y = get(input$variable)) + 
      geom_bar(stat = "identity") + 
      scale_x_discrete(labels = function(x) area_names[x]) +
      theme(axis.text.x = element_text(angle = 90, size = 9, vjust = 0.5, hjust = 1)) +
      xlab("") + ylab(input$variable)
    q
  })
}

shinyApp(ui, server)
