<img src="C:/Données/Sirine OUEIDA 2024/GIT/oligopeptides_matching/oligopeptides_matching_stage/docs/shiny_logo.png" alt = "Drawing", style="width: 200px;">

<img src="https://github.com/p2m2/oligopeptides_matching/blob/stage-m1-2024-2/oligopeptides_matching_stage/docs/shiny_logo.png alt = "Drawing", style="width: 200px;">



[![p2m2](https://circleci.com/gh/p2m2/oligopeptides_matching.svg?style=shield)](https://app.circleci.com/pipelines/github/p2m2)
[![](https://img.shields.io/badge/stable-shinyapps.io-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)](https://p2m2.shinyapps.io/oligopeptides_matching/) 

# Introduction 
Legume cops constitute a promising alternative to reduce meat proteins in human diet. One of the locks to their use is the presence of polyphenols. Condensed tannins (polyphenol polymers) are contained in testa and during the processing steps (i.e alkalinization) some can be processed with the kernel. High pH triggered polyphenols autoxidation that led to quinone formation and thus to nucleophilic attacks (Michael addition or imine formation1) on proteins.

Despite considerable advances in metabolomics annotation, the metabolite identification remains challenging2. If numerous of natural compounds are now well known, the annotation of adducts and derivatives needs to the in-depth comprehension of natural compound reactivity and transformations3. 
            Here we propose a computational solution to identify **polyphenol-peptides adducts in HRMS data.** We first compute possible peptides formation based on amino acids molecular weight (MW), we then calculate the addition of polyphenols through Michael addition and/or imine formation. While the addition reaction is a parameter which has to be set by the user, the polyphenol list remains under his control. At the end, the user will compare his experimental data to the in-silico database. The tolerated mass deviation is user-selectable (default 5ppm) and results are finally presented as a table. It gathers the putative adduct annotation, its MW, the feature identity (RT & m/z) that match with and δppm and a score. After validation, the aim is to release our solution in CRAN repository and to offer a visual interface using **RShiny**

In order to compute from amino acids molecular weight the putative oligomers of various oligomerization degree

## Install Package locally

```R
install.packages("devtools",dependancies=TRUE)
```

### from github repository

```R
devtools::install_github("p2m2/oligopeptides_matching")
```

### from source code
```R
library(devtools)
library(roxygen2)
document()
install()
```
### Reload case

```R
document()
```

## Hint :
if the installation and "document" thing doesn't work, try to run each script and then try the examples below. 

# Data
PhenolExplorer_DB.xlsx is an excel file containing data from the website http://phenol-explorer.eu. Phenol-Explorer is the first comprehensive database for polyphenol content in foods. INRA developped Phenol-Explorer in partnership with **AFSSA, the University of Alberta, the University of Barcelona, the IARC, and Siliflo.**
This research was made possible by financial support from the French Governement, the National Cancer Institute (France), Unilever, Danone, and Nestle.

## Example

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
 ## Chemical derivation setup
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

## Example 2 : combination amino acids and polyphenols 

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

H2O <- 18.010565
addition_reaction <- H2O

combined_compounds <- get_combination_compounds(
                        oligopeptides, 
                          polyphenols,
                          chemical_derivation, 
                          addition_reaction
                          )
```

## Example 3 : match a mz_obs with the calculated list 

```R

mz_obs <- 360.2626
test <- match_mz_obs(mz_obs, 'already_charged', combined_compounds, ppm_error = 700)
print(test)

```

## Example 4 : match list with a mz_obs
```R
example_list_mz_obs <- data.frame(
     name = c("M954t1417", "M100T50", "M121T93"),
     mz = c(953.6798, 100.07, 120.9659),
     rt = c(10.5, 20.6, 30.7)
 )
 
match_list_mz_obs(example_list_mz_obs, 'already_charged', combined_compounds, ppm_error = 10)

```

## Acknowledgments
- Data about polyphenolic compounds are gracefuly provided by Phenol-Explorer:
    - [Neveu et al. (2010) Database](https://doi.org/10.1093/database/bap024)
    - [Rothwell et al. (2012) Database](https://doi.org/10.1093/database/bas031)
    - [Rothwell et al. (2013) Database](https://doi.org/10.1093/database/bat070)

