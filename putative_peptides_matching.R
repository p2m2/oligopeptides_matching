# load/install needed packages
packages=c("stringr", "gdata", "dplyr", "purrr")
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)

# Constants
### aminoacids list
aa1 <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")

### reaction elements
H2O <- 18.010565
H <- 1.007825

### amino acids molecular weight
mass_aa1 <- c(89.047679, 121.019751, 133.037509, 147.053159, 165.078979, 
              75.032029, 155.069477, 131.094629, 146.105528, 131.094629,
              149.051051,132.053493, 115.063329, 146.069143, 174.111676,
              105.042594,119.058244, 117.078979,204.089878, 181.073894)
aa1_mw <- setNames(mass_aa1, aa1)

# oligopeptides
## idea formula : oligo^n = aa^n - H2O^n-1 
## return new oligo_vector with mz values
## additional reaction take into account H2O loss and might be implemented

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
     # print(typeof(str_split(nameOligo, "_")))
    #  print(append(unlist(str_split(nameOligo, "_")),names(mass_aa_vector)[j]))
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

# test case
# testit::assert("Variable vectors with different length should return NULL",
#                oligopeptides_building(c("a"),c()) != c())
# 
# 
# testit::assert("Empty colonne should give an empty vector" , {
#   oligopeptides_building(c(),c()) == c()
# })
# 
# oligopeptides_building(c("a", "c"),c("b", "d"))

# 
# dipeptide <- oligopeptides_building(aa1_mw, aa1_mw, H2O)
# tripeptide <- oligopeptides_building(dipeptide, aa1_mw, H2O)
# tetrapeptide <- oligopeptides_building(tripeptide, aa1_mw, H2O)
# pentapeptide <- oligopeptides_building(tetrapeptide, aa1_mw, H2O)

# output matrix
# all_peptides <- matrix(data=NA, nrow=length(tripeptide), ncol=3)
# for (i in 1:length(tripeptide)){
#   all_peptides[i,1] <- 3
#   all_peptides[i,2] <- names(tripeptide)[i]
#   all_peptides[i,3] <- tripeptide[i]
# }


# 
build_mz_peptides <- function(peptide,
                              oligomerization_degree,
                              ionization){
  peptide_matrix <- matrix(data=NA, nrow=length(peptide), ncol=3+2*length(ionization))
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

# res_dipeptide <- build_mz_peptides(dipeptide, 2, setNames(c(H),c("H")))
# res_tripeptide <- build_mz_peptides(tripeptide, 3, setNames(c(H),c("H")))
# res_peptide <- merge(res_dipeptide, res_tripeptide, all.x=T, all.y=T)


get_oligopeptides <- function(aminoacids,
                              chemical_reaction,
                              ionization,
                              oligomerization_degree){
  tmp_oligopeptides <- aminoacids
  # all_mz_peptides <- matrix(nrow=0, ncol=3+(2*length(ionization)))
  all_mz_peptides <-  build_mz_peptides(aminoacids, 1, ionization)
  for (i in 1:(oligomerization_degree-1)){
    tmp_oligopeptides <- oligopeptides_building(tmp_oligopeptides, aminoacids, chemical_reaction)
    tmp_mz_peptides <- build_mz_peptides(tmp_oligopeptides, i+1, ionization)
    # print(tmp_mz_peptides)
    # print(ncol(all_mz_peptides))
    # list_oligopeptides <- append(list_oligopeptides, tmp_oligopeptides)
    all_mz_peptides <- rbind(all_mz_peptides, tmp_mz_peptides)
  }
  return(all_mz_peptides)
}

test <- get_oligopeptides(aminoacids = aa1_mw,
                          chemical_reaction = H2O,
                          ionization = setNames(c(H),c("H")),
                          oligomerization_degree = 4)
