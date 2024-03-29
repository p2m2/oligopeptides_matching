#' Builds an informative and complete matrix of Oligopeptides
#' mapping to Mass Spectrometry output
#'
#' Builds a matrix containing : 
#'  - Oligomerization Degree
#'  - Id (Combinaison of Amino Acid names)
#'  - MW (molecular weight)
#'  - ...
#'
#' @param aminoacids list of amino acids.
#' @param oligomerization_degree integer : oligomerization degree
#' @return matrix containing OD, Id , MW .
#' @export
#' @examples
#' get_oligopeptides(aminoacids = stats::setNames(c(89.047679),c("A")),
#' oligomerization_degree = 4)
get_oligopeptides <- function(aminoacids,oligomerization_degree){
  H2O <- 18.010565
  tmp_oligopeptides <- aminoacids
  all_peptides <-  build_peptides(aminoacids, 1)
  for (i in 1:(oligomerization_degree-1)){
    tmp_oligopeptides <- oligopeptides_building(tmp_oligopeptides, aminoacids,
    H2O)
    tmp_peptides <- build_peptides(tmp_oligopeptides, i+1)
    all_peptides <- rbind(all_peptides, tmp_peptides)
  }
  return(all_peptides)
}
