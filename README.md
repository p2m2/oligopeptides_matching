# AdducTrackR

[![p2m2](https://circleci.com/gh/p2m2/AdducTrackR.svg?style=shield)](https://app.circleci.com/pipelines/github/p2m2)
[![](https://img.shields.io/badge/stable-shinyapps.io-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)](https://p2m2.shinyapps.io/AdducTrackR/)

In order to compute from amino acids molecular weight the putative oligomers of various oligomerization degree

🚀 Installation Instructions
This package can be installed either directly from GitHub or from source, depending on your development workflow.


**AdducTrackR** is an R package to compute in silico assemblies between polyphenols, amino acids, peptides, and protein fragments. It helps you explore _high-resolution mass spectrometry data_ by simulating possible *adducts* and suggesting candidate annotations for signals from experiments *mixing polyphenols* and *protein-related molecules*.

By default, the package uses all proteinogenic amino acids to calculate all possible assemblies for a given oligomerization level. Polyphenols, however, need to be specified by the user with their exact names and masses to fit your experimental data.

📦 Prerequisite
Make sure the devtools package is installed:

```R

install.packages("devtools", dependencies = TRUE)

```


🔧 Install from GitHub
Use the GitHub repository to install the latest version of the package:

```R

devtools::install_github("p2m2/AdducTrackR") # install package

library(AdducTrackR) # load package

```

🛠️ Install from Source (for Development)
If you are working with the source code locally (e.g., for editing or contributing):

```R

library(devtools)
library(roxygen2)

# Generate documentation and install
document()
install()

```


♻️ Rebuilding After Changes
If you’ve made updates to the documentation or code, regenerate the package metadata:

```R

document()

```

📚 Help & Documentation
To access the documentation for the main function:

```R

?oligopeptides_building

```

## Set Amino Acids & Generate Peptides

In this section, the user defines the set of proteogenic amino acids and their exact monoisotopic masses. These amino acids are then used to compute all possible oligopeptides of a given length (e.g., di-, tri-, or tetrapeptides), based on combinatorial assembly.

This simulated peptide library will serve as the interaction partners for polyphenols in the rest of the workflow.

⚠️ Be sure to include only the amino acids relevant to your experimental design or interest. The get_oligopeptides() function then automatically generates every possible combination of peptides up to a defined degree of polymerization.

```R

# Constants
### aminoacids list
aa1 <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")

### amino acids molecular weight
mass_aa1 <- c(89.047679, 121.019751, 133.037509, 147.053159, 165.078979, 
              75.032029, 155.069477, 131.094629, 146.105528, 131.094629,
              149.051051,132.053493, 115.063329, 146.069143, 174.111676,
              105.042594,119.058244, 117.078979,204.089878, 181.073894)

aa1_mw <- setNames(mass_aa1, aa1)

oligopeptides <- get_oligopeptides(aminoacids = aa1_mw,oligomerization_degree = 4)
show(oligopeptides)

```

## Polyphenolic Derivatization: Atomic Mass Initialization and Simulation Setup

To simulate realistic chemical modifications, the package allows you to define the exact atomic masses of relevant elements and to initialize common derivatization patterns. This includes specifying the names and exact masses of chemical groups frequently involved in polyphenol modifications—such as methylation, hydroxylation, or glycosylation.

```R

# Atomic exact mass
C = 12
H = 1.007825
O = 15.994615
N = 14.003074
S = 31.972072

# Chemical_derivation
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

name_chemical_derivation <- c("reduction", "methylation", "hydroxylation", 
"dimethylation", "hydroxylation_methylation", "sulfation", "arabinosylation", 
"glucosylation", "acetyl_glucosylation", "glucuronidation", 
"glucuronidation_methylation", "glucuronidation_hydroxylation", "rutinosylation")

mass_chemical_derivation <- c(reduction, methylation, hydroxylation, 
dimethylation, hydroxylation_methylation, sulfation, arabinosylation, 
glucosylation, acetyl_glucosylation, glucuronidation, 
glucuronidation_methylation, glucuronidation_hydroxylation, rutinosylation)

chemical_derivation <- setNames(mass_chemical_derivation, name_chemical_derivation)

```

## Example 1: Manual Input

### Set Your Reference Polyphenols

This step allows the user to manually define the list of polyphenols that will be used throughout the entire in silico workflow.
These compounds are experimentally relevant molecules, typically suspected to interact with amino-containing structures derived from proteogenic amino acids (e.g. peptides or amino acids themselves).

⚠️ This list must be provided by the user, and its accuracy is critical. All downstream calculations—mass matching, adduct formation, or derivatization—will rely entirely on the names and exact molecular weights specified at this step.

In this example, polyphenol names and exact masses are directly entered into the R script. You can also import them from a file if preferred, but the responsibility for defining and curating this reference list lies with the user.

📌 Make sure to include only the polyphenols that were actually present in your experimental design or that are of specific interest to your biological question.

ℹ️ The few polyphenol examples provided below are illustrative and were selected from the PolyphenolExplorer database.
*Neveu, V., Perez-Jiménez, J., Vos, F., Crespy, V., du Chaffaut, L., Mennen, L., ... & Scalbert, A. (2010). Phenol-Explorer: an online comprehensive database on polyphenol contents in foods. Database, 2010.* https://doi.org/10.1093/database/bap024


```R

# Constants
### polyphenol list
name_polyphenol <- c("Cyanidin",
                "Cyanidin 3,5-O-diglucoside",
                "Cyanidin 3-O-(6''-acetyl-galactoside)",
                "Cyanidin 3-O-(6''-acetyl-glucoside)",
                "Cyanidin 3-O-(6''-caffeoyl-glucoside)")

### polyphenol molecular weight
mass_polyphenol <- c(287.244, 611.525,491.422, 491.422, 611.527)

polyphenols <- setNames(mass_polyphenol, name_polyphenol)

```

## Generate Theoretical Adduct Combinations 

Easily create in silico adducts of polyphenols and peptides using customizable reaction rules. 

```R

schiff_base <- 2*H+1*O
michael_add <- 2*H
addition_reaction <- michael_add

combined_compounds <- get_combination_compounds(
                        oligopeptides, 
                          polyphenols,
                          chemical_derivation, 
                          addition_reaction
                          )
View(combined_compounds)

```

This comprehensive combinatorial table (*combined_compounds*) provides the core reference for downstream mass matching and annotation of experimental data.

## Example 2: Dataset from Bayati & Poojari Study

To demonstrate the functionality of AdducTrackR, we use experimental data published by Bayati & Poojari, which includes high-resolution mass measurements of polyphenol–peptide interactions.

This example illustrates how to cross-reference experimentally detected features with the in silico adduct predictions generated by AdducTrackR—highlighting the potential of the package to support annotation and validation of real-world datasets.


*Bayati, M., & Poojary, M. M. (2025). Polyphenol autoxidation and prooxidative activity induce protein oxidation and protein-polyphenol adduct formation in model systems. Food Chemistry, 466, 142208.* https://doi.org/10.1016/j.foodchem.2024.142208

Below, we load their dataset to use as a case study:

```R

library(readxl) # load package to manage .xlsx files

# load accurate mass
study_case <- read_excel("Samples/Bayati_Poojari_db.xlsx")
head(study_case)

```

### Reference Polyphenols from the Bayati & Poojari's Work

This section defines the list of polyphenols reported in the study by Bayati & Poojari. These compounds were experimentally identified as key actors in interactions with amino acid–based structures such as peptides or proteins.

To support accurate in silico modeling, each polyphenol is manually defined by its name and exact neutral mass (in Daltons). These masses correspond to the intact compounds used in the experimental setup. Ionization and derivatization processes—necessary for mass spectrometry comparisons—are handled downstream by the AdducTrackR pipeline.

The polyphenol names are abbreviated as in the original publication, and their associated masses are curated accordingly. This dataset serves as a chemical reference space for generating and comparing predicted peptide–polyphenol adducts.

```R

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

```

## Generate Theoretical Adduct Combinations 

This step computes in silico adducts between the reference polyphenols from Bayati & Poojari’s study and all peptides previously generated.

The chemical reaction mechanism can be specified by the user. In the example below, a Michael addition is simulated by defining the appropriate atomic mass shift. Other mechanisms—such as Schiff base formation—can also be implemented by adjusting the addition_reaction.

```R

# Define the mass shift for the desired adduct formation
schiff_base <- 2 * H + 1 * O       # Example: Schiff base
michael_add <- 2 * H               # Example: Michael addition
addition_reaction <- michael_add   # Select the desired reaction type

# Generate all polyphenol-peptide adduct combinations
combined_compounds <- get_combination_compounds(
  oligopeptides, 
  polyphenols,
  chemical_derivation, 
  addition_reaction
)

```

💡 This process creates a complete theoretical library of possible polyphenol–peptide adducts, which can later be matched against experimental mass spectrometry data.

### Theoretical vs Observed m/z Comparison

This step compares experimentally observed m/z values from Bayati & Poojari’s dataset to the theoretical adduct masses generated by AdducTrackR.

Each entry in the output table includes:

- The original analyte name and its observed m/z,
- The best matching theoretical adduct,
- The ppm error between observed and theoretical m/z,
- The ppm tolerance used for the match.

```R

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

```

🔎 This table provides a basis for validating predicted adducts against experimental results, enabling a practical assessment of the computational pipeline’s relevance and accuracy.