# oligopeptides_matching

[![p2m2](https://circleci.com/gh/p2m2/oligopeptides_matching.svg?style=shield)](https://app.circleci.com/pipelines/github/p2m2)
[![](https://img.shields.io/badge/stable-shinyapps.io-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)](https://p2m2.shinyapps.io/oligopeptides_matching/)

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

## Help 

```
?oligopeptides_building
```

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

combined_compounds <- get_combination_compounds(oligopeptides, 
                          polyphenols, 
                          addition_reaction,
                          chemical_derivation)
                          
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

