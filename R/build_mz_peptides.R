#' Builds an informative matrix of Oligopeptides mapping to Mass Spectrometry output
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
#' @param peptide list of oligopeptide.
#' @param oligomerization_degree integer : oligomerization degree  
#' @param ionization : list of ionization
#' @return a data.frame containing OD, Id , Mz , ([M - Xionization ], [M + Xionization])+ .
#' @export
#' @examples 
#' build_mz_peptides(stats::setNames(c(160.0848,192.0569),c("A_A","A_C")), 2, stats::setNames(c(1.007825),c("H")))
build_mz_peptides <- function(peptide,
                              oligomerization_degree,
                              ionization){
  peptide_matrix <- as.data.frame(matrix(data=NA, nrow=length(peptide), ncol=3+2*length(ionization)))
  header <- c("OD", "id", "MW")
  for (i in seq(from=1, to=length(ionization), by=2)){
    header = append(header, paste("[M-", names(ionization)[i],"]", sep=""))
    header = append(header, paste("[M+", names(ionization)[i],"]", sep=""))                
  }
  colnames(peptide_matrix) <- header
    for (i in 1:length(peptide)){
    peptide_matrix[i,1] <- oligomerization_degree
    peptide_matrix[i,2] <- names(peptide)[i]
    peptide_matrix[i,3] <- peptide[i]
    for (j in seq(from=1, to=length(ionization), by=2)){
      peptide_matrix[i,3+j] <- peptide[i]-ionization[j]
      peptide_matrix[i,3+(j+1)] <- peptide[i]+ionization[j]
    }
    }
  return(peptide_matrix)
}
