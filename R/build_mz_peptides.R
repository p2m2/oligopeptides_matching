#' Builds an informative matrix of Oligopeptides mapping to
#' Mass Spectrometry output
#'
#' Builds a matrix containing : 
#'  - Oligomerization Degree
#'  - Id (Combinaison of Amino Acid names)
#'  - Mz (ionized mass)
#' @param peptide list of oligopeptide, Named num (column with names)
#' @param oligomerization_degree integer : oligomerization degree  
#' @param ionization : list of ionization
#' @return a data.frame containing OD, Id , Mz ,
#' M + Xionization, M - Xionization
#' @export
#' @examples
#' build_mz_peptides(
#' stats::setNames(c(160.0848,192.0569),c("A_A","A_C")), 2)
build_mz_peptides <- function(peptide,
                              oligomerization_degree){
  peptide_matrix <- as.data.frame(matrix(data=NA, nrow=length(peptide), ncol=3))
  header <- c("OD", "id", "MW")
  colnames(peptide_matrix) <- header
    for (i in 1:length(peptide)){
    peptide_matrix[i,1] <- oligomerization_degree
    peptide_matrix[i,2] <- names(peptide)[i]
    peptide_matrix[i,3] <- peptide[i]
    }
  return(peptide_matrix)
}
