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
  dashboardHeader(title = "Oligopeptide Matching", titleWidth = 250),
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      #menuItem("Amino Acid and Mass", tabName = "AminoAcidandMass"),
      menuItem("Combination AA Polyphenol", tabName = "CombinationAApolyphenol"),
      menuItem("Match a single mz", tabName = "Matchasinglemz"),
      menuItem("Match a list of mz", tabName = "Matchalistofmz"),
      menuItem("About", tabName = "about", icon = icon("question")),
      menuItem("Feedback", tabName = "feedback", icon = icon("envelope"))
      # HTML(paste0(
      #   "<br><br><br><br><br><br><br><br><br>",
      #   "<table style='margin-left:auto; margin-right:auto;'>",
      #   "<tr>",
      #   "<td style='padding: 5px;'><a href='https://www.facebook.com/' target='_blank'><i class='fab fa-facebook-square fa-lg'></i></a></td>",
      #   "<td style='padding: 5px;'><a href='https://twitter.com/' target='_blank'><i class='fab fa-twitter fa-lg'></i></a></td>",
      #   "<td style='padding: 5px;'><a href='https://www.instagram.com/' target='_blank'><i class='fab fa-instagram fa-lg'></i></a></td>",
      #   "<td style='padding: 5px;'><a href='http://www.linkedin.com/' target='_blank'><i class='fab fa-linkedin fa-lg'></i></a></td>",
      #   "<td style='padding: 5px;'><a href='https://plus.google.com/' target='_blank'><i class='fab fa-google-plus fa-lg'></i></a></td>",
      #   "<td style='padding: 5px;'><a href='https:/www.youtube.com/' target='_blank'><i class='fab fa-youtube fa-lg'></i></a></td>",
      #   "</tr>",
      #   "</table>",
      #   "<br>"),
      #   HTML(paste0(
      #     "<script>",
      #     "var today = new Date();",
      #     "var yyyy = today.getFullYear();",
      #     "</script>",
      #     "<p style = 'text-align: center;'><small>&copy; - <a href='https://sirineoueida.com' target='_blank'>Sirine Oueida </a> - <script>document.write(yyyy);</script></small></p>")
      #   ))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              h2("Welcome to the Home Page !"),
              includeMarkdown("readME.md")
      ),
      # tabItem(tabName = "AminoAcidandMass",
      #         fluidRow(
      #           sidebarLayout(
      #             sidebarPanel(
      #               style = "width: 200px;",
      #               checkboxGroupInput("columns",
      #                                  label = "Select columns to display:",
      #                                  choices = c("Full_Name", "Symbol", "Amino_Acid", "Mass", "Specification_AA")
      #               ),
      #               actionButton("Ok", label = "Ok", style = "color: white; background-color: #007bff; border-color: #007bff;")
      #             ),
      #             mainPanel(
      #               style = "right: 40px;",
      #               dataTableOutput("amino_acid_table")
      #             ),
      #             position = "right"
      #           )
      #         )
      # ),
      tabItem(tabName = "CombinationAApolyphenol",
              fluidPage(
                sidebarLayout(
                  sidebarPanel(
                    numericInput(inputId = "od",
                                 label = "Oligomerization degree:",
                                 value = 3)
                  ),
                  mainPanel(
                    h3("Combination AA Polyphenol"),
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
                                 value = 5),
                    actionButton("Ok", label = "Ok", style = "color: white; background-color: #007bff; border-color: #007bff;")
                  ),
                  mainPanel(
                    downloadButton("downloadData", "Download", style = "position: fixed; bottom: 20px; left: 85%"),
                    h3("Match a single mz"),
                    withSpinner(DT::dataTableOutput("view_filter_mz_obs"))
                  ),
                  position = "right"
                )
              )
      ),
      tabItem(tabName = "Matchalistofmz",
              fluidPage(
                title = "Match a list of mz",
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
                    textInput("mz_column", "Enter number of the column of m/z:", placeholder = "e.g., mz"),
                    textInput("RT_column", "Enter number of the column of RT:", placeholder = "e.g., RT"),
                    numericInput(inputId = "ppm_error",
                                 label = "Tolerance:",
                                 value = 5),
                    actionButton("update", "Search Match", style = "color: white; background-color: #007bff; border-color: #007bff;"),
                    tableOutput("files")
                  ),
                  mainPanel(
                    h3("Match a list of mz"),
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
  # selected_columns <- eventReactive(input$Ok, {
  #   columns <- input$columns
  #   if (is.null(columns)) {
  #     names(aa_mw)
  #   } else {
  #     columns
  #   }
  # })
  # 
  # output$amino_acid_table <- renderDataTable({
  #   datatable(aa_mw[, selected_columns()], rownames = FALSE, options = list(paging = FALSE)) %>%
  #     formatStyle(
  #       'Specification_AA',
  #       backgroundColor = styleEqual(
  #         unique(aa_mw$Specification_AA),
  #         c('Non-polaire' = 'lightyellow', 'Polaire' = 'skyblue', 'Charge Negative' = 'orchid', 'Charge Positive' = 'palegreen')
  #       ),
  #       fontWeight = 'bold'
  #     )
  # })
  
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
