#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
odewidget <- function(width = NULL, height = NULL) {

  # forward options using x
  x = list()

  # create widget
  htmlwidgets::createWidget(
    name = 'odewidget',
    x,
    width = width,
    height = height,
    package = 'epiwidgets'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
odewidgetOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'odewidget', width, height, package = 'epiwidgets')
}

#' Widget render function for use in Shiny
#'
#' @export
renderOdewidget <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, odewidgetOutput, env, quoted = TRUE)
}
