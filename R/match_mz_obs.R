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
#' aa1 <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L",
#' "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")
#'
#' mass_aa1 <- c(89.047679, 121.019751, 133.037509, 147.053159, 165.078979,
#'              75.032029, 155.069477, 131.094629, 146.105528, 131.094629,
#'              149.051051,132.053493, 115.063329, 146.069143, 174.111676,
#'              105.042594,119.058244, 117.078979,204.089878, 181.073894)
#'
#' aa1_mw <- setNames(mass_aa1, aa1)
#'
#' oligopeptides <- get_oligopeptides(aminoacids = aa1_mw,oligomerization_degree = 4)
#' polyphenol <- c("Cyanidin","Cyanidin 3,5-O-diglucoside","Cyanidin 3-O-(6''-acetyl-galactoside)",
#'                "Cyanidin 3-O-(6''-acetyl-glucoside)",
#'                "Cyanidin 3-O-(6''-caffeoyl-glucoside)")
#' mass_polyphenol <- c(287.244, 611.525,491.422, 491.422, 611.527)
#' pp_mw <- setNames(mass_polyphenol, polyphenol)
#' aa <- c(oligopeptides$id)
#' aa_mass <- c(oligopeptides$MW)
#' aa_mw <- setNames(aa_mass, aa)
#'
#' H2O <- 18.010565
#' combined_compounds <- get_combination_compounds(compounds_1 = aa_mw,
#'                          compounds_2 = pp_mw,
#'                          chemical_reaction = H2O)
#' mz_obs <- 358.2811
#' match_mz_obs(mz_obs,"already_charged",combined_compounds)
match_mz_obs <- function(mz_obs,
                         ionization,
                         combined_compounds,
                         ppm_error=5) {
  ppm_error_value <- 0
  H <- 1.007825
  mz <- switch(
    ionization,
    "pos" = mz_obs-H,
    "neg" = mz_obs+H ,
    "already_charged" = mz_obs,
    rlang::abort(paste("'",ionization,"'"," ionization isnt supported. possible value : 'pos', 'neg', 'already_charged'", sep = ""))
    )

  return(combined_compounds %>%
           dplyr::filter(mass < mz + 0.5) %>%
           dplyr::filter(mass >= mz - 0.5) %>%
           dplyr::mutate(ppm_error_value = d_ppm(mass, mz)) %>%
           dplyr::filter(ppm_error_value<ppm_error) %>%
           dplyr::mutate(mz_obs, .before=ppm_error_value) %>%
           dplyr::mutate(mass = round(mass, digits=5)) %>%
           dplyr::select(mz_obs, mass, ppm_error_value)
         )
}


