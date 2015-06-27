#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
packwidget <- function(radius, cluster, width = NULL, height = NULL, browser = FALSE) {

  # forward options using x
  x = data.frame(
    radius=radius, cluster=cluster
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
