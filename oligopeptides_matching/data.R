# this file is used in the test. check R directory.
# Constants
### Amino acids
aa <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")

### amino acids molecular weight
mass_aa <- c(89.047679, 121.019751, 133.037509, 147.053159, 165.078979, 
              75.032029, 155.069477, 131.094629, 146.105528, 131.094629,
              149.051051,132.053493, 115.063329, 146.069143, 174.111676,
              105.042594,119.058244, 117.078979,204.089878, 181.073894)

aa_mw <- setNames(mass_aa, aa)

### polyphenol list
name_polyphenol <- c("Cyanidin",
                     "Cyanidin 3,5-O-diglucoside",
                     "Cyanidin 3-O-(6''-acetyl-galactoside)",
                     "Cyanidin 3-O-(6''-acetyl-glucoside)",
                     "Cyanidin 3-O-(6''-caffeoyl-glucoside)")

### polyphenol molecular weight
mass_polyphenol <- c(287.244, 611.525,491.422, 491.422, 611.527)

polyphenols <- setNames(mass_polyphenol, name_polyphenol)

### Compute the chemical_derivation
#### Atomic exact mass
C = 12
H = 1.007825
O = 15.994615
N = 14.003074
S = 31.972072

addition_reaction <- 2*H+1*O

#### Chemical_derivation
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

#### static variable
name_chemical_derivation <- c("reduction", "methylation", "hydroxylation", 
                              "dimethylation", "hydroxylation_methylation", "sulfation", "arabinosylation", 
                              "glucosylation", "acetyl_glucosylation", "glucuronidation", 
                              "glucuronidation_methylation", "glucuronidation_hydroxylation", "rutinosylation")

mass_chemical_derivation <- c(reduction, methylation, hydroxylation, 
                              dimethylation, hydroxylation_methylation, sulfation, arabinosylation, 
                              glucosylation, acetyl_glucosylation, glucuronidation, 
                              glucuronidation_methylation, glucuronidation_hydroxylation, rutinosylation)

chemical_derivation <- setNames(mass_chemical_derivation, name_chemical_derivation)