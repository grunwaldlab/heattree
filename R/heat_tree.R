#' <Add Title>
#'
#' <Add Description>
#'
#' @param df dataframe
#' @export
df_to_tsv <- function(df) {
  paste(
    paste(colnames(df), collapse = "\t"),
    apply(df, 1, function(row) paste(row, collapse = "\t")),
    sep = "\n",
    collapse = "\n"
  )
}

#' @param width   Width of the widget (CSS units or number).
#' @param height  Height of the widget (CSS units or number).
#' @param elementId Optional element ID for the widget.
#'
#' @import htmlwidgets
#'
#' @export
heat_tree <- function(width = NULL, height = NULL, elementId = NULL) {

  createWidget(
    name = 'heat_tree',
    x = NULL,
    width = width,
    height = height,
    package = 'heattree',
    elementId = 'heat_tree_widget'
  )
}

#' Shiny bindings for heat_tree
#'
#' Output and render functions for using heat_tree within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a heat_tree
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name heat_tree-shiny
#'
#' @export
heat_treeOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'heat_tree', width, height, package = 'heattree')
}

#' @rdname heat_tree-shiny
#' @export
renderheat_tree <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, heat_treeOutput, env, quoted = TRUE)
}
