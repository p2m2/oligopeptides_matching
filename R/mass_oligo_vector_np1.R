#' Builds an N-size amino acid oligopeptide
#'
#' Builds an N-size amino acid oligopeptide list from the combination between 
#' an N-size oligopeptide and an amino acid list
#' 
#' All vectors are named with a combination of amino acids. 
#' the values ​​correspond to the theoretical mass.
#' 
#' Formula : oligo^n = aa^n - H2O^n-1 
#' 
#' @param mass_oligo_vector_np1 list of oligopeptide.
#' @param mass_aa_vector list of amino acids.
#' @param additional_reaction additional reaction linking the combination of oligopepid and amino acids.
#' @return new oligo_vector with mass values .
#' @export
#' @examples 
#' oligopeptides_building(setNames(c(160,085358),c("A-A")),setNames(c(89.047679),c("A")),H2O)
oligopeptides_building <- function(mass_oligo_vector_np1,
                                   mass_aa_vector,
                                   additional_reaction){
  n = length(mass_aa_vector)
  m = length(mass_oligo_vector_np1)
  
  oligo_names <- vector("character", n*m)
  oligo_mass <- vector("numeric", n*m)
  
  k = 1
  
  for (i in 1:m){
    for (j in 1:n){
      nameOligo <- names(mass_oligo_vector_np1)[i]
      l <- str_sort(append(unlist(str_split(nameOligo, "_")),names(mass_aa_vector)[j]))

      oligo_names[k]=paste(l, collapse="_")
      oligo_mass[k]=mass_oligo_vector_np1[i]+mass_aa_vector[j]-additional_reaction
      k <- k+1
      }
  }
  
    oligo_mass <- (setNames(oligo_mass,oligo_names))
    oligo_mass <- oligo_mass[unique(names(oligo_mass))]
    return(oligo_mass)
}