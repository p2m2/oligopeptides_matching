#' Match observed m/z with a list of compounds using adaptive ppm tolerance
#'
#' This function matches an observed m/z value (`mz_obs`) against a list of theoretical compound masses
#' using an adaptive ppm error tolerance, increasing progressively until a match is found.
#' If multiple matches are found at a given ppm level, the one with the lowest absolute ppm error is returned.
#'
#' @param mz_obs Numeric. Observed m/z value.
#' @param mode Character. Ionization mode ("pos" or "neg").
#' @param compounds Named numeric vector of compound masses.
#' @param initial_ppm Numeric. Starting ppm tolerance (default: 0).
#' @param max_ppm Numeric. Maximum ppm tolerance to consider (default: 500).
#' @param step Numeric. Step size to increase the ppm tolerance (default: 2).
#'
#' @return A data.frame with the best match (compound name and mass), the observed m/z,
#'         the ppm error, and the ppm tolerance used. If no match is found, returns NA values.
#' @export
#'
#' @examples
#' match_near_mz_obs_with_tolerance(300.1234, "pos", compounds = c(comp1 = 300.1245))
match_near_mz_obs_with_tolerance <- function(mz_obs, mode = "pos", compounds,
                                             initial_ppm = 0, max_ppm = 500, step = 2) {
  # Checks
  stopifnot(is.numeric(mz_obs), length(mz_obs) == 1, !is.na(mz_obs))
  stopifnot(is.character(mode), mode %in% c("pos", "neg"))
  stopifnot(!is.null(names(compounds)))
  stopifnot(is.numeric(initial_ppm), is.numeric(max_ppm), is.numeric(step))
  
  ppm <- initial_ppm
  
  while (ppm <= max_ppm) {
    matches <- match_mz_obs(mz_obs, mode, compounds, ppm_error = ppm)
    
    if (!is.null(matches) && nrow(matches) > 0) {
      # Add ppm error if not present
      if (!"ppm_error_value" %in% colnames(matches)) {
        matches$ppm_error_value <- abs((matches$mass - mz_obs) / mz_obs * 1e6)
      }
      
      best_match <- matches %>%
        dplyr::slice_min(ppm_error_value, with_ties = FALSE)
      
      best_match$ppm_used <- ppm
      best_match$mz_obs <- mz_obs
      return(best_match)
    }
    
    ppm <- ppm + step
  }
  
  # Aucun match trouvé
  warning(sprintf("Aucun match trouvé pour mz_obs = %.4f jusqu’à %.1f ppm.", mz_obs, max_ppm))
  return(data.frame(mz_obs = mz_obs, mass = NA, ppm_error_value = NA, ppm_used = NA))
}
