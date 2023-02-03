#' Calculate δppm
#'
#' @description Calculate the δppm between an observed mz and a theorical one
#' @param mz_obs is the observed mz of the metabolomic study
#' @param mz_theoric is the theorical mz (calculated by get_arrangement_oligopeptides and or get_combination_compounds)
#' @return the δppm of the difference between the mz observed and a theorical one
#' @export
#' @examples for the glucose in negative ionization mode: d_ppm(179.0564, 179.0561)
d_ppm <- function(mz_obs, mz_theoric){
  ppm_error <- (mz_obs - mz_theoric) / mz_theoric * 10^6
  return(ppm_error)
}