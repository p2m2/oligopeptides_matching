# Data description
Embedded file contains a list of polyphenols coming from the [Phenol-Explorer database](http://phenol-explorer.eu/).
Headers are `ID	Polyphenol Class	Polyphenol Sub-Class	Name	Family	Molecular Weight	Synonyms	Chemical Formula	CAS Number	ChEBI ID	PubChem ID	Aglycones	Created At	Updated At`

# Example that query mass from Phenol-Explorer database

```R
phenolExplorer_DB <- read_excel("./Data/phenolExplorer_DB.xls")

phenolExplorer_DB_names <- phenolExplorer_DB$Name
phenolExplorer_DB_mass <- phenolExplorer_DB$`Molecular Weight`
phenolExplorer_DB_mw <- setNames(phenolExplorer_DB_mass, phenolExplorer_DB_names)

db_combined <- get_combination_compounds(compounds_1 = aa_mw, 
                                  compounds_2 = phenolExplorer_DB_mw, 
                                  chemical_reaction = H2O, 
                                  ionization = setNames(c(H),c("H")))
```