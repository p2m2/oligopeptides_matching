library(shiny)
library(shinydashboard)
library(DT)
library(oligopeptidesMatching) 
library(shinycssloaders)
library(markdown)

#source("https://raw.githubusercontent.com/p2m2/oligopeptides_matching/develop/oligopeptides_matching/data.R")


ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = "Oligopeptides Matching", titleWidth = 250),
  dashboardSidebar(
    width = 250,
    tags$style(HTML(".share-buttons { text-align: center; margin-top: 20px; }" )),
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Amino Acid and Mass", tabName = "AminoAcidandMass"),
      menuItem("Amino-acid assemblies", tabName = "assemblies"),
      menuItem("Combination AA Polyphenol", tabName = "CombinationAApolyphenol"),
      menuItem("Match a single mz", tabName = "Matchasinglemz"),
      menuItem("Match a list of mz", tabName = "Matchalistofmz"),
      menuItem("About", tabName = "about", icon = icon("question")),
      menuItem("Feedback", tabName = "feedback", icon = icon("envelope")),
      menuItem(
        tabName = NULL,
        div(
          style ="display: flex; justify-content: space-between; padding: 10px;",
          tags$img(src = "bia_logo.png", height = "45px", alt = "Logo 1"),
          tags$img(src = "igepp.jpg", height = "45px", alt = "Logo 2")
        )
      ),
      menuItem(
        tabName = NULL,
        div(
          style ="text-align: center; padding-top: 5px;",
          tags$img(src = "logoP2M2.png", height = "50px", alt = "Logo 3") 
        )
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              tagList(
                includeMarkdown("welcome.md")
              )
      ),
      tabItem(tabName = "AminoAcidandMass",
              fluidPage(
                mainPanel(
                  h3("Amino Acid and Mass"),
                  h5("This menu represents a table of the amino acids and their mass"),
                  includeMarkdown("amino_acid.md")
                )
              )
      ),
      tabItem(tabName = "assemblies",
              fluidPage(
                sidebarLayout(
                  sidebarPanel(
                    numericInput("od_1", "Oligomerization degree:", value = 1, min = 1),
                    actionButton("calculate", "Calculate", style = "color: white; background-color: #007bff; border-color: #007bff;")
                  ),
                  mainPanel(
                    h3("Amino-acid assemblies"),
                    h5("This menu represents the calculation process from one to amino-acid assemblies"),
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
                    h5("This menu represents the matching process of a single m/z; You can choose your own m/z value to find the match"),
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
                    h5("This menu represents the matching process of a list of m/z. Please Select the file, then the coloums of Rt, mz and feature name"),
                    conditionalPanel(
                      condition = "input.update > 0",
                      withSpinner(DT::dataTableOutput("view_match"))
                    )
                  ),
                  position = "right"
                )
              )
      ),
      tabItem(tabName = "about",
              fluidPage(
                includeMarkdown("about.md")
              )
      ),
      tabItem(tabName = "feedback",
              fluidPage(
                includeMarkdown("feedback_user.md"),
                h2("Feedback:"),
                selectInput("category", "Category:",
                            choices = c("Bug", "General Feedback", "Idea")
                ),
                textAreaInput("description", "Description:", "", rows = 6, width = "80%"),
                textAreaInput("suggestions", "Suggestions:", "", rows = 10, width = "80%"),
                actionButton("submit_feedback", "Submit", style = "color: white; background-color: #007bff; border-color: #007bff;")
              )
      )
    )
  )
)
