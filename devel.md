# Introduction 
Legume cops constitute a promising alternative to reduce meat proteins in human diet. One of the locks to their use is the presence of polyphenols. Condensed tannins (polyphenol polymers) are contained in testa and during the processing steps (i.e alkalinization) some can be processed with the kernel. High pH triggered polyphenols autoxidation that led to quinone formation and thus to nucleophilic attacks (Michael addition or imine formation1) on proteins.

Despite considerable advances in metabolomics annotation, the metabolite identification remains challenging2. If numerous of natural compounds are now well known, the annotation of adducts and derivatives needs to the in-depth comprehension of natural compound reactivity and transformations3. 
            Here we propose a computational solution to identify **polyphenol-peptides adducts in HRMS data.** We first compute possible peptides formation based on amino acids molecular weight (MW), we then calculate the addition of polyphenols through Michael addition and/or imine formation. While the addition reaction is a parameter which has to be set by the user, the polyphenol list remains under his control. At the end, the user will compare his experimental data to the in-silico database. The tolerated mass deviation is user-selectable (default 5ppm) and results are finally presented as a table. It gathers the putative adduct annotation, its MW, the feature identity (RT & m/z) that match with and δppm and a score. After validation, the aim is to release our solution in CRAN repository and to offer a visual interface using **RShiny**


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


# Développement de l'interface shiny

## Amino acid and mass
<div style="text-align:center;"> 
![**Amino acid and mass**](/Données/Sirine OUEIDA 2024/Amino_acid.png)
</div>

## Combination AA Polyphenol
<div style="text-align:center;"> 
![**Polyphenols and peptide conjugation**](/Données/Sirine OUEIDA 2024/Combination_AA.png)
</div>


## Match single mz
<div style="text-align:center;"> 
![**Match single mz**](/Données/Sirine OUEIDA 2024/Match_single.png)
</div>


# Match a list of mz



## check package

```R
devtools::check()
```

or 
```
R CMD build .
R CMD check *tar.gz
```
