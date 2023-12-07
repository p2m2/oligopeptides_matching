#' get_combination_compounds
#'
#' compounds_1, compounds_2 = R column with a name (Named num)
#' @param oligopeptides amino acids assemblage
#' @param polyphenols polyphenols from user's list
#' @param chemical_derivation derivatives based on polyphenols' list
#' @param addition_reaction chemical reaction between oligopeptides and polyphenols
#' @return matrix containing conjugate, Id , MW.
#' @export

get_combination_compounds <- function(oligopeptides,
                                      polyphenols,
                                      chemical_derivation,
                                      addition_reaction) {
  m <- length(polyphenols)
  n <- nrow(oligopeptides)
  o <- length(chemical_derivation) 
  
  combined_compounds_names <- vector("character", m * n * o)
  combined_compounds_mass <- vector("numeric", m * n * o)
  
  l <- 1
  
  for (i in 1:n) {
    for (j in 1:m) {
      combined_compounds_names[l] <- paste(oligopeptides[i,2], names(polyphenols)[j], sep = "_") 
      combined_compounds_mass[l] <- oligopeptides[i,3] + polyphenols[j] - addition_reaction
      l <- l + 1
      for (k in 1:o) {
        buf <- paste(oligopeptides[i,2], names(polyphenols)[j], sep = "_")
        combined_compounds_names[l] <- paste(buf, names(chemical_derivation)[k], sep = "_") 
        combined_compounds_mass[l] <- oligopeptides[i,3] + polyphenols[j] - addition_reaction + chemical_derivation[k]
        }
    }
  }
  
  combined_compounds <- (stats::setNames(combined_compounds_mass, combined_compounds_names))
  combined_compounds <- combined_compounds[unique(names(combined_compounds))]
  
  df <- as.data.frame(combined_compounds)
  colnames(df) <- c("mass")
  df <- dplyr::arrange(df, mass)
  return(df)
  }
