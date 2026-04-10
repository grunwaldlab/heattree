# Derived from https://figshare.com/articles/dataset/Deep_phylo-taxono_genomics_reveals_Xylella_as_a_variant_lineage_of_plant_associated_Xanthomonas_and_supports_their_taxonomic_reunification_along_with_Stenotrophomonas_and_Pseudoxanthomonas_/15831948/1

bansal_2021_tree_path <- system.file('extdata', 'bansal_2021_tree.nwk', package = 'heattree')
bansal_2021_tree <- ape::read.tree(bansal_2021_tree_path)
usethis::use_data(bansal_2021_tree, overwrite = TRUE)
