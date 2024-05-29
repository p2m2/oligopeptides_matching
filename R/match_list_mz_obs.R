# définir la fonction avec ses paramètres
# Boucle sur la liste mz_obs
# appel à la fonction match_mz_obs 
# rbind : pour ajouter les résultats 
# Sélection des colonnes

match_list_mz_obs <- function(list_mz_obs, # contient les mz, name, rt
                              ionization,
                              combined_compounds,
                              ppm_error=5
                         ) {
  data_list <- data.frame()
  for (mz_obs in list_mz_obs) { 
    match_mass <- match_mz_obs(mz_obs, ionization, combined_compounds, ppm_error)
    data_list <- rbind(data_list, match_mass)
    
  }
  data_list <- dplyr::select(list_mz_obs, mz, mass, ppm_error_value)
      return(data_list)
  }