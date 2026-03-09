# Create an interactive phylogenetic tree

Create an interactive phylogenetic tree using the javascript
[heat-tree](https://github.com/grunwaldlab/heat-tree) package

## Usage

``` r
heat_tree(
  tree = NULL,
  metadata = NULL,
  aesthetics = NULL,
  width = NULL,
  height = NULL,
  elementId = NULL,
  ...
)
```

## Arguments

- tree:

  One or more trees to plot. Can be a raw newick-formatted string, a
  `phylo` object, or a list of such inputs. If a list is provided, its
  names will be used to name trees.

- metadata:

  Metadata associated with `tree`. Can be a `data.frame` or `tibble`
  with a "node_id" column. If there are multiple trees (a list), then a
  list of table of equal length is required. If a list is provided, its
  names will be used to name metadata tables.

- aesthetics:

  A named character vector defining which metadata columns are initially
  used to color/size tree parts. If there are multiple trees (a list),
  then a list of equal length is required.

- width:

  Width of the widget (CSS units or number).

- height:

  Height of the widget (CSS units or number).

- elementId:

  Optional element ID for the widget.

- ...:

  Options passed to options parameter of the underlying
  `HeatTree.heatTree()` javascript function to modify the initial state
  of the widget.

## Examples

``` r
# Create an empty tree viewer for loading data interactively
heat_tree()

{"x":{"trees":[],"options":[]},"evals":[],"jsHooks":[]}
# Create a tree viewer with example data included with the package
tree_path <- system.file('extdata', 'example_tree_1.treefile', package = 'heattree')
meta_path <- system.file('extdata', 'example_metadata_1.tsv', package = 'heattree')
heat_tree(tree_path, metadata = meta_path, aesthetics = c(tipLabelColor = 'source'))

{"x":{"trees":[{"name":"tree 1","newick":"(GCF_001456355_1:0.0374257169,GCF_004924335_1:0.0560765283,((GCF_001605725_1:0.0368285060,((SAMN11100995:0.0009734615,((SAMN11100993:0.0011764590,SAMN11100994:0.0007851371)97:0.0008756385,GCF_965135695_1:0.0017680397)95:0.0007738859)100:0.0068614333,SAMN11100996:0.0052198129)100:0.0382367799)100:0.0110598189,((GCF_000015305_1:0.0852699717,GCF_022370835_2:0.1042432673)100:0.0373624593,((((GCF_019048125_1:0.0361957779,((GCF_002837625_1:0.0019194673,((SAMEA882273:0.0024741566,SAMEA882280:0.0014582935)65:0.0005123485,GCF_001807645_1:0.0022634792)79:0.0010696016)100:0.0170761384,(GCF_000238715_1:0.0009371376,SAMEA882278:0.0004802655)100:0.0216873805)100:0.0211814175)100:0.0252764233,GCF_000010385_1:0.0681115223)99:0.0186822467,GCF_000164865_1:0.0357435232)100:0.1963223006,((((GCF_014054985_1:0.1629484002,GCF_900453895_1:0.0825572782)51:0.0331440744,((((((SAMEA3880305:0.0129810163,GCF_001814225_1:0.0110829584)87:0.0029936621,(SAMEA3880302:0.0039658683,SAMEA3880307:0.0064143661)100:0.0045372579)96:0.0036784831,GCF_022869645_1:0.0090709218)100:0.0118974163,GCF_003315235_1:0.0202070869)100:0.0306956825,GCF_900475315_1:0.0495967784)100:0.0305557472,GCF_002073715_2:0.0478873659)100:0.0377786543)50:0.0277495030,GCF_008806995_1:0.0878264736)51:0.0399857483,GCF_014055005_1:0.0688670840)100:0.1874050401)100:0.3400567094)100:0.0583908447)91:0.0112793607);","metadata":[{"name":"metadata 1","data":"node_id\tabundance\tfrequency\tsource\tfont_style\nGCF_001456355_1\t145\t0.23\tfarm\tnormal\nGCF_004924335_1\t892\t0.67\tnursery\tnormal\nGCF_001605725_1\t234\t0.45\tcity\tnormal\nSAMN11100995\t567\t0.89\tother\titalic\nSAMN11100993\t123\t0.12\tfarm\titalic\nSAMN11100994\t456\t0.34\tnursery\titalic\nGCF_965135695_1\t789\t0.56\tcity\tnormal\nSAMN11100996\t321\t0.78\tother\titalic\nGCF_000015305_1\t654\t0.23\tfarm\tnormal\nGCF_022370835_2\t987\t0.91\tnursery\tbold\nGCF_019048125_1\t432\t0.45\tcity\tnormal\nGCF_002837625_1\t876\t0.67\tother\tnormal\nSAMEA882273\t210\t0.34\tfarm\titalic\nSAMEA882280\t543\t0.56\tnursery\titalic\nGCF_001807645_1\t765\t0.78\tcity\tnormal\nGCF_000238715_1\t198\t0.12\tother\tnormal\nSAMEA882278\t654\t0.89\tfarm\titalic\nGCF_000010385_1\t321\t0.23\tnursery\tnormal\nGCF_000164865_1\t987\t0.45\tcity\tnormal\nGCF_014054985_1\t456\t0.67\tother\tnormal\nGCF_900453895_1\t789\t0.34\tfarm\tnormal\nSAMEA3880305\t123\t0.56\tnursery\titalic\nGCF_001814225_1\t456\t0.78\tcity\tnormal\nSAMEA3880302\t654\t0.91\tother\titalic\nSAMEA3880307\t321\t0.12\tfarm\titalic\nGCF_022869645_1\t987\t0.34\tnursery\tnormal\nGCF_003315235_1\t234\t0.56\tcity\tnormal\nGCF_900475315_1\t567\t0.78\tother\tnormal\nGCF_002073715_2\t890\t0.23\tfarm\tbold\nGCF_008806995_1\t432\t0.45\tnursery\tnormal\nGCF_014055005_1\t765\t0.67\tcity\tnormal"}],"aesthetics":{"tipLabelColor":"source"}}],"options":[]},"evals":[],"jsHooks":[]}
```
