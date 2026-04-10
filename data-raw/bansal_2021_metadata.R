# Derived from https://figshare.com/articles/dataset/Deep_phylo-taxono_genomics_reveals_Xylella_as_a_variant_lineage_of_plant_associated_Xanthomonas_and_supports_their_taxonomic_reunification_along_with_Stenotrophomonas_and_Pseudoxanthomonas_/15831948/1

example_metadata_1_path <- system.file('extdata', 'example_metadata_1.tsv', package = 'heattree')
example_metadata_1 <- read.csv(example_metadata_1_path, sep = '\t')
usethis::use_data(example_metadata_1, overwrite = TRUE)
