# Libraries
#install.packages("anyLib")
#anyLib::anyLib(c("shiny", "shinydashboard", "shinyWidgets", "DT", "plotly", "ggplot2", "googleVis", "colourpicker"))

library(shiny)
library(shinydashboard)
library(DT)
library(oligopeptidesMatching) 
library(shinycssloaders)
library(dplyr)

#source("https://raw.githubusercontent.com/p2m2/oligopeptides_matching/develop/oligopeptides_matching/data.R")


ui <- dashboardPage(
  dashboardHeader(title = "Oligopeptides Matching", titleWidth = 250),
  dashboardSidebar(
    width = 250,
    tags$style(HTML(".share-buttons { text-align: center; margin-top: 20px; }" )),
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      #menuItem("Amino Acid and Mass", tabName = "AminoAcidandMass"),
      menuItem("Amino-acid assemblies", tabName = "assemblies", icon = icon("calculator")),
      menuItem("Combination AA Polyphenol", tabName = "CombinationAApolyphenol"),
      menuItem("Match a single mz", tabName = "Matchasinglemz"),
      menuItem("Match a list of mz", tabName = "Matchalistofmz"),
      menuItem("About", tabName = "about", icon = icon("question")),
      menuItem("Feedback", tabName = "feedback", icon = icon("envelope"))
    ),
  #   tags$div(
  #     class = "share-buttons",
  #     tags$a(href = "https://www.facebook.com/sharer/sharer.php?u=https://si-o-02-bioinfo.shinyapps.io/oligopeptides_matching/", target = "_blank", icon("facebook")),
  #     tags$a(href = "https://twitter.com/intent/tweet?url=https://si-o-02-bioinfo.shinyapps.io/oligopeptides_matching/", target = "_blank", icon("twitter")),
  #     tags$a(href = "https://www.linkedin.com/shareArticle?url=https://si-o-02-bioinfo.shinyapps.io/oligopeptides_matching/", target = "_blank", icon("linkedin")),
  #   )
  # ),
      HTML(paste0(
        "<br><br><br><br><br><br><br><br><br>",
        "<table style='margin-left:auto; margin-right:auto; '>",
        "<tr>",
        "<td style='padding: 5px;'><a href='https://www.facebook.com/sharer/sharer.php?u=https://si-o-02-bioinfo.shinyapps.io/oligopeptides_matching/' target='_blank'><i class='fab fa-facebook-square fa-lg'></i></a></td>",
        "<td style='padding: 5px;'><a href='https://twitter.com/tweet?url=https://si-o-02-bioinfo.shinyapps.io/oligopeptides_matching/' target='_blank'><i class='fab fa-twitter fa-lg'></i></a></td>",
        "<td style='padding: 5px;'><a href='https://www.instagram.com/' target='_blank'><i class='fab fa-instagram fa-lg'></i></a></td>",
        "<td style='padding: 5px;'><a href='http://www.linkedin.com/shareArticle?url=https://si-o-02-bioinfo.shinyapps.io/oligopeptides_matching/' target='_blank'><i class='fab fa-linkedin fa-lg'></i></a></td>",
        "<td style='padding: 5px;'><a href='https://plus.google.com/' target='_blank'><i class='fab fa-google-plus fa-lg'></i></a></td>",
        "</tr>",
        "</table>",
        "<br>")
      )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              h2("Welcome to the Home Page !"),
              tagList(
                includeMarkdown("welcome.md")
              )
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
        tabItem(tabName = "assemblies",
              fluidPage(
                  sidebarLayout(
                    sidebarPanel(
                      numericInput("od_1", "Oligomerization degree:", value = 1, min = 1),
                      actionButton("calculate", "Calculate", style = "color: white; background-color: #007bff; border-color: #007bff;")
                  ),
                  mainPanel(
                    h3("Amino-acid assemblies"),
                    conditionalPanel(
                      condition = "input.calculate > 0",
                      withSpinner(DT::dataTableOutput("results"))
                    )
                  ),
                  position = "right"
                  )
                )
      ),
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
                    downloadButton("downloadDataSingle", "Download", style = "position: fixed; bottom: 20px; left: 85%"),
                    h3("Match a single mz"),
                    conditionalPanel(
                      condition = "input.Ok > 0",
                      withSpinner(DT::dataTableOutput("view_filter_mz_obs"))
                    )
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
                    numericInput("name_column", "Enter the column number of feature name:", value = 1),
                    numericInput("mz_column", "Enter the column number of m/z:", value = 2),
                    numericInput("RT_column", "Enter the column number of RT:", value = 3),
                    numericInput(inputId = "ppm_error",
                                 label = "Tolerance:",
                                 value = 5),
                    actionButton("update", "Search Match", style = "color: white; background-color: #007bff; border-color: #007bff;"),
                    tableOutput("files")
                  ),
                  mainPanel(
                    downloadButton("downloadDataList", "Download", style = "position: fixed; bottom: 20px; left: 85%"),
                    h3("Match a list of mz"),
                    conditionalPanel(
                      condition = "input.update > 0",
                      withSpinner(DT::dataTableOutput("view_match"))
                    )
                  )
                )
              )
      )
      # tabItem(tabName = "about",
      #         fluidPage(
      #           tags$iframe(src = 'https://github.com/p2m2/oligopeptides_matching/tree/stage-m1-2024-2/README.Rmd',
      #                       width = '100%', height = '800px',
      #                       frameborder = 0, scrolling = 'auto'
      #           )
      #         )
      # )
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
  filtered_results <- eventReactive(input$calculate, {
    req(input$od_1)
    oligopeptides <- get_oligopeptides(
      aminoacids = aa_mw,
      oligomerization_degree = input$od_1
    )
    as.data.frame(oligopeptides)
  })
  
  output$results <- renderDT({
    filter_od <- filtered_results()
    DT::datatable(filter_od)
  })
 
  # output$results <- renderDT({
  #   filter_od <- filtered_results()
  #   filter_od <- filter_od %>% 
  #     filter(od == input$od_1)
  #   DT::datatable(filter_od)
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
      ionization = input$ionization,
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
  
  observeEvent(input$Ok, {
    Sys.sleep(2)
  output$view_filter_mz_obs <- renderDT({
    filtered_mz_obs()
  })
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$file1, ".csv", sep = "")
    },
    content = function(file1) {
      write.csv(datasetInput(), file1, row.names = FALSE)
    }
  )
  # match_res <- eventReactive(input$update, {
  #   req(input$od)
  #   matching <- match_mz_obs(
  #     aminoacids = aa_mw,
  #     oligomerization_degree = input$od
  #   )
  #   as.data.frame(matching)
  # }) 
  # 
  # output$view_match <- renderDT({
  #   filtered_mz_obs()
  # })
  data <- reactive({
    req(input$file1)
    df <- read.csv(input$file1$datapath, header = input$header, sep = input$sep)
    df
  })
  
  observeEvent(input$update, {
    output$files <- renderTable({
      req(data())
      df <- data()
      selection <- df[, c(input$name_column, input$mz_column, input$RT_column)]
      colnames(selection) <- c("name", "mz", "RT")
      selection
    })
    
    output$view_match <- DT::renderDataTable({
      req(data())
      df <- data()
      selection <- df[, c(input$name_column, input$mz_column, input$RT_column)]
      colnames(selection) <- c("name", "mz", "RT")
      datatable(selection)
    })
    
    
    output$downloadDataList <- downloadHandler(
      filename = function() {
        paste("matched_mz_list", ".csv", sep = "")
      },
      content = function(file) {
        req(data())
        df <- data()
        selection <- df[, c(input$name_column, input$mz_column, input$RT_column)]
        colnames(selection) <- c("name", "mz", "RT")
        write.csv(selection, file, row.names = FALSE)
      }
    )
  })
}

shinyApp(ui, server)
