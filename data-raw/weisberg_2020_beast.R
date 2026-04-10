# Download original file
source_url <- 'https://raw.githubusercontent.com/osuchanglab/AgrobacteriumEvolutionManuscript/refs/heads/master/chromosome_phylogenies/BEAST.tre'
temp_path <- tempfile()
download.file(source_url, destfile = temp_path)

# Subset for tips that have metadata associated with them
source('data-raw/weisberg_2020_metadata.R')
weisberg_2020_beast <- ape::read.nexus(temp_path)
shared_ids <- weisberg_2020_beast$tip.label[weisberg_2020_beast$tip.label %in% weisberg_2020_metadata$beast_node_id]
weisberg_2020_beast <- ape::keep.tip(weisberg_2020_beast, shared_ids)

# Save file and parsed version of data
ape::write.nexus(weisberg_2020_beast, file = 'inst/extdata/weisberg_2020_beast.tre')
usethis::use_data(weisberg_2020_beast, overwrite = TRUE)
