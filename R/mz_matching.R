#' Calculate δppm for all the compounds
#'
#' @description Calculate the δppm between an observed mz and a theorical one
#' @param mz_obs is the observed mz of the metabolomic study
#' @param mz_theoric is the theorical mz (calculated by get_arrangement_oligopeptides and or get_combination_compounds)
#' @return the δppm of the difference between the mz observed and a theorical one
#' @export
#' @examples 

mz_obs <- c(403.1235, 358.2813)

mz_theoric <- as.vector(combined_compounds$combined_compounds)
# mz_theoric <- head(mz_theoric)
mz_obs <- as.vector(mz_obs)

mz_matching <- matrix(nrow=length(mz_obs), ncol=length(mz_theoric))
rownames(mz_matching) <- mz_obs
colnames(mz_matching) <- mz_theoric

# initiate the loop
a=1
b=1

# set the tolerance in ppm
tolerance = 5

# loop
for (i in 1:length(mz_theoric)){
  for (j in 1:length(mz_obs)){
    mz_matching= d_ppm(mz_obs = mz_obs[j],
                       mz_theoric = mz_theoric[i])
    mz_matching[b,a]=mz_matching
    b=b+1
  }
  a=a+1
  b=1
}