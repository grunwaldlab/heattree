weisberg_2020_metadata_path <- system.file('extdata', 'weisberg_2020_metadata.tsv', package = 'heattree')
weisberg_2020_metadata <- read.table(weisberg_2020_metadata_path, sep = '\t', header = TRUE, check.names = FALSE)
usethis::use_data(weisberg_2020_metadata, overwrite = TRUE)
