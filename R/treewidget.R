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
treewidget <- function(nwk, width = NULL, height = NULL) {

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
    sizingPolicy = htmlwidgets::sizingPolicy(viewer.suppress = FALSE,
                                             browser.fill = TRUE,
                                             browser.padding = 0),
    package = 'epiwidgets'
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
