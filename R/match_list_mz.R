# définir la fonction avec ses paramètres
# Boucle sur la liste mz_obs
# appel à la fonction match_mz_obs 
# rbind : pour ajouter les résultats 
# Sélection des colonnes

match_list_mz_obs <- function(list_mz_obs, ionization, combined_compounds, ppm_error=5) {
  results <- list()  # Initialize an empty list to store results
  
  for (i in 1:nrow(list_mz_obs)) {
    features_name <- list_mz_obs[i, "features_name"]
    mz <- list_mz_obs[i, "mz"]
    rt <- list_mz_obs[i, "rt"]
    
    match_mass <- match_mz_obs(mz, ionization, combined_compounds, ppm_error)
    
    if (nrow(match_mass) > 0) {
      match_mass <- cbind(features_name = features_name, rt = rt, match_mass)
    } else {
      match_mass <- data.frame(features_name = features_name, rt = rt, mz_obs = mz, mass = NA, ppm_error_value = NA)
    }
    
    results[[i]] <- match_mass
  }
  
  results <- dplyr::bind_rows(results)
  results <- dplyr::select(results, features_name, rt, mz_obs, mass, ppm_error_value)
  return(results)
}


example_list_mz_obs <- data.frame(
      name = c("M954t1417", "M100T50", "M121T93"),
      mz = c(953.6798, 100.07, 120.9659),
      rt = c(10.5, 20.6, 30.7)
   )
match_list_mz_obs(example_list_mz_obs$mz, 'already_charged', combined_compounds, ppm_error = 10)
