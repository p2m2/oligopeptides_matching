
# Oligopeptides Matching

Legume cops constitute a promising alternative to reduce meat proteins in human diet. One of the locks to their use is the presence of polyphenols. Condensed tannins (polyphenol polymers) are contained in testa and during the processing steps (i.e alkalinization) some can be processed with the kernel. High pH triggered polyphenols autoxidation that led to quinone formation and thus to nucleophilic attacks (Michael addition or imine formation1) on proteins.

Despite considerable advances in metabolomics annotation, the metabolite identification remains challenging[2]. If numerous of natural compounds are now well known, the annotation of adducts and derivatives needs to the in-depth comprehension of natural compound reactivity and transformations3. 

Here we propose a computational solution to identify **polyphenol-peptides adducts in HRMS data.** We first compute possible peptides formation based on amino acids molecular weight (MW), we then calculate the addition of polyphenols through Michael addition and/or imine formation. While the addition reaction is a parameter which has to be set by the user, the polyphenol list remains under his control. At the end, the user will compare his experimental data to the in-silico database. The tolerated mass deviation is user-selectable (default 5ppm) and results are finally presented as a table. It gathers the putative adduct annotation, its MW, the feature identity (RT & m/z) that match with and δppm and a score. After validation, the aim is to release our solution in CRAN repository and to offer a visual interface using **RShiny**

In order to compute from amino acids molecular weight the putative oligomers of various oligomerization degree


You will find the diffeent codes and ReadME to follow order to better understand :[Oligopeptides_matching](https://github.com/p2m2/oligopeptides_matching.git)


