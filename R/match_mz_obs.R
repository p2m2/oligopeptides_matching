#' Match an observed mz against the combined compounds Robject using a δppm
#'
#' @description Match an observed mz against the combined compounds Robject 
#' using a δppm
#' @param mz_obs is the observed mz of the metabolomic study
#' @param combined_compounds is the combined compounds array to match
#' @param ppm_error is the criteria to match compounds
#' @return the list as dataframe of all the matches
#' @export

match_mz_obs <- function(mz_obs,
                         combined_compounds,
                         ppm_error=5) {
  return(combined_compounds %>%
           filter(combined_compounds < round(mz_obs, digits = 0) + 1) %>%
           filter(combined_compounds >= round(mz_obs, digits = 0)) %>%
           mutate(round = round(combined_compounds, digits = 4)) %>%
           mutate(ppm_error_value = d_ppm(round, mz_obs)) %>%
           filter(ppm_error_value<ppm_error))
}
