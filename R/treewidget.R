#' treewidget Phylogeny widget
#'
#' An interactive phylogeny viewer using D3.js, based on phylotree.js. Just supply
#' a \code{Newick} string or \code{phylo} data as the parameter.
#' 
#' @param nwk Newick string or \code{phylo} from the \code{\link[ape]{ape}} package.
#' @param width Integer in px to override the default width. The default width fills the browser window.
#' @param height Integer in px to override the default height. The default height fills the browser window.
#' 
#' @note
#' This displays a phylogeny in a browser window; by default, the viewer is disabled.
#' 
#' @references
#' \code{phylotree.js} \url{http://github.com/veg/phylotree.js}
#' 
#' @examples
#' \dontrun{
#' # A stand-alone example
#' library(ape)
#' data(bird.orders)
#' treewidget(bird.orders)
#' }
#' 
#' @import htmlwidgets
#' @export
treewidget <- function(nwk, width = NULL, height = NULL, browser = FALSE) {

  # try to convert if not character (assuming not Newick)
  if(class(nwk) %in% c("phylo","multiPhylo")){
    warning( "attempting conversion to Newick format", call. = F)
    if (requireNamespace("ape")) {
      nwk = ape::write.tree( nwk )
    } else {
      stop("If input is not a Newick string, treewidget requires ape package.  Please install ape.")
    }
  }

  # forward options using x
  x = list(
    nwk=nwk
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'treewidget',
    x,
    width = width,
    height = height,
    sizingPolicy = htmlwidgets::sizingPolicy(viewer.suppress = browser,
                                             browser.fill = TRUE,
                                             browser.padding = 0),
    package = 'epiwidgets'
  )
}

# custom htmlcontainer for treewidget
treewidget_html <- function(id, style, class, ...) {
  htmltools::tags$div(id = id, class = paste0(class, " container"), style = style,
    htmltools::HTML(
'
<!-- Brand and toggle get grouped for better mobile display -->
<div class="navbar-header">
  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
    <span class="sr-only">Toggle navigation</span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
  </button>
  <a class="navbar-brand" href="#">D3 Tree Viewer</a>
</div>

<div class="form-group navbar-form navbar-right">
  <input type="text" id="branch_filter" class="form-control" placeholder="Filter branches on">
</div>


<div class="row">
  <div class="col-md-5 navbar-right ">
      <div class="navbar-form " role="search">
           <div class="input-group">
              <span class="input-group-btn">
                  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                      Tag <span class="caret"></span>
                  </button>
                    <ul class="dropdown-menu" id="selection_name_dropdown">
                      <li id="selection_new"><a href="#">New selection set</a></li>
                      <li id="selection_delete" class="disabled" data-original-title="" title=""><a href="#">Delete selection set</a></li>
                      <li id="selection_rename"><a href="#">Rename selection set</a></li>
                      <li class="divider"></li>
                   <li class="selection_set"><a href="#" style="color: rgb(31, 119, 180);">Foreground</a></li></ul>
              </span>

              <input type="text" class="form-control" value="Foreground" id="selection_name_box" disabled="" style="color: rgb(31, 119, 180);">

              <span class="input-group-btn" id="save_selection_name" style="display: none">
                  <button type="button" class="btn btn-default" id="cancel_selection_button">
                      Cancel
                  </button>
                  <button type="button" class="btn btn-default" id="save_selection_button">
                      Save
                  </button>
              </span>
              <span class="input-group-btn">
                  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">Selection <span class="caret"></span></button>
                    <ul class="dropdown-menu">
                      <li><a href="#" id="filter_add">Add filtered nodes to selection</a></li>
                      <li><a href="#" id="filter_remove">Remove filtered nodes from selection</a></li>
                      <li class="divider"></li>
                      <li><a href="#" id="select_all">Select all</a></li>
                      <li><a href="#" id="select_all_internal">Select all internal nodes</a></li>
                      <li><a href="#" id="select_all_leaves">Select all leaf nodes</a></li>
                      <li><a href="#" id="clear_internal">Clear all internal nodes</a></li>
                      <li><a href="#" id="clear_leaves">Clear all leaves</a></li>
                      <li><a href="#" id="select_none">Clear selection</a></li>
                      <li class="divider"></li>
                      <li><a href="#" id="mp_label">Label internal nodes using maximum parsimony</a></li>
                      <li><a href="#" id="and_label">Label internal nodes using conjunction (AND) </a></li>
                      <li><a href="#" id="or_label">Label internal nodes using disjunction (OR) </a></li>
                   </ul>
              </span>
            </div>
      </div>
  </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="btn-toolbar" role="toolbar">
          <div class="btn-group">
            <button type="button" class="btn btn-default btn-sm" id="expand_spacing" title="Expand spacing">
                <i class="fa fa-expand"></i>
            </button>
             <button type="button" class="btn btn-default btn-sm" id="compress_spacing" title="Compress spacing">
                <i class="fa fa-compress"></i>
            </button>
             <button type="button" class="btn btn-default btn-sm" id="sort_ascending" title="Sort deepest clades to the bototm">
                <i class="fa fa-sort-amount-asc"></i>
            </button>
             <button type="button" class="btn btn-default btn-sm" id="sort_descending" title="Sort deepsest clades to the top">
                <i class="fa fa-sort-amount-desc"></i>
            </button>
             <button type="button" class="btn btn-default btn-sm" id="sort_original" title="Restore original order">
                <i class="fa fa-sort"></i>
            </button>
            <button text="Save tree" id="save_tree" class="btn btn-default btn-sm" type="button">
              <i class="fa fa-floppy-o"></i>
            </button>
            <button text="Exit" id="exit_widget" class="btn btn-default btn-sm" type="button">
              <i class="fa fa-close"></i>
            </button>
          </div>
           <label class="pull-right">Selected <span class="badge" id="selected_branch_counter">0</span> and filtered <span class="badge" id="selected_filtered_counter">0</span> branches</label>
       </div>
    </div>
</div>
'      
      
    )
  )
       
}

#' treewidgetOutput Helper function for treeshiny
#' @param outputId The output identifier.
#' @param width The width of the device.
#' @param height The height of the device.
#' 
#' @seealso renderTreewidget
#' @export
treewidgetOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'treewidget', width, height, package = 'epiwidgets')
}

#' renderTreewidget Helper function for treeshiny
#' @param expr The function to be rendered
#' @param env The environment for rendering.
#' @param quoted Should the output be quoted?
#' 
#' @seealso treewidgetOutput
#' @export
renderTreewidget <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, treewidgetOutput, env, quoted = TRUE)
}

#' treeshiny A treewidget as a Shiny app
#' @param nwk Either a Newick string or a \code{phylo} or \code{multiPhylo} object.
#' 
#' @examples
#' \dontrun{
#' library(ape)
#' data(bird.orders)
#' treeshiny(bird.orders)
#' }
#' 
#' @seealso treewidget
#' @export
treeshiny <- function(nwk) {
  require(shiny)
  shinyApp(
    ui = fluidPage(
      treewidgetOutput("treewidget")
    ), 
    server = function(input, output) {
      output$phylowidget <- renderTreewidget(
        treewidget(nwk)
      )
      observe({
      if(is.null(input$close)){
        return()
      }
      else{
        if (input$close>0){
          tree <<- input$tree
          print(tree)
          stopApp()
        }
      }
      })
    }
  )
}
