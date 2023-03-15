#' Calculate δppm
#'
#' @description Calculate the δppm between an observed mz and a theorical one
#' @param mz_obs is the observed mz of the metabolomic study
#' @param mz_theoric Theorical mz (calculated by get_arrangement_oligopeptides 
#' and or get_combination_compounds)
#' @return δppm : difference between the mz observed and a theorical one
#' @export
#' @examples d_ppm(179.0564, 179.0561)
d_ppm <- function(mz_obs, mz_theoric) {
  if(mz_theoric == 0) {
    return(0)
  }
  ppm_error <- abs(((mz_obs - mz_theoric) / mz_theoric) * 10^6)
  return(ppm_error)
}
