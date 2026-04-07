data(weisberg_2020_metadata)
weisberg_2020_beast_path <- system.file('extdata', 'weisberg_2020_beast.tre', package = 'heattree')
weisberg_2020_beast <- ape::read.nexus(weisberg_2020_beast_path)
shared_ids <- weisberg_2020_beast$tip.label[weisberg_2020_beast$tip.label %in% weisberg_2020_metadata$beast_node_id]
weisberg_2020_beast <- ape::keep.tip(weisberg_2020_beast, shared_ids)
usethis::use_data(weisberg_2020_beast, overwrite = TRUE)
