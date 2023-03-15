#' Builds an informative and complete matrix of Oligopeptides mapping to Mass Spectrometry output
#' 
#' Builds a matrix containing : 
#'  - Oligomerization Degree
#'  - Id (Combinaison of Amino Acid names)
#'  - Mz (ionized mass)
#'  - [M - X ionization[1]] negative mode ionization
#'  - [M + X ionization[1]] positive mode ionization 
#'  - [M - X ionization[2]] negative mode ionization
#'  - [M + X ionization[2]] positive mode ionization 
#'  - ...
#' 
#' 
#' @param aminoacids list of amino acids.
#' @param chemical_reaction reaction linking the combination of 
#' oligopepid and amino acids.
#' @param ionization list of ionization
#' @param oligomerization_degree integer : oligomerization degree  
#' @return matrix containing OD, Id , Mz , ([M - Xionization ], 
#' [M + Xionization])+ .
#' @export
#' @examples 
#' get_oligopeptides(aminoacids = stats::setNames(c(89.047679),c("A")),
#' chemical_reaction = 18.010565,ionization = stats::setNames(c(1.007825),
#' c("H")),oligomerization_degree = 4)
get_oligopeptides <- function(aminoacids,
                              chemical_reaction,
                              ionization,
                              oligomerization_degree){
  tmp_oligopeptides <- aminoacids
  all_mz_peptides <-  build_mz_peptides(aminoacids, 1, ionization)
  for (i in 1:(oligomerization_degree-1)){
    tmp_oligopeptides <- oligopeptides_building(tmp_oligopeptides, aminoacids, chemical_reaction)
    tmp_mz_peptides <- build_mz_peptides(tmp_oligopeptides, i+1, ionization)
    all_mz_peptides <- rbind(all_mz_peptides, tmp_mz_peptides)
  }
  return(all_mz_peptides)
}