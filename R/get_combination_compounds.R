# compounds_1, compounds_2 = R column with a name (Named num)
get_combination_compounds <- function(compounds_1,
                                      compounds_2,
                                      chemical_reaction,
                                      ionization){

n = length(compounds_1)
m = length(compounds_2)

combined_compounds_names <- vector("character", m*n)
combined_compounds_mass <- vector("numeric", m*n)

k = 1

for (i in 1:m*n){
    # nameOligo <- names(mass_oligo_vector_np1)[i]
    # l <- stringr::str_sort(append(unlist(stringr::str_split(nameOligo, "_")),names(mass_aa_vector)[j]))
    
    combined_compounds_names[k]=paste(names(compounds_1), names(compounds_2), collapse="_")
    combined_compounds_mass[k]=compounds_1[k]+compounds_2[k]-chemical_reaction
     k <- k+1
  }

combined_compounds <- (stats::setNames(combined_compounds_mass,combined_compounds_names))
combined_compounds <- combined_compounds[unique(names(combined_compounds))]
return(combined_compounds)
}
