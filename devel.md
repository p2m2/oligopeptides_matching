# Introduction 



# Developper notes

**PhenolExplorer_DB.xlsx** is an excel file containing data from the website http://phenol-explorer.eu. It contains 501 observations and 14 columns.
Six separate scripts were created using these data to combine amino acids and polyphenols in order to build and study oligopeptides and their associated compounds.
These scripts allow you to build these compbinations, calculate their theoretical masses, and compare them to the observed masses. 

***The goal is to identify compounds based on the m/z (mass on charge) observed.***

# Usage 
  -  Oligopeptides_building.R
  -  get_oligopeptides.R
  -  get_combination_compounds.R
  -  d_ppm.R
  -  Match_mz_obs.R
  
# Scripts

### Build_peptides.R
This script generates a peptide matrix considering a list of peptides with their masses and a specified oligomerization degree.

### oligopeptides_building.R
This script constructs a list of oligopeptides by combining existing oligopeptides with a list of amino acids.

### get_oligopeptides.R
This script generates a comprehensive oligopeptide matrix based on amino acids and oligomerization degree.

### get_combination_compounds.R
This script creates a matrix of compound combinations from oligopeptides, polyphenols, and their chemical derivatives.

### d_ppm.R
This script calculates the parts per million (ppm) difference between observed and theoretical m/z.

### Match_mz_obs.R
This script matches observed m/z with the masses of combined compounds using a specified dppm value. 


# Combination AA Polyphenol
<div style="text-align:center;"> 
![**Figure 1 : Evolution des BM-MSC vers les FL-BM B ou les FL LN B**](/Données/Sirine OUEIDA 2024/Combination_AA.png)
</div>








## check package

```R
devtools::check()
```

or 
```
R CMD build .
R CMD check *tar.gz
```
