# Examples

## Weisberg et al. 2020

Below are two phylogenetic trees of agrobacteria isolates plotted in the
same widget, one a multilocus sequence analysis (MLSA) and another from
a time-calibrated BEAST tree, both from the following study:

Alexandra J. Weisberg et al., Unexpected conservation and global
transmission of agrobacterial virulence plasmids. Science 368, eaba5256
(2020)

Code

``` r

library(heattree)

data(weisberg_2020_metadata)
data(weisberg_2020_mlsa)
data(weisberg_2020_beast)

heat_tree(
  tree = list('MLSA' = weisberg_2020_mlsa, 'BEAST' = weisberg_2020_beast),
  metadata = list(weisberg_2020_metadata, weisberg_2020_metadata),
  aesthetics = list(
    c(tipLabelText = 'strain', tipLabelColor = 'host_type'),
    c(tipLabelText = 'strain', tipLabelColor = 'year_isolated')
  ),
  manualZoomAndPanEnabled = FALSE
)
```

## Bansal et al. 2021

Phylogenetic trees from a comparative genomics study of Xylella:

Bansal, K., Kumar, S., Kaur, A., Singh, A., & Patil, P. B. (2021). Deep
phylo-taxono genomics reveals Xylella as a variant lineage of plant
associated Xanthomonas and supports their taxonomic reunification along
with Stenotrophomonas and Pseudoxanthomonas. Genomics, 113(6),
3989-4003.

Code

``` r

library(heattree)

data(bansal_2021_metadata)
data(bansal_2021_tree)

heat_tree(
  tree = bansal_2021_tree,
  metadata = bansal_2021_metadata,
  aesthetics = c(tipLabelColor = 'Lifestyle'),
  manualZoomAndPanEnabled = FALSE
)
```

## Phytools datasets

The [`phytools`](https://github.com/liamrevell/phytools) package has
many example trees with associated metadata, ideal for use with
`heattree`. Below is all of these data sets in a single `heattree`
widget.

Code

``` r

# Load required datasets from phytools
library(phytools)
#> Loading required package: ape
#> Loading required package: maps
data(anole.data)
data(anoletree)
data(bonyfish.data)
data(bonyfish.tree)
data(butterfly.data)
data(butterfly.tree)
data(eel.data)
data(eel.tree)
data(flatworm.data)
data(flatworm.tree)
data(mammal.data)
data(mammal.tree)
data(primate.data)
data(primate.tree)
data(sunfish.data)
data(sunfish.tree)
data(tropidurid.data)
data(tropidurid.tree)

# Create tree widget
library(heattree)
heat_tree(
  tree = list(
    'Anoles' = anoletree,
    'Bony fishs' = bonyfish.tree,
    'Butterflies' = butterfly.tree,
    'Eels' = eel.tree,
    'Flatworms' = flatworm.tree,
    'Mammals' = mammal.tree,
    'Primates' = primate.tree,
    'Sunfishes' = sunfish.tree,
    'Tortoises' = tropidurid.tree
  ),
  metadata = list(
    anole.data,
    bonyfish.data,
    butterfly.data,
    eel.data,
    flatworm.data,
    mammal.data,
    primate.data,
    sunfish.data,
    tropidurid.data
  ),
  aesthetics = list(
    c(tipLabelColor = 'SVL'),
    c(tipLabelColor = 'paternal_care'),
    c(tipLabelColor = 'habitat'),
    c(tipLabelColor = 'feed_mode'),
    c(tipLabelColor = 'Habitat'),
    c(tipLabelColor = 'bodyMass'),
    c(tipLabelColor = 'Skull_length'),
    c(tipLabelColor = 'buccal.length'),
    c(tipLabelColor = 'body_height')
  ),
  layout = 'circular', manualZoomAndPanEnabled = FALSE
)
```
