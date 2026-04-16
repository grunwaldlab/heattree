# Getting started

The package includes example data sets that are automatically loaded
with the package (`weisberg_2020_mlsa`), so you can try it out with
minimal effort. After installing the packages, simply run the lines
below to get an idea of how it works:

``` r
library(heattree)
heat_tree(
  tree = weisberg_2020_mlsa,
  metadata = weisberg_2020_metadata,
  aesthetics = c(tipLabelColor = 'host_type'),
  manualZoomAndPanEnabled = FALSE
)
```

You will have the option to interactively upload your own trees/metadata
in the widgets menu as well under the “Data” tab.

## Basic Usage

This package is designed to be as simple to use as possible while also
allowing for advanced customization. In fact, since you can upload tree
and metadata interactively, it is entirely valid to create a widget with
no input:

``` r
library(heattree)
heat_tree()
```

You can also supply trees/metadata to plot when the widget in created.
The following types of input data are currently supported:

- Paths to newick files
- Newick-formatted text (a character vector with a single item)
- `phylo` objects from the `ape` package

For example, here is the test data included in the package in these
three formats:

``` r
weisberg_2020_mlsa_path <- system.file('extdata', 'weisberg_2020_mlsa.tre', package = 'heattree')
print(weisberg_2020_mlsa_path)
#> [1] "/tmp/RtmpBrIRzw/temp_libpath25ba1dd69651/heattree/extdata/weisberg_2020_mlsa.tre"

weisberg_2020_mlsa_text <- readLines(weisberg_2020_mlsa_path)
print(substr(weisberg_2020_mlsa_text, 1, 100))
#> [1] "(((((CG678__BV3:1.0000005e-06,CG78__BV3:1.0000005e-06)92.0:0.009478810652,((T268_95__BV3:1.0000005e-"

print(weisberg_2020_mlsa)  # The already parsed version in the ape phylo format
#> 
#> Phylogenetic tree with 86 tips and 36 internal nodes.
#> 
#> Tip labels:
#>   CG678__BV3, CG78__BV3, T268_95__BV3, BM37_95__BV3, F2_5__BV3, AV25_95__BV3, ...
#> Node labels:
#>   100.0, 100.0, 100.0, 87.0, 92.0, 76.0, ...
#> 
#> Rooted; includes branch length(s).
```

These three commands all produce the same plot:

``` r
heat_tree(weisberg_2020_mlsa_path, manualZoomAndPanEnabled = FALSE)
heat_tree(weisberg_2020_mlsa_text, manualZoomAndPanEnabled = FALSE)
heat_tree(weisberg_2020_mlsa, manualZoomAndPanEnabled = FALSE)
```

    Note: `manualZoomAndPanEnabled = FALSE` is used in these examples since the visualizations are part of a scrollable document and the zoom interfers with scrolling. By default, plots can be zoomed and panned. Remove `manualZoomAndPanEnabled = FALSE` to try it out.

You can also supply metadata for the tree by supplying a path to a
TSV/CSV or a `data.frame`/`tibble`.

This table must have a column with values matching the IDs in the tree
file. `heattree` will automatically identify which column has the IDs,
so it can have any name. For example, this data is associated with the
above example tree:

``` r
weisberg_2020_metadata_path <- system.file('extdata', 'weisberg_2020_metadata.tsv', package = 'heattree')
weisberg_2020_metadata <- readr::read_tsv(weisberg_2020_metadata_path)
print(weisberg_2020_metadata)
#> # A tibble: 148 × 13
#>    strain   species genus genomospecies host  host_type opine_type year_isolated
#>    <chr>    <chr>   <chr> <chr>         <chr> <chr>     <chr>              <dbl>
#>  1 Rhizobi… Rhizob… Rhiz… Biovar 2      Rose  Woody     Agrocinop…          1979
#>  2 Rhizobi… Rhizob… Rhiz… Biovar 2      Grape Grape (W… NA                  1995
#>  3 Agrobac… Agroba… Agro… Agrobacteriu… Euon… Woody     Agrocinop…          1973
#>  4 Rhizobi… Rhizob… Rhiz… Biovar 2      Rose  Woody     Nopaline              NA
#>  5 Rhizobi… Rhizob… Rhiz… Biovar 2      Cher… Woody     Nopaline            2008
#>  6 Agrobac… Agroba… Agro… Biovar 1      Ston… Herbaceo… Nopaline            1958
#>  7 Rhizobi… Rhizob… Rhiz… Biovar 2      Grape Grape (W… Nopaline            1995
#>  8 Allorhi… Allorh… Allo… Biovar 3      Grape Grape (W… Vitopine/…          1995
#>  9 Rhizobi… Rhizob… Rhiz… Biovar 2      Olal… Woody     Nopaline            1993
#> 10 Rhizobi… Rhizob… Rhiz… Biovar 2      Peach Woody     Nopaline            2009
#> # ℹ 138 more rows
#> # ℹ 5 more variables: plasmid_class <chr>, plasmid_type <chr>,
#> #   ncbi_accession <chr>, mlsa_node_id <chr>, beast_node_id <chr>
```

Similar to tree input, both paths and parsed data are accepted. Metadata
can be used to color or size tree elements, similar to how `ggplot2`
works. The `aesthetics` parameter is used to specify which columns
correspond to which aesthetics. These two commands produce the same
plot:

``` r
heat_tree(
  tree = weisberg_2020_mlsa,
  metadata = weisberg_2020_metadata,
  aesthetics = c(tipLabelText = 'strain', tipLabelColor = 'host_type'),
  manualZoomAndPanEnabled = FALSE
)
```

Check the
[`heat-tree`](https://www.npmjs.com/package/@grunwaldlab/heat-tree)
JavaScript package documentation for the list of valid aesthetics.

## Initial settings

Although the widget is primarily designed for interactive use, the
initial settings can be set programmatically. All of the value of
options described in the
[`heat-tree`](https://www.npmjs.com/package/@grunwaldlab/heat-tree)
JavaScript package documentation can be used as optional parameters. For
example, the layout can be changed to circular like so:

``` r
heat_tree(
  tree = weisberg_2020_mlsa,
  metadata = weisberg_2020_metadata,
  aesthetics = c(tipLabelText = 'strain', tipLabelColor = 'host_type'),
  manualZoomAndPanEnabled = FALSE, layout = 'circular'
)
```

## Multiple trees

The `heat_tree` widget is capable of managing multiple trees at once. To
initialize a widget with multiple trees, supply lists of tree and
metadata inputs. If metadata/aesthetics are also supplied they must a
list as well that corresponds to the list of trees. For example:

``` r
heat_tree(
  tree = list(
    'Weisberg 2020 MLSA' = weisberg_2020_mlsa,
    'Weisberg 2020 Beast' = weisberg_2020_beast,
    'Bansal 2021' = bansal_2021_tree
  ),
  metadata = list(weisberg_2020_metadata, weisberg_2020_metadata, bansal_2021_metadata),
  aesthetics = list(
    c(tipLabelText = 'strain', tipLabelColor = 'host_type'),
    c(tipLabelText = 'strain', tipLabelColor = 'year_isolated'),
    c(tipLabelColor = 'Lifestyle')
  ),
  manualZoomAndPanEnabled = FALSE
)
```

## For more information

The documentation here only covers the aspects of creating the tree
visualizations in R. For information on the extensive controls embedded
in the widget, refer to the documentation of the [JavaScript
package](https://github.com/grunwaldlab/heat-tree) that implements them.
