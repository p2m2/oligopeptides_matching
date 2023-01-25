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

## R Shiny


```R
# if necessary...
install.packages("shiny")
install.packages("DT")

library(shiny)
library(DT)

library(devtools)
library(roxygen2)
document()
install()
runApp("exampleOligopeptidesMatching")
```