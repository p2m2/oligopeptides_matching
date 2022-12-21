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
#aa1 <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")

### reaction elements
#H2O <- 18.010565
#H <- 1.007825

### amino acids molecular weight
#mass_aa1 <- c(89.047679, 121.019751, 133.037509, 147.053159, 165.078979, 
#              75.032029, 155.069477, 131.094629, 146.105528, 131.094629,
#              149.051051,132.053493, 115.063329, 146.069143, 174.111676,
#              105.042594,119.058244, 117.078979,204.089878, 181.073894)
#aa1_mw <- setNames(mass_aa1, aa1)


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


# res_dipeptide <- build_mz_peptides(dipeptide, 2, setNames(c(H),c("H")))
# res_tripeptide <- build_mz_peptides(tripeptide, 3, setNames(c(H),c("H")))
# res_peptide <- merge(res_dipeptide, res_tripeptide, all.x=T, all.y=T)



#test <- get_oligopeptides(aminoacids = aa1_mw,
#                          chemical_reaction = H2O,
#                          ionization = setNames(c(H),c("H")),
#                          oligomerization_degree = 4)
