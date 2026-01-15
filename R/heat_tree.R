#' <Add Title>
#'
#' <Add Description>
#'
#' @param df dataframe
#' @export
df_to_tsv <- function(df) {
  paste(
    c(paste(colnames(df), collapse = "\t"),
    apply(df, 1, function(row) paste(row, collapse = "\t"))),
    collapse = "\n"
  )
}


#' @param tree One or more trees to plot. Can be a raw newick-formatted string,
#'   a `phylo` object, or a list of such inputs. If a list is provided, its
#'   names will be used to name trees.
#' @param metadata Metadata associated with `tree`. Can be a `data.frame` or
#'   `tibble` with a "node_id" column. If there are multiple trees (a list),
#'   then a list of table of equal length is required. If a list is provided,
#'   its names will be used to name metadata tables.
#' @param aesthetics A named character vector defining which metadata columns
#'   are initially used to color/size tree parts. If there are multiple trees (a
#'   list), then a list of equal length is required.
#' @param width Width of the widget (CSS units or number).
#' @param height Height of the widget (CSS units or number).
#' @param elementId Optional element ID for the widget.
#' @param ... Options passed to options parameter of the underlying `HeatTree.heatTree()` javascript
#'   function to modify the initial state of the widget.
#'
#' @import htmlwidgets
#'
#' @export
heat_tree <- function(tree = NULL, metadata = NULL, aesthetics = NULL, width = NULL, height = NULL, elementId = NULL, ...) {

  # Normalize tree input to a list
  validate_tree_input <- function(input) {
    if (inherits(input, "phylo")) {
      return(ape::write.tree(input))
    } else if (is.character(input) && length(input) == 1) {
      if (file.exists(input)) {
        return(paste0(readLines(input), collapse = ''))
      } else {
        return(input)
      }
    } else {
      stop(call. = FALSE, 'Invalid tree format. Must be a newick string, file path, or phylo object.')
    }
  }
  if (length(tree) == 0) {
    tree_list <- list()
  } else {
    if (inherits(tree, "phylo") || ! is.list(tree)) {
      tree <- list(tree)
    }
    tree_list <- lapply(tree, validate_tree_input)
  }

  # Get tree names
  tree_names <- names(tree_list)
  if (is.null(tree_names)) {
    tree_names <- paste0("tree ", seq_along(tree_list))
  }

  # Normalize metadata to a list
  validate_metadata_input <- function(input) {
    if (inherits(input, "data.frame")) {
      return(input)
    } else if (is.character(input) && length(input) == 1 && file.exists(input)) {
      if (endsWith(input, '.tsv')) {
        return(read.csv(input, sep = '\t'))
      } else if (endsWith(input, '.csv')) {
        return(read.csv(input, sep = ','))
      } else {
        stop(call. = FALSE, 'Invalid metadata format. Paths to metadata files must end in .tsv or .csv and be in the corresponding format.')
      }
    } else {
      stop(call. = FALSE, 'Invalid metadata format. Metadata must be a path to a TSV/CSV file or a data.frame/tibble.')
    }
  }
  if (length(metadata) == 0) {
    metadata_list <- vector("list", length(tree_list))
  } else {
    if (inherits(metadata, "data.frame") || ! is.list(metadata)) {
      metadata <- list(metadata)
    }
    metadata_list <- lapply(metadata, validate_metadata_input)
  }

  # Ensure metadata_list has same length as tree_list
  if (length(metadata_list) > 0 && length(metadata_list) != length(tree_list)) {
    stop("metadata list must have same length as tree list")
  }

  # Normalize aesthetics to a list
  if (is.null(aesthetics)) {
    aesthetics_list <- vector("list", length(tree_list))
  } else if (is.character(aesthetics) || (is.list(aesthetics) && !is.null(names(aesthetics)) && all(sapply(aesthetics, function(x) is.character(x) && length(x) == 1)))) {
    # Single named vector
    aesthetics_list <- list(aesthetics)
  } else if (is.list(aesthetics)) {
    aesthetics_list <- aesthetics
  } else {
    stop("aesthetics must be a named character vector or list of such vectors")
  }

  # Ensure aesthetics_list has same length as tree_list
  if (length(aesthetics_list) > 0 && length(aesthetics_list) != length(tree_list)) {
    stop("aesthetics list must have same length as tree list")
  }

  # Build tree data structure for JavaScript
  trees_data <- lapply(seq_along(tree_list), function(i) {
    tree_obj <- list(
      name = tree_names[i],
      newick = tree_list[[i]]
    )

    # Add metadata if present
    if (length(metadata_list) >= i && !is.null(metadata_list[[i]])) {
      metadata_df <- metadata_list[[i]]
      metadata_names <- names(metadata_list)
      metadata_name <- if (!is.null(metadata_names) && nchar(metadata_names[i]) > 0) {
        metadata_names[i]
      } else {
        paste0("metadata ", i)
      }

      # Convert data frame to TSV format
      metadata_tsv <- df_to_tsv(metadata_df)

      tree_obj$metadata <- list(
        list(
          name = metadata_name,
          data = metadata_tsv
        )
      )
    }

    # Add aesthetics if present
    if (length(aesthetics_list) >= i && !is.null(aesthetics_list[[i]])) {
      tree_obj$aesthetics <- as.list(aesthetics_list[[i]])
    }

    tree_obj
  })

  # Collect additional options
  options <- list(...)

  # Create widget data
  x <- list(
    trees = trees_data,
    options = options
  )

  createWidget(
    name = 'heat_tree',
    x = x,
    width = width,
    height = height,
    package = 'heattree',
    elementId = elementId
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
