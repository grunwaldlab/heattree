#' @keywords internal
format_tip_labels <- function(text) {

  word_counts <- vapply(strsplit(text, split = '_+'), length, FUN.VALUE = numeric(1))
  if (mean(word_counts) <= 3) {
    text <- gsub(text, pattern = '_+', replacement = ' ')
  }

  char_frequency <- table(unlist(strsplit(text, split = '')))
  char_frequency <- char_frequency[names(char_frequency) != ' ']
  is_alpha <- grepl(names(char_frequency), pattern = '[a-zA-Z]')
  alpha_frequency <- sum(char_frequency[is_alpha]) / sum(char_frequency)
  all_start_lowercase <- all(grepl(pattern = '[a-z]', substr(text, 1, 1)))
  if (alpha_frequency > 0.9 && all_start_lowercase) {
    text <- paste0(toupper(substr(text, 1, 1)), substr(text, 2, nchar(text)))
  }

  return(text)
}

#' @keywords internal
df_to_tsv <- function(df, na_value = 'NA', row_name_col = 'row_names') {
  # Convert factors to character vectors
  is_factor <- vapply(df, is.factor, FUN.VALUE = logical(1))
  df[is_factor] <- lapply(df[is_factor], as.character)

  # Convert NAs into the specified text value
  df[] <- lapply(df, function(x) {
    x[is.na(x)] <- na_value
    return(x)
  })

  # Convert row names to a column if present
  if (! all(seq_len(nrow(df)) == rownames(df))) {
    if (row_name_col %in% colnames(df)) {
      row_name_col <- make.unique(c(row_name_col, colnames(df)))[1]
    }
    df[[row_name_col]] <- rownames(df)
    rownames(df) <- NULL
  }

  paste(
    c(paste(colnames(df), collapse = "\t"),
    apply(df, 1, function(row) paste(row, collapse = "\t"))),
    collapse = "\n"
  )
}


#' Create an interactive phylogenetic tree
#'
#' Create an interactive phylogenetic tree using the javascript [heat-tree](https://github.com/grunwaldlab/heat-tree) package
#'
#' @param tree One or more trees to plot. Can be a raw newick-formatted string,
#'   a `phylo` object, or a list of such inputs. If a list is provided, its
#'   names will be used to name trees.
#' @param metadata Metadata associated with `tree`. Can be a `data.frame` or
#'   `tibble` with a column containing IDs matching the tree labels. The ID
#'   column is detected automatically. If there are multiple trees (a list),
#'   then a list of tables of equal length is required. If a list is provided,
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
#' @return An htmlwidget object of class `heat_tree` that renders an interactive
#'   phylogenetic tree visualization. The object contains:
#'   * `x`: A list with tree data and options passed to JavaScript
#'   * `width`, `height`: Dimensions of the widget
#'   * `elementId`: Optional DOM element ID
#'
#'   The widget can be displayed in R Markdown, Quarto, or using and IDE like RStudio.
#'
#' @examples
#' # Create an empty tree viewer for loading data interactively
#' heat_tree()
#'
#' # Create a tree viewer with example data included with the package
#' data(weisberg_2020_metadata)
#' data(weisberg_2020_mlsa)
#' heat_tree(
#'   tree = weisberg_2020_mlsa,
#'   metadata = weisberg_2020_metadata,
#'   aesthetics = c(tipLabelColor = 'host_type')
#' )
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
        return(utils::read.csv(input, sep = '\t'))
      } else if (endsWith(input, '.csv')) {
        return(utils::read.csv(input, sep = ','))
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

  # Check that columns defined in aesthetics are present in the metadata
  for (i in seq_along(aesthetics_list)) {
    for (column in aesthetics_list[[i]]) {
      if (! column %in% colnames(metadata_list[[i]])) {
        stop(paste0('The column "', column, '" does not exist in the associated metadata.'), call. = FALSE)
      }
    }
  }

  # Build tree data structure for JavaScript
  trees_data <- lapply(seq_along(tree_list), function(i) {
    tree_obj <- list(
      name = tree_names[i],
      tree = tree_list[[i]]
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

      # Convert row names to a column if present. TODO: remove once the JS `heat-tree` package does this via aesthetic settings
      row_name_col <- 'row_names'
      if (! all(seq_len(nrow(metadata_df)) == rownames(metadata_df))) {
        if (row_name_col %in% colnames(metadata_df)) {
          row_name_col <- make.unique(c(row_name_col, colnames(metadata_df)))[1]
        }
        metadata_df[[row_name_col]] <- rownames(metadata_df)
        rownames(metadata_df) <- NULL

        # Format default tip labels
        if (! 'tipLabelText' %in% aesthetics_list[[i]]) {
          row_names_formatted_col <- 'formatted_ids'
          metadata_df[[row_names_formatted_col]] <- format_tip_labels(metadata_df[[row_name_col]])
          aesthetics_list[[i]]['tipLabelText'] <- row_names_formatted_col
        }
      }

      # Convert data frame to TSV format
      metadata_tsv <- df_to_tsv(metadata_df, na_value = '')

      tree_obj$metadata <- list(
        list(
          name = metadata_name,
          data = metadata_tsv
        )
      )
    }

    # Add aesthetics if present
    if (length(aesthetics_list) >= i && ! is.null(aesthetics_list[[i]])) {
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

  # Determine sizing policy based on runtime environment
  in_rstudio <- Sys.getenv("RSTUDIO") != ''
  knitr_out_format <- knitr::opts_knit$get('out.format')
  knitr_pandoc_to <- knitr::opts_knit$get('rmarkdown.pandoc.to')
  in_knitr <- ! is.null(knitr_out_format)
  in_knitr_markdown <- in_knitr && knitr_out_format %in% c('markdown', 'gfm', 'github_document') && ! startsWith(knitr_pandoc_to, 'html')
  in_knitr_html <- in_knitr && knitr::is_html_output() && !in_knitr_markdown
  if (interactive()) {
    if (!in_rstudio && !in_knitr_html && is.null(width) && is.null(height)) {
      sizing <- htmlwidgets::sizingPolicy(
        browser.fill = TRUE,
        browser.padding = 10,
        defaultWidth = "100%",
        defaultHeight = "100%"
      )
    } else {
      sizing <- htmlwidgets::sizingPolicy(
        padding = 3
      )
    }
  } else {
    if (in_knitr_markdown) {
      sizing <- htmlwidgets::sizingPolicy(
        padding = 2
      )
      if (is.null(height)) {
        height <- '100vh'
      }
      if (is.null(width)) {
        width <- 'calc(100% - 15px)'
      }
    } else {
      sizing <- htmlwidgets::sizingPolicy()
      if (is.null(height)) {
        height <- '70vh'
      }
      if (is.null(width)) {
        width <- '100%'
      }
    }
  }

  htmlwidgets::createWidget(
    name = 'heat_tree',
    x = x,
    width = width,
    height = height,
    package = 'heattree',
    elementId = elementId,
    sizingPolicy = sizing
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
#' @return
#'   `heat_treeOutput()` returns an output function that creates a Shiny UI element
#'   for displaying a heat_tree widget. Used in the UI definition of a Shiny app.
#'
#'   `renderheat_tree()` returns a render function that can be assigned to an output
#'   element in the server function of a Shiny app. It returns a Shiny render binding.
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
