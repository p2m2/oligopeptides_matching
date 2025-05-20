# Constants
### Amino acids
aa <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", 
        "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")

### amino acids molecular weight
mass_aa <- c( 89.047679, 121.019751, 133.037509, 147.053159,
              165.078979,  75.032029, 155.069477, 131.094629,
              146.105528, 131.094629, 149.051051, 132.053493,
              115.063329, 146.069143, 174.111676, 105.042594,
              119.058244, 117.078979, 204.089878, 181.073894)

aa_mw <- setNames(mass_aa, aa)

### polyphenol list
name_polyphenol <- c("RA",
                     "CA",
                     "DHCA",
                     "GA",
                     "PCA",
                     "EC",
                     "CAT",
                     "CGA",
                     "4MC")

### polyphenol molecular weight
mass_polyphenol <- c(360.08451746,
                     180.04225873,
                     182.05790880, 
                     170.02152329, 
                     154.02660867,
                     290.07903816,
                     290.07903816,
                     354.09508215,
                     124.052429494)

polyphenols <- setNames(mass_polyphenol, name_polyphenol)

### Compute the chemical_derivation
#### Atomic exact mass
C = 12
H = 1.007825
O = 15.994615
N = 14.003074
S = 31.972072

schiff_base <- 2*H+1*O
michael_add <- 2*H
addition_reaction <- c(schiff_base,
                       michael_add)

#### Chemical_derivation
reduction <- 2*H
methylation <- 1*C+2*H
hydroxylation <- 1*O
dimethylation <- 2*methylation
hydroxylation_methylation <- hydroxylation+methylation
sulfation <- 3*O+S
arabinosylation <- 5*C+8*H+4*O
glucosylation <- 6*C+10*H+5*O
acetyl_glucosylation <- 8*C+12*H+6*O
glucuronidation <- 6*C+8*H+6*O
glucuronidation_methylation <- glucuronidation+methylation
glucuronidation_hydroxylation <- glucuronidation+hydroxylation
rutinosylation <- 12*C+20*H+9*O

#### static variable
name_chemical_derivation <- c("reduction", "methylation", "hydroxylation", 
                              "dimethylation", "hydroxylation_methylation", "sulfation", "arabinosylation", 
                              "glucosylation", "acetyl_glucosylation", "glucuronidation", 
                              "glucuronidation_methylation", "glucuronidation_hydroxylation", "rutinosylation")

mass_chemical_derivation <- c(reduction, methylation, hydroxylation, 
                              dimethylation, hydroxylation_methylation, sulfation, arabinosylation, 
                              glucosylation, acetyl_glucosylation, glucuronidation, 
                              glucuronidation_methylation, glucuronidation_hydroxylation, rutinosylation)

chemical_derivation <- setNames(mass_chemical_derivation, name_chemical_derivation)

# exact_mass calculation
peptides <- get_oligopeptides(aa_mw, oligomerization_degree = 2)

combined_compounds <- get_combination_compounds(peptides, 
                                                polyphenols, 
                                                addition_reaction=michael_add,
                                                chemical_derivation)

# load accurate mass
study_case <- read_excel("Samples/Bayati_Poojari_db.xlsx")
head(study_case)

# match single mz
mz_obs <- 480.0963
match_mz_obs(mz_obs, 'pos', combined_compounds, ppm_error = 5)
match_all_mz_obs_with_tolerance (mz_obs, 'pos', combined_compounds)
match_near_mz_obs_with_tolerance (mz_obs, 'pos', combined_compounds)
# match multiple mz

# Jointure enrichie avec recherche m/z
# Jointure enrichie avec recherche m/z
study_case_extended <- pmap_dfr(
  study_case,
  function(Analyte, `Accurate Mass [M+H]+`, KB_FO_name) {
    mz_obs <- `Accurate Mass [M+H]+`
    
    match <- match_near_mz_obs_with_tolerance(
      mz_obs = mz_obs,
      mode = "pos",
      compounds = combined_compounds,
      initial_ppm = 0,
      max_ppm = 200,
      step = 1
    )
    
    # Ajouter les infos d’origine
    match$Analyte <- Analyte
    match$KB_FO_name <- KB_FO_name
    
    match %>%
      select(Analyte, KB_FO_name, mz_obs, mz_theo, ppm_error_value, ppm_used)
  }
)
View(study_case_extended)
