# Libraries
#install.packages("anyLib")
#anyLib::anyLib(c("shiny", "shinydashboard", "shinyWidgets", "DT", "plotly", "ggplot2", "googleVis", "colourpicker"))

library(shiny)
library(shinydashboard)
library(DT)
library(oligopeptidesMatching)
library(shinycssloaders)

source("https://raw.githubusercontent.com/p2m2/oligopeptides_matching/develop/oligopeptides_matching/data.R")


ui <- dashboardPage(
  dashboardHeader(title = "Oligopeptides Matching", titleWidth = 250),
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Welcome!", tabName = "home", icon = icon("home")),
      menuItem("Search", tabName = "search", icon = icon("search")),
      menuItem("ReadMe", tabName = "readme", icon = icon("book")), 
      #icon("mortar-board")),
      menuItem("Amino Acid and Mass", tabName = "AminoAcidandMass"),
      menuItem("Combination AA Polyphenol", tabName = "CombinationAApolyphenol"),
      menuItem("Match a single mz", tabName = "Matchasinglemz"),
      menuItem("Match a list of mz", tabName = "Matchalistofmz"),
      menuItem("About", tabName = "about", icon = icon("question"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "AminoAcidandMass",
              fluidRow(
                sidebarLayout(
                  sidebarPanel(
                    style = "width: 200px;",
                    checkboxGroupInput("columns",
                                       label = "Select columns to display:",
                                       choices = c("Full_Name", "Symbol", "Amino_Acid", "Mass", "Specification_AA")
                    ),
                    actionButton("Ok", label = "Ok", style = "color: white; background-color: #007bff; border-color: #007bff;")
                  ),
                  mainPanel(
                    style = "right: 40px;",
                    dataTableOutput("amino_acid_table")
                  ),
                  position = "right"
                )
              )
      ),
      tabItem(tabName = "CombinationAApolyphenol",
              fluidPage(
                title = "Combination AA Polyphenol",
                sidebarLayout(
                  sidebarPanel(
                    numericInput(inputId = "od",
                                 label = "Oligomerization degree:",
                                 value = 3)
                  ),
                  mainPanel(
                    h3("Oligopeptides"),
                    withSpinner(DT::dataTableOutput("view_arrangement"))
                  ),
                  position = "right"
                )
              )
      ),
      tabItem(tabName = "Matchasinglemz",
              fluidPage(
                sidebarLayout(
                  sidebarPanel(
                    numericInput(inputId = "mz_obs",
                                 label = "M/z observed:",
                                 value = 953.669),
                    selectInput("ionization", "Ionization:",
                                c("Already charged" = "already_charged",
                                  "Positive" = "pos",
                                  "Negative" = "neg")),
                    numericInput(inputId = "ppm_error",
                                 label = "Tolerance:",
                                 value = 5)
                  ),
                  mainPanel(
                    downloadButton("downloadData", "Download", style = "position: fixed; bottom: 20px; left: 85%"),
                    h3("Oligopeptides"),
                    withSpinner(DT::dataTableOutput("view_filter_mz_obs"))
                  ),
                  position = "right"
                )
              )
      ),
      tabItem(tabName = "Matchalistofmz",
              fluidPage(
                sidebarLayout(
                  sidebarPanel(
                    fileInput("file1", "Choose CSV file", NULL, buttonLabel = "Upload a file...",
                              multiple = FALSE,
                              accept = c("text/csv",
                                         "text/comma-separated-values,text/plain",
                                         ".csv")),
                    tags$hr(),
                    checkboxInput("header", "Header", TRUE),
                    radioButtons("sep", "Separator",
                                 choices = c(Comma = ",",
                                             Semicolon = ";",
                                             Tab = "\t"),
                                 selected = ","),
                    textInput("mz_column", "Enter the column of m/z:", placeholder = "e.g., mz"),
                    textInput("RT_column", "Enter the column of RT:", placeholder = "e.g., RT"),
                    numericInput(inputId = "ppm_error",
                                 label = "Tolerance:",
                                 value = 5),
                    actionButton("update", "Update Table", style = "color: white; background-color: #007bff; border-color: #007bff;"),
                    tableOutput("files")
                  ),
                  mainPanel(
                    downloadButton("downloadData", "Download", style = "position: fixed; bottom: 20px; left: 85%")
                  )
                )
              )
      ),
      tabItem(tabName = "about",
              fluidPage(
                tags$iframe(src = 'https://github.com/p2m2/oligopeptides_matching/tree/stage-m1-2024-2/README.Rmd',
                            width = '100%', height = '800px',
                            frameborder = 0, scrolling = 'auto'
                )
              )
      )
    )
  )
)

server <- function(input, output) {
  selected_columns <- eventReactive(input$Ok, {
    columns <- input$columns
    if (is.null(columns)) {
      names(aa_mw)
    } else {
      columns
    }
  })
  
  output$amino_acid_table <- renderDataTable({
    datatable(aa_mw[, selected_columns()], rownames = FALSE, options = list(paging = FALSE)) %>%
      formatStyle(
        'Specification_AA',
        backgroundColor = styleEqual(
          unique(aa_mw$Specification_AA),
          c('Non-polaire' = 'lightyellow', 'Polaire' = 'skyblue', 'Charge Negative' = 'orchid', 'Charge Positive' = 'palegreen')
        ),
        fontWeight = 'bold'
      )
  })
  
  combination_compounds <- reactive({
    req(input$od)
    aaa_combined <- get_oligopeptides(
      aminoacids = aa_mw,
      oligomerization_degree = input$od
    )
    aa_combined <- as.data.frame(aaa_combined)
    aa_combined_names <- c(aa_combined$id)
    aa_combined_mass <- c(aa_combined$MW)
    aa_combined_mw <- setNames(aa_combined_mass, aa_combined_names)
    return(get_combination_compounds(
      oligopeptides = aaa_combined,
      polyphenols = polyphenols,
      chemical_derivation = chemical_derivation,
      addition_reaction = 10))
  })
  
  output$view_arrangement <- renderDT({
    combination_compounds()
  })
  
  filtered_mz_obs <- reactive({
    req(input$mz_obs, input$ppm_error)
    data <- match_mz_obs(
      mz_obs = input$mz_obs,
      ionization = 'already_charged',
      combination_compounds(),
      ppm_error = input$ppm_error
    )
    if (is.null(data)) {
      return(NULL)
    } else {
      if (!is.data.frame(data)) {
        data <- as.data.frame(data)
      }
      return(data)
    }
  })
  
  output$view_filter_mz_obs <- renderDT({
    filtered_mz_obs()
  })
  
  output$files <- renderTable(input$file1)
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$file1, ".csv", sep = "")
    },
    content = function(file1) {
      write.csv(datasetInput(), file1, row.names = FALSE)
    }
  )
}

shinyApp(ui, server)
