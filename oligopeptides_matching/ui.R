ui <- navbarPage("Oligopeptides Matching",
  tabPanel("Combination AA Polyphenol",

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
        h3("Oligopeptides"),
        # Output: HTML table with requested number of observations ----
        DT::dataTableOutput("view_arrangement")
    )
  )
),
tabPanel("Match a single Mz",
# Sidebar layout with a input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(
    numericInput(inputId = "mz_obs",
                   label = "M/z observed :",
                   value = 953.669),
    selectInput("ionization", "Ionization:",
                c("Already charged" = "already_charged",
                  "Positive" = "pos",
                  "Negative" = "neg")),
    numericInput(inputId = "ppm_error",
                   label = "Tolerance:",
                   value = 10)

    ),
    # Main panel for displaying outputs ----
    mainPanel(
        h3("Oligopeptides"),
        # Output: HTML table with requested number of observations ----
        DT::dataTableOutput("view_filter_mz_obs")
    )
  )
),
tabPanel("Match a list of Mz")
)