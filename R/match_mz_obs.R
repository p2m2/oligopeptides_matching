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
#' @importFrom rlang abort
#' @export
#' @examples
#'

match_mz_obs <- function(mz_obs,
                         ionization,
                         combined_compounds,
                         ppm_error=5) {
  ppm_error_value <- 0
  H <- 1.007825
  theoric_mass_obs <- switch(
    ionization,
    "pos" = mz_obs-H,
    "neg" = mz_obs+H ,
    "already_charged" = mz_obs,
    rlang::abort(paste("'",ionization,"'",
                       " ionization isnt supported. possible value : 'pos', 'neg', 'already_charged'", sep = ""))
    )
  

  return(combined_compounds %>%
           dplyr::filter(mass_theo < theoric_mass_obs + 0.5) %>%
           dplyr::filter(mass_theo >= theoric_mass_obs - 0.5) %>%
           dplyr::mutate(ppm_error_value = d_ppm(mass_theo, theoric_mass_obs)) %>%
           dplyr::filter(ppm_error_value<ppm_error) %>%
           dplyr::mutate(mz_obs, .before=ppm_error_value) %>%
           dplyr::mutate(mass_theo = round(mass_theo, digits=5)) %>%
           dplyr::mutate(mz_theo = dplyr::case_when(
             ionization == "pos" ~ mass_theo + H,
             ionization == "neg" ~ mass_theo - H,
             TRUE ~ mass_theo)) %>%
           dplyr::select(mz_obs, mz_theo, ppm_error_value)
         )
}


