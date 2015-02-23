#' matrixcube Three.js matrixcube widget.
#'
#' Based on the 3D scatterplot widget from rthreejs.
#' @export
matrixcube <- function(
  x, y, z,
  height = NULL,
  width = NULL,
  axis = TRUE,
  axis.labels = NULL,
  tick.labels = NULL,
  color = "steelblue",
  stroke = "black",
  size = 1,
  flip.time = FALSE,
  grid = TRUE,
  renderer = c("auto","canvas","webgl", "webgl-buffered"),
  pch)
{
  # validate input
  if(!missing(y) && !missing(z)) x = cbind(x=x,y=y,z=z)
  if(ncol(x)!=3) stop("x must be a three column matrix")
  if(is.data.frame(x)) x = as.matrix(x)
  if(!is.matrix(x)) stop("x must be a three column matrix")
  if(missing(pch)) pch = texture(system.file("images/disc.png",package="epiwidgets"))
  if(missing(renderer) && nrow(x)>10000)
  {
    renderer = "webgl-buffered"
  } else
  {
    renderer = match.arg(renderer)
  } 

  # Strip alpha channel from colors
  i = grep("^#",color)
  if(length(i)>0)
  {
    j = nchar(color[i])>7
    if(any(j))
    { 
      color[i][j] = substr(color[i][j],1,7)
    }
  }

  # create options
  options = as.list(environment())[-1]
  # javascript does not like dots in names
  i = grep("\\.",names(options))
  if(length(i)>0) names(options)[i] = gsub("\\.","",names(options)[i])

  # re-order so z points up as expected.
  x = x[,c(1,3,2)]

  # Our s3d.js Javascript code assumes a coordinate system in the unit box.
  # Scale x to fit in there.
  n = nrow(x)
  mn = apply(x,2,min)
  mx = apply(x,2,max)
  x = (x - rep(mn, each=n))/(rep(mx - mn, each=n))
  if(flip.time) x[,2] = 1-x[,2]
  
  # convert matrix to a JSON array required by scatterplotThree.js and strip
  # them (required by s3d.js)
  #if(length(colnames(x))==3) options$labels = colnames(x)
  options$labels <- axis.labels[c(1,3,2)]
  colnames(x)=c()
  x = toJSON(t(signif(x,4)))

  num.ticks <- c(length(tick.labels[1]),length(tick.labels)[2],length(tick.labels)[3])
  # Ticks
  if(!is.null(num.ticks))
  {
    if(length(num.ticks)!=3) stop("num.ticks must have length 3")
   
    t1 = seq(1,length(tick.labels[[1]]))
    p1 = (t1 - mn[1])/(mx[1] - mn[1])
    t2 = tick.labels[[3]]
    p2 = (t2 - mn[2])/(mx[2] - mn[2])
    t3 = seq(1,length(tick.labels[[2]]))
    p3 = (t3 - mn[3])/(mx[3] - mn[3])
    if(flip.time) t2 = t2[length(t2):1]
    
    options$xticklab = tick.labels[[1]]
    options$yticklab = sprintf("%.2f",t2)
    options$zticklab = tick.labels[[2]]
    options$xtick = p1
    options$ytick = p2
    options$ztick = p3

  }

  # create widget
  htmlwidgets::createWidget(
      name = "matrixcube",
      x = list(data=x, options=options, pch=pch),
               width = width,
               height = height,
               htmlwidgets::sizingPolicy(padding = 0, browser.fill = TRUE),
               package = "epiwidgets")
}

#' @export
matrixcubeOutput <- function(outputId, width = "100%", height = "500px") {
    shinyWidgetOutput(outputId, "matrixcube", width, height,
                        package = "epiwidgets")
}

#' @export
renderMatrixcube <- function(expr, env = parent.frame(), quoted = FALSE) {
    if (!quoted) { expr <- substitute(expr) } # force quoted
    shinyRenderWidget(expr, matrixcubeOutput, env, quoted = TRUE)
}
