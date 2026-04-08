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
