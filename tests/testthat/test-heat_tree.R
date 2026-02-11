test_that("Included tree example works", {
  tree_path <- system.file('extdata', 'example_tree_1.treefile', package = 'heattree')
  meta_path <- system.file('extdata', 'example_metadata_1.tsv', package = 'heattree')
  my_plot <- heat_tree(tree_path, metadata = meta_path, aesthetics = c(tipLabelColor = 'source'))
  expect_s3_class(my_plot, "heat_tree")
  expect_s3_class(my_plot, "htmlwidget")
})
