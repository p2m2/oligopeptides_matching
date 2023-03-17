# Constants
### Amino acids
aa <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y")

### amino acids molecular weight
mass_aa <- c(89.047679, 121.019751, 133.037509, 147.053159, 165.078979, 
              75.032029, 155.069477, 131.094629, 146.105528, 131.094629,
              149.051051,132.053493, 115.063329, 146.069143, 174.111676,
              105.042594,119.058244, 117.078979,204.089878, 181.073894)

aa_mw <- setNames(mass_aa, aa)

### Polyphenols
polyphenol <- c("Cyanidin",
                "Cyanidin 3,5-O-diglucoside",
                "Cyanidin 3-O-(6''-acetyl-galactoside)",
                "Cyanidin 3-O-(6''-acetyl-glucoside)",
                "Cyanidin 3-O-(6''-caffeoyl-glucoside)")

### polyphenol molecular weight
mass_polyphenol <- c(287.244, 611.525,491.422, 491.422, 611.527)

pp_mw <- setNames(mass_polyphenol, polyphenol)

### reaction elements
H2O <- 18.010565
H <- 1.007825

ionization_list = stats::setNames(c(H),c("H"))