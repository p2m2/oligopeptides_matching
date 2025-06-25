# AdducTrackR

[![p2m2](https://circleci.com/gh/p2m2/oligopeptides_matching.svg?style=shield)](https://app.circleci.com/pipelines/github/p2m2)
[![](https://img.shields.io/badge/stable-shinyapps.io-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)](https://p2m2.shinyapps.io/oligopeptides_matching/)

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

devtools::install_github("p2m2/oligopeptides_matching")

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

##  Set Your Reference Polyphenols

This step allows the user to define the list of polyphenols that will be used throughout the entire in silico workflow.
These compounds are experimentally relevant molecules, typically suspected to interact with amino-containing structures derived from proteogenic amino acids (e.g. peptides or amino acids themselves).

⚠️ This list must be provided by the user, and its accuracy is critical. All downstream calculations—mass matching, adduct formation, or derivatization—will rely on the exact names and molecular weights defined here.

Make sure to only include compounds actually used in your experimental setup or of specific interest to your study.


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

## Polyphenol Derivatization and Atomic Mass Definition

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

## Build Your In Silico Polyphenol-Peptide Library 

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
```

## Example Dataset from Bayati & Poojari Study

To demonstrate the package functionality, we use experimental data published by Bayati and Poojari. Their study provides accurate mass measurements relevant for exploring polyphenol-peptide interactions.

*Bayati, M., & Poojary, M. M. (2025). Polyphenol autoxidation and prooxidative activity induce protein oxidation and protein-polyphenol adduct formation in model systems. Food Chemistry, 466, 142208.* https://doi.org/10.1016/j.foodchem.2024.142208

Below, we load their dataset to use as a case study:

```R

# load accurate mass
study_case <- read_excel("Samples/Bayati_Poojari_db.xlsx")
head(study_case)

```



































## Example 3 : match a mz_obs with the caculated list 

```R

mz_obs <- 360.2626
test <- match_mz_obs(mz_obs, 'already_charged', combined_compounds, ppm_error = 700)

```

## R Shiny

### Running example

```R
# if necessary...
install.packages("shiny")
install.packages("DT")

library(shiny)

library(devtools)
library(roxygen2)
document()
runApp("oligopeptides_matching")
```

### Examples
- [search for amino acid combination](exampleOligopeptidesMatching_aa)
- [search for amino acids/oligopeptides and polyphenols combination](exampleOligopeptidesMatching_aa_and_polyphenols)

## Acknowledgments
- Data about polyphenolic compounds are gracefuly provided by Phenol-Explorer:
    - [Neveu et al. (2010) Database](https://doi.org/10.1093/database/bap024)
    - [Rothwell et al. (2012) Database](https://doi.org/10.1093/database/bas031)
    - [Rothwell et al. (2013) Database](https://doi.org/10.1093/database/bat070)

