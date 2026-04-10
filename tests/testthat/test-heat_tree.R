test_that("Included tree example works", {
  tree_path <- system.file('extdata', 'bansal_2021_tree.nwk', package = 'heattree')
  meta_path <- system.file('extdata', 'bansal_2021_metadata.tsv', package = 'heattree')
  my_plot <- heat_tree(tree_path, metadata = meta_path, aesthetics = c(tipLabelColor = 'Lifestyle'))
  expect_s3_class(my_plot, "heat_tree")
  expect_s3_class(my_plot, "htmlwidget")
})
