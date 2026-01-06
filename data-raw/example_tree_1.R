example_tree_1_path <- system.file('extdata', 'example_tree_1.treefile', package = 'heattree')
example_tree_1 <- ape::read.tree(example_tree_1_path)
usethis::use_data(example_tree_1, overwrite = TRUE)
