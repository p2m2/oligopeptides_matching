# définir la fonction avec ses paramètres
# Boucle sur la liste mz_obs
# appel à la fonction match_mz_obs 
# rbind : pour ajouter les résultats 
# Sélection des colonnes

match_list_mz_obs <- function(list_mz_obs,  # contient les mz, name, rt
                              ionization,
                              combined_compounds,
                              ppm_error=5) {
  results <- list()
  
  for (i in 1:nrow(list_mz_obs)) {
    name <- list_mz_obs[i, "features_name"]
    mz <- list_mz_obs[i, "mz"]
    rt <- list_mz_obs[i, "rt"]
    
    match_mass <- match_mz_obs(mz_obs, ionization, combined_compounds, ppm_error)
    if (nrow(match_mass) > 0) {
      match_mass <- cbind(name, rt, match_mass)
    } else {
      # Si aucun match n'est trouvé, ajouter une ligne avec NA pour les colonnes de match
      match_mass <- data.frame(name = name, rt = rt,mz = mz, mz_obs = mz_obs, mass = NA, ppm_error_value = NA)
    }
    
    results <- rbind(results, match_mass)
  }
  results <- dplyr::select(results, name, rt, mz, mz_obs, mass, ppm_error_value)
  return(results)
}  
  