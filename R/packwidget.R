#' packwidget
#'
#' A widget for packed circles
#'
#' @import htmlwidgets
#'
#' @export
packwidget <- function(radius, cluster, col = NULL, width = NULL, height = NULL, browser = FALSE) {

  if(is.null(col)){
      hues <- seq(15,375,length=max(cluster)+1)
      col <- hcl(h=hues,l=65,c=100)[1:max(cluster)]
  }
  # forward options using x
  x = list(
    properties = data.frame(radius=radius, cluster=cluster-1), col=col
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'packwidget',
    x,
    width = width,
    height = height,
    sizingPolicy = htmlwidgets::sizingPolicy(viewer.suppress = browser,
                                             browser.fill = TRUE,
                                             browser.padding = 0),
    package = 'epiwidgets'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
packwidgetOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'packwidget', width, height, package = 'epiwidgets')
}

#' Widget render function for use in Shiny
#'
#' @export
renderPackwidget <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, packwidgetOutput, env, quoted = TRUE)
}
