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

for (i in 1:n){
  for (j in 1:m){
    combined_compounds_names[k]=paste(names(compounds_1)[i], names(compounds_2)[j], sep="_")
    combined_compounds_mass[k]=compounds_1[i]+compounds_2[j]-chemical_reaction
    k <- k+1
  }
}

combined_compounds <- (stats::setNames(combined_compounds_mass,combined_compounds_names))
combined_compounds <- combined_compounds[unique(names(combined_compounds))]

return(as.data.frame(combined_compounds))
}

