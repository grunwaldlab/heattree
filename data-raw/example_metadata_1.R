example_metadata_1_path <- system.file('extdata', 'example_metadata_1.tsv', package = 'heattree')
example_metadata_1 <- read.csv(example_metadata_1_path, sep = '\t')
usethis::use_data(example_metadata_1, overwrite = TRUE)
