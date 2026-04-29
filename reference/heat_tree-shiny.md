# Shiny bindings for heat_tree

Output and render functions for using heat_tree within Shiny
applications and interactive Rmd documents.

## Usage

``` r
heat_treeOutput(outputId, width = "100%", height = "400px")

renderheat_tree(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  output variable to read from

- width, height:

  Must be a valid CSS unit (like `'100%'`, `'400px'`, `'auto'`) or a
  number, which will be coerced to a string and have `'px'` appended.

- expr:

  An expression that generates a heat_tree

- env:

  The environment in which to evaluate `expr`.

- quoted:

  Is `expr` a quoted expression (with
  [`quote()`](https://rdrr.io/r/base/substitute.html))? This is useful
  if you want to save an expression in a variable.

## Value

`heat_treeOutput()` returns an output function that creates a Shiny UI
element for displaying a heat_tree widget. Used in the UI definition of
a Shiny app.

`renderheat_tree()` returns a render function that can be assigned to an
output element in the server function of a Shiny app. It returns a Shiny
render binding.
