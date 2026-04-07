data(weisberg_2020_metadata)
weisberg_2020_mlsa_path <- system.file('extdata', 'weisberg_2020_mlsa.tre', package = 'heattree')
weisberg_2020_mlsa <- ape::read.tree(weisberg_2020_mlsa_path)
shared_ids <- weisberg_2020_mlsa$tip.label[weisberg_2020_mlsa$tip.label %in% weisberg_2020_metadata$mlsa_node_id]
weisberg_2020_mlsa <- ape::keep.tip(weisberg_2020_mlsa, shared_ids)
usethis::use_data(weisberg_2020_mlsa, overwrite = TRUE)
