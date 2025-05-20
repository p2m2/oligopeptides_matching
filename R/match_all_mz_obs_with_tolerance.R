#' Match an observed m/z against compounds using adaptive ppm tolerance (return all matches)
#'
#' This function searches for compounds that match a given observed m/z value (`mz_obs`)
#' within an adaptively increasing ppm error window. It increments the ppm step-by-step 
#' until at least one match is found, then returns all matches found at that ppm level.
#'
#' @param mz_obs Numeric. The observed m/z value.
#' @param mode Character. Ionization mode, either `"pos"` or `"neg"`.
#' @param compounds Named numeric vector. Compound names as names and their theoretical m/z values.
#' @param initial_ppm Numeric. The starting ppm tolerance (default: 0).
#' @param max_ppm Numeric. The maximum ppm tolerance to search up to (default: 500).
#' @param step Numeric. The increment in ppm at each iteration (default: 2).
#'
#' @return A `data.frame` with all matched compounds found at the first ppm level
#'         that yields results. Includes columns for the observed m/z, matched mass,
#'         the ppm error used, and the calculated ppm error value.
#'         If no match is found, returns a row with `NA` values.
#'
#' @export
#'
#' @examples
#' match_all_mz_obs_with_tolerance(
#'   mz_obs = 300.1234,
#'   mode = "pos",
#'   compounds = c(comp1 = 300.1245, comp2 = 305.1234)
#' )
match_all_mz_obs_with_tolerance <- function(mz_obs, mode = "pos", compounds, 
                                            initial_ppm = 0, max_ppm = 500, step = 2) {
  # Parameter checks
  stopifnot(is.numeric(mz_obs), length(mz_obs) == 1, !is.na(mz_obs))
  stopifnot(is.character(mode), mode %in% c("pos", "neg"))
  stopifnot(!is.null(names(compounds)))
  stopifnot(is.numeric(initial_ppm), is.numeric(max_ppm), is.numeric(step))
  
  ppm <- initial_ppm
  
  while (ppm <= max_ppm) {
    result <- match_mz_obs(mz_obs, mode, compounds, ppm_error = ppm)
    
    if (!is.null(result) && nrow(result) > 0) {
      result$ppm_used <- ppm
      result$mz_obs <- mz_obs
      return(result)
    }
    
    ppm <- ppm + step
  }
  
  # No match found
  warning(sprintf("No match found for mz_obs = %.4f up to %.1f ppm.", mz_obs, max_ppm))
  return(data.frame(mz_obs = mz_obs, mass = NA, ppm_error_value = NA, ppm_used = NA))
}
