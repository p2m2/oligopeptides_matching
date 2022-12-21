library(shiny)
install.packages("..")

# See above for the definitions of ui and server
ui <- fluidPage(

  # App title ----
  titlePanel("Shiny Text"),

  # Sidebar layout with a input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Numeric entry for number of obs to view ----
      numericInput(inputId = "od",
                   label = "Oligomerization degree:",
                   value = 3)
    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: HTML table with requested number of observations ----
      tableOutput("view")

    )
  )
)

server <- function(input, output) {

  # Show the first "n" observations ----
  output$view <- renderTable({
    #head(datasetInput(), n = input$od)
    peptide_matrix <- get_oligopeptides(aminoacids = stats::setNames(c(89.047679),c("A")),chemical_reaction = 18.010565,ionization = stats::setNames(c(1.007825),c("H")),oligomerization_degree = 4)
    return (peptide_matrix)
  })

}

shinyApp(ui = ui, server = server)