# oligopeptides_matching

[![p2m2](https://circleci.com/gh/p2m2/oligopeptides_matching.svg?style=shield)](https://app.circleci.com/pipelines/github/p2m2)

In order to compute from amino acids molecular weight the putative oligomers of various oligomerization degree

## Install Package locally


```R
# if necessary...
install.packages(devtools)
install.packages(roxygen2)

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

### reaction elements
H2O <- 18.010565
H <- 1.007825

### amino acids molecular weight
mass_aa1 <- c(89.047679, 121.019751, 133.037509, 147.053159, 165.078979, 
              75.032029, 155.069477, 131.094629, 146.105528, 131.094629,
              149.051051,132.053493, 115.063329, 146.069143, 174.111676,
              105.042594,119.058244, 117.078979,204.089878, 181.073894)

aa1_mw <- setNames(mass_aa1, aa1)

oligopeptides <- get_oligopeptides(aminoacids = aa1_mw,
                          chemical_reaction = H2O,
                          ionization = setNames(c(H),c("H")),
                          oligomerization_degree = 4)

show(oligopeptides)

```

## Example 2 : combination amino acids and polyphenols 

```R

# Constants
### polyphenol list
polyphenol <- c("Cyanidin",
                "Cyanidin 3,5-O-diglucoside",
                "Cyanidin 3-O-(6''-acetyl-galactoside)",
                "Cyanidin 3-O-(6''-acetyl-glucoside)",
                "Cyanidin 3-O-(6''-caffeoyl-glucoside)")

### polyphenol molecular weight
mass_polyphenol <- c(287.244, 611.525,491.422, 491.422, 611.527)

pp_mw <- setNames(mass_polyphenol, polyphenol)

aa <- c(oligopeptides$id)
aa_mass <- c(oligopeptides$MW)
aa_mw <- setNames(aa_mass, aa)

combined_compounds <- get_combination_compounds(compounds_1 = aa_mw, 
                          compounds_2 = pp_mw, 
                          chemical_reaction = H2O, 
                          ionization = setNames(c(H),c("H")))
```
## Example 3 : match a mz_obs with the caculated list 

```R

mz_obs <- 414.8986
test <- match_mz_obs(mz_obs, combined_compounds, ppm_error = 700)

```

## R Shiny

### Running example

```R
# if necessary...
install.packages("shiny")
install.packages("DT")

library(shiny)
library(DT)

library(devtools)
library(roxygen2)
document()
runApp("exampleOligopeptidesMatching_aa")
```

### Examples
- [search for amino acid combination](exampleOligopeptidesMatching_aa)
- [search for amino acids/oligopeptides and polyphenols combination](exampleOligopeptidesMatching_aa_and_polyphenols)

