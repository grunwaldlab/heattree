# 'weisberg_2020_data_s1.tsv' is the first table from the following Excel sheet exported to TSV:
# https://www.science.org/doi/suppl/10.1126/science.aba5256/suppl_file/aba5256-data-s1-to-s19.xlsx

# Load raw data file included with package
weisberg_2020_metadata_path <- system.file('extdata', 'weisberg_2020_data_s1.tsv', package = 'heattree')
weisberg_2020_metadata <- read.table(weisberg_2020_metadata_path, sep = '\t', header = TRUE, check.names = FALSE)

# Rename columns to work better with R
colnames(weisberg_2020_metadata) <- c(
  'strain_id',
  'taxonomic_classification',
  '3-letter_code',
  'genomospecies',
  'host',
  'host_type',
  'location_code',
  'opine_type',
  'year_isolated',
  'plasmid_class',
  'plasmid_type',
  'ncbi_accession'
)

# Derive IDs used in trees from other columns
weisberg_2020_metadata$mlsa_node_id <- paste0(
  ifelse(is.na(weisberg_2020_metadata$strain_id), '', weisberg_2020_metadata$strain_id),
  '__',
  ifelse(is.na(weisberg_2020_metadata$`3-letter_code`), '', weisberg_2020_metadata$`3-letter_code`)
)
weisberg_2020_metadata$mlsa_node_id <- gsub(weisberg_2020_metadata$mlsa_node_id, pattern = '[/ ]', replacement = '_')
weisberg_2020_metadata$beast_node_id <- gsub(weisberg_2020_metadata$strain_id, pattern = '[/ ]', replacement = '_')

# Subset to rows used in trees
mlsa_tip_ids <- c("CG678__BV3", "CG78__BV3", "T268_95__BV3", "BM37_95__BV3",
                  "F2_5__BV3", "AV25_95__BV3", "V80_94__BV3", "CG412__BV3", "P86_93__BV3",
                  "T267_94__BV3", "T60_94__BV3", "T393_94__BV3", "FPH-AR2__Ala",
                  "Di1472__Ask", "A19_93__Aru", "Eu3-2RS__Aru", "Eu3-2NK__Aru",
                  "W2_73__Aru", "Eu2-1NK__Aru", "AS2A7__Aru", "Eu2-1RS__Aru", "AL_9.2.2__",
                  "AC44_96__BV2-like", "AF27_95__BV2", "Y79_96__BV2", "AC27_96__BV2-like",
                  "P1_75__BV2", "RO_2.2__BV2", "U167_95__BV2", "CA75_95__BV2",
                  "CA84_95__BV2", "AP82_95__BV2", "A_6.4__BV2", "AR13K_71__BV2",
                  "K6_73__BV2", "R_10.1__BV2", "B4_73__BV2", "D10b_87__BV2", "D1_94__BV2",
                  "AS10_95__BV2", "K27__BV2", "Z4_95__BV2", "RO_11.4__BV2", "B49C_83__BV2",
                  "M2_73__BV2", "C16_80__BV2", "B147_94__BV2", "K95_95__BV2", "X1_95__BV2",
                  "D100_85__BV2", "D108_85__BV2", "L20_94__BV2", "D1_76__BV2",
                  "Di1462__BV2", "D2_76__BV2", "T5_73__BV2", "I2_75__BV2", "13-626__BV2",
                  "CM65_95__BV2", "J10B_93__BV2", "J5a_93__BV2", "P23_94__BV2",
                  "CG101_95__BV2", "B1_74__BV2", "A1_90__BV2", "AQ11_95__BV2",
                  "B133_95__BV2", "PVM_10.5__BV2", "R_1.1__BV2", "W_1.1__BV2",
                  "W_1.4__BV2", "S32_96__BV2", "CM80_95__BV2", "CM79_95__BV2",
                  "Di1411__BV2", "RO_10.5__BV2", "G_10.5__BV2", "H16_79__BV2",
                  "A_13.1__BV2", "AL._21.2__BV2", "B131_95__BV2", "AF44_96__BV2",
                  "CP182_95__BV2", "L29_94__BV2", "N64_94__BV2", "T155_95__BV2")
beast_tip_ids <- c("H16_79", "CG101_95", "W2_73", "Di1462", "A_6.4", "LMG_305",
                   "CM79_95", "BM37_95", "J10B_93", "R_10.1", "N64_94", "A_13.1",
                   "P86_93", "T268_95", "B131_95", "D108_85", "D1_76", "AL_9.2.2",
                   "PVM_10.5", "T60_94", "U167_95", "13-2099-1-2", "L29_94", "AF82_95",
                   "RO_10.5", "D2_76", "AL._21.2", "R_1.1", "D1_94", "15-1187-1-2a",
                   "B133_95", "D100_85", "AF52_95", "W_1.1", "G_8.3", "T267_94",
                   "15-1187-1-2b", "N2_73", "L20_94", "AF1_95", "W_1.4", "LMG_215",
                   "T393_94", "B140_95", "IL30", "G_10.5", "LMG_232", "V80_94",
                   "15-172", "AC44_96", "FPH-AT4", "W9_94", "RO_2.2", "LMG_267",
                   "AV25_95", "15-174", "AC27_96", "FPH-AR2", "CM65_95", "RO_11.4",
                   "LMG_292", "CG53_95", "13-626", "Di1411", "IL15", "J3_75", "Di1519",
                   "CP182_95", "2788", "AF27_95", "K224", "N40_94", "J2_75", "Eu3-2NK",
                   "AF44_96", "T155_95", "Eu2-1RS", "Eu2-1NK", "CM80_95", "Eu3-2RS",
                   "CA84_95", "S32_96", "16-280-1a", "C16_80", "16-280-1b", "ATCC_15834",
                   "S4", "B6806", "1D1108", "1D1460", "1D1609", "1D132", "ATCC_15955",
                   "CG412", "CG678", "CG78", "F2_5", "12D1", "12D13", "A6", "GC1A3",
                   "K27", "A19_93", "J5a_93", "P22_94", "W10_94", "Q15_94", "N33_94",
                   "Z4_95", "AQ11_95", "AP82_95", "CA75_95", "Y79_96", "T5_73",
                   "H25_79", "P23_94", "O16_94", "B147_94", "T90_95", "AS10_95",
                   "Di1472", "Di1525a", "O54_95", "X1_95", "K95_95", "A1_90", "B1_74",
                   "B4_73", "CG920", "G3_79", "G9_79", "I2_75", "K6_73", "K196_80",
                   "M2_73", "P1_75", "Y2_73", "B49C_83", "D10b_87", "AR13K_71",
                   "06-478_st", "YO0101", "06-777-2L", "06-617-1", "A51", "A74a",
                   "14-818c")
is_in_tree <- weisberg_2020_metadata$mlsa_node_id %in% mlsa_tip_ids | weisberg_2020_metadata$beast_node_id %in% beast_tip_ids
weisberg_2020_metadata <- weisberg_2020_metadata[is_in_tree, ]
rownames(weisberg_2020_metadata) <- NULL

# Make columns of taxonomic info for tip labels
genus_key <- c(rhizogenes = 'Rhizobium', tumefaciens = 'Agrobacterium', rubi = 'Agrobacterium', vitis = 'Allorhizobium', Neorhizobium = 'Neorhizobium', "BV2-like" = "BV2-like", 'larrymoorei' =  'Agrobacterium', skierniewicense = 'Rhizobium')
weisberg_2020_metadata$genus <- genus_key[weisberg_2020_metadata$taxonomic_classification]
weisberg_2020_metadata$species <- paste(weisberg_2020_metadata$genus, weisberg_2020_metadata$taxonomic_classification)
weisberg_2020_metadata$species[weisberg_2020_metadata$species == "Neorhizobium Neorhizobium"] <- "Neorhizobium sp."
weisberg_2020_metadata$species[weisberg_2020_metadata$species == "BV2-like BV2-like"] <- "BV2-like sp."
weisberg_2020_metadata$strain <- paste0(weisberg_2020_metadata$species, ' ', weisberg_2020_metadata$strain_id)
genomospecies_key <- c(
  'BV1' = 'Biovar 1',
  'BV2' = 'Biovar 2',
  'BV2-like' = 'Biovar 2 like',
  'BV3' = 'Biovar 3'
)
weisberg_2020_metadata$genomospecies <- genomospecies_key[weisberg_2020_metadata$`3-letter_code`]
weisberg_2020_metadata$genomospecies[is.na(weisberg_2020_metadata$genomospecies)] <- weisberg_2020_metadata$species[is.na(weisberg_2020_metadata$genomospecies)]

# Replace empty values with NA
weisberg_2020_metadata[] <- lapply(weisberg_2020_metadata, function(x) {
  x[x == ''] <- NA
  x
})

# Make the year isolated fully numeric
weisberg_2020_metadata$year_isolated[! grepl(weisberg_2020_metadata$year_isolated, pattern = '^[0-9]+$')] <- NA

# Subset columns useful for plotting and reorder
cols <- c('strain', 'species', 'genus', 'genomospecies', 'host', 'host_type', 'opine_type', 'year_isolated', 'plasmid_class', 'plasmid_type', 'ncbi_accession', 'mlsa_node_id', 'beast_node_id')
weisberg_2020_metadata <- weisberg_2020_metadata[cols]

# Save the parsed version for use in examples
usethis::use_data(weisberg_2020_metadata, overwrite = TRUE)
write.table(weisberg_2020_metadata, file = 'inst/extdata/weisberg_2020_metadata.tsv', sep = '\t', quote = FALSE, row.names = FALSE)
