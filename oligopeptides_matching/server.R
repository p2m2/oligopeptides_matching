library(shiny)
library(DT)
library(oligopeptidesMatching)

source("./data.R")

server <- function(input, output) {

  combination_compounds <- reactive({
        aaa_combined <- get_oligopeptides(
      aminoacids = aa_mw,
      oligomerization_degree = input$od)

    aa_combined <- as.data.frame(aaa_combined)
    aa_combined_names <- c(aa_combined$id)
    aa_combined_mass <- c(aa_combined$MW)
    aa_combined_mw <- setNames(aa_combined_mass, aa_combined_names)

    return(get_combination_compounds(oligopeptides, 
                                     polyphenols, 
                                     chemical_derivation,
                                     addition_reaction
                                     ))
  })
  # =====
  # All arrangement AA with PolyPhenols
  output$view_arrangement <- DT::renderDataTable(
    combination_compounds()
  )
  # =====
  # Filtering on a single Value

  output$view_filter_mz_obs <- DT::renderDataTable(
     {
      return(match_mz_obs(
        input$mz_obs,
        'already_charged',
        combination_compounds(),
        ppm_error = input$ppm_error))
    }
  )
}