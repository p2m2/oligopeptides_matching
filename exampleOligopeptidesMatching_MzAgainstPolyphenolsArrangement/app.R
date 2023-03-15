library(shiny)
library(DT)

# Constants
### Amino acids
aa <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")

### amino acids molecular weight
mass_aa <- c(89.047679, 121.019751, 133.037509, 147.053159, 165.078979, 
              75.032029, 155.069477, 131.094629, 146.105528, 131.094629,
              149.051051,132.053493, 115.063329, 146.069143, 174.111676,
              105.042594,119.058244, 117.078979,204.089878, 181.073894)

aa_mw <- setNames(mass_aa, aa)

### Polyphenols
polyphenol <- c("Cyanidin",
                "Cyanidin 3,5-O-diglucoside",
                "Cyanidin 3-O-(6''-acetyl-galactoside)",
                "Cyanidin 3-O-(6''-acetyl-glucoside)",
                "Cyanidin 3-O-(6''-caffeoyl-glucoside)")

### polyphenol molecular weight
mass_polyphenol <- c(287.244, 611.525,491.422, 491.422, 611.527)

pp_mw <- setNames(mass_polyphenol, polyphenol)

### reaction elements
H2O <- 18.010565
H <- 1.007825

ionization_list = stats::setNames(c(H),c("H"))


# See above for the definitions of ui and server
ui <- fluidPage(

  # App title ----
  titlePanel("Oligopeptides Matching"),

  # Sidebar layout with a input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(
        
    # Input: Numeric entry for number of obs to view ----
    numericInput(inputId = "od",
                   label = "Oligomerization degree:",
                   value = 3),
    numericInput(inputId = "mz_obs",
                   label = "M/z observed :",
                   value = 953.669),
    numericInput(inputId = "ppm_error",
                   label = "Tolerance:",
                   value = 10)
    ),
    # Main panel for displaying outputs ----
    mainPanel(
        h3("Oligopeptides"),
        # Output: HTML table with requested number of observations ----
        DT::dataTableOutput("view")
    )
  )
)

server <- function(input, output) {


  
  output$view <- DT::renderDataTable(
    {aa_combined <- get_oligopeptides(
      aminoacids = aa_mw,
      chemical_reaction = H2O,
      ionization = ionization_list,
      oligomerization_degree = input$od)
    
    aa_combined_names <- c(aa_combined$id)
    aa_combined_mass <- c(aa_combined$MW)
    aa_combined_mw <- setNames(aa_combined_mass, aa_combined_names)

    combined_compounds <- get_combination_compounds(
                              compounds_1 = aa_combined_mw,
                              compounds_2 = pp_mw,
                              chemical_reaction = H2O,
                              ionization = setNames(c(H), c("H")))
    mz_obs <- 953.669
    combined_compounds_near_obs <-
      match_mz_obs(input$mz_obs, combined_compounds,
        ppm_error = input$ppm_error)

    return(combined_compounds_near_obs)
    }
    
  )

}

shinyApp(ui = ui, server = server)