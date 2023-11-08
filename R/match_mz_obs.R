#' Match an observed mz against the combined compounds Robject using a δppm
#'
#' @description Match an observed mz against the combined 
#' compounds Robject using a δppm
#' @param mz_obs is the observed mz of the metabolomic study
#' @param ionization : list of ionization
#' @param combined_compounds is the combined compounds array to match
#' @param ppm_error is the criteria to match compounds
#' @return the list as dataframe of all the matches
#' @importFrom dplyr %>%
#' @importFrom dplyr mutate
#' @importFrom dplyr filter
#' @export
match_mz_obs <- function(mz_obs,
                         ionization,
                         combined_compounds,
                         ppm_error=5) {
  H<-1.007825
  if(ionization=="pos")
  return(combined_compounds %>%
           dplyr::filter(combined_compounds < mz_obs-H + 0.5) %>%
           dplyr::filter(combined_compounds >= mz_obs-H - 0.5) %>%
           dplyr::mutate(round = round(combined_compounds, digits=4)) %>%
           dplyr::mutate(ppm_error_value = d_ppm(round, mz_obs-H)) %>%
           dplyr::filter(ppm_error_value<ppm_error))
  else if(ionization=="neg")
    return(combined_compounds %>%
             dplyr::filter(combined_compounds < mz_obs+H + 0.5) %>%
             dplyr::filter(combined_compounds >= mz_obs+H - 0.5) %>%
             dplyr::mutate(round = round(combined_compounds, digits=4)) %>%
             dplyr::mutate(ppm_error_value = d_ppm(round, mz_obs+H)) %>%
             dplyr::filter(ppm_error_value<ppm_error))
  else if(ionization=="already_charged")
    return(combined_compounds %>%
             dplyr::filter(combined_compounds < mz_obs + 0.5) %>%
             dplyr::filter(combined_compounds >= mz_obs - 0.5) %>%
             dplyr::mutate(round = round(combined_compounds, digits=4)) %>%
             dplyr::mutate(ppm_error_value = d_ppm(round, mz_obs)) %>%
             dplyr::filter(ppm_error_value<ppm_error))
  else(return("error_ionization"))
}
