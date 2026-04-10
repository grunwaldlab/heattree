# The `heattree` R package

This package makes it easy to visualize, manipulate, and export
phylogenetic trees in R using an interactive viewer/editor. You can
insert this tree viewer into Rmd/Quarto documents make your trees
accessible online. If you want to use this for web development outside
of R, consider the [javascript `heat-tree`
package](https://www.npmjs.com/package/@grunwaldlab/heat-tree) which
this package builds upon.

## Installation

For now, `heattree` is only available on Github and can be installed
with `devtools`:

``` R
devtools::install_github('grunwaldlab/heattree')
```

## Quick start

The package includes example data sets that are automatically loaded
with the package (e.g. `weisberg_2020_mlsa`), so you can try it out with
minimal effort. After installing the packages, simply run the lines
below to get an idea of how it works:

``` R
library(heattree)
heat_tree(
  tree = weisberg_2020_mlsa,
  metadata = weisberg_2020_metadata,
  aesthetics = c(tipLabelColor = 'host_type'),
  layout = 'circular')
```

![](reference/figures/unnamed-chunk-4-1.png)

[**See the “Getting Started” page for interactive
examples**](https://grunwaldlab.github.io/heattree/articles/Getting-started.md)

## Contributing and feedback

Contributions and feedback are welcome! Please visit the [GitHub
repository](https://github.com/grunwaldlab/heattree) to report issues or
submit pull requests.
