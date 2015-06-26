# epiwidgets
A collection of htmlwidgets handy for epidemiology, etc.

Since this package is not yet on CRAN, to install, use:

```
devtools::install_github("sdwfrost/epiwidgets")
```

To use:

```
library(epiwidgets)
```

## ```treewidget```

This is an interactive phylogeny viewer based on the enviable skills of @spond and @stevenweaver.

To test:

```
nwk <- "(((EELA:0.150276,CONGERA:0.213019):0.230956,(EELB:0.263487,CONGERB:0.202633):0.246917):0.094785,((CAVEFISH:0.451027,(GOLDFISH:0.340495,ZEBRAFISH:0.390163):0.220565):0.067778,((((((NSAM:0.008113,NARG:0.014065):0.052991,SPUN:0.061003,(SMIC:0.027806,SDIA:0.015298,SXAN:0.046873):0.046977):0.009822,(NAUR:0.081298,(SSPI:0.023876,STIE:0.013652):0.058179):0.091775):0.073346,(MVIO:0.012271,MBER:0.039798):0.178835):0.147992,((BFNKILLIFISH:0.317455,(ONIL:0.029217,XCAU:0.084388):0.201166):0.055908,THORNYHEAD:0.252481):0.061905):0.157214,LAMPFISH:0.717196,((SCABBARDA:0.189684,SCABBARDB:0.362015):0.282263,((VIPERFISH:0.318217,BLACKDRAGON:0.109912):0.123642,LOOSEJAW:0.397100):0.287152):0.140663):0.206729):0.222485,(COELACANTH:0.558103,((CLAWEDFROG:0.441842,SALAMANDER:0.299607):0.135307,((CHAMELEON:0.771665,((PIGEON:0.150909,CHICKEN:0.172733):0.082163,ZEBRAFINCH:0.099172):0.272338):0.014055,((BOVINE:0.167569,DOLPHIN:0.157450):0.104783,ELEPHANT:0.166557):0.367205):0.050892):0.114731):0.295021)"
treewidget(nwk,browser=FALSE)
```

A standalone version can be found in the ```inst/standalone``` folder.

## ```packwidget```

In many viral studies, taking a phylogeny and making clusters of closely related taxa (basically OTUs) is a big thing. Here is a basic interactive plot that packs circles with a given radius belonging to several different clusters, based on the work of @mbostock.

```
r <- rpois(20,mean=5)
cl <- rep(seq(1,2),each=10)
packwidget(r,cl,browser=FALSE)
```

## matrixcube

This is the beginnings of a viewer to visualize contacts between individuals at different times, a bit like in [Cubix](http://www.aviz.fr/cubix). This is based heavily on the 3D scatterplot example from [```rthreejs```](https://github.com/bwlewis/rthreejs) by @bwlewis. 

```
cf <- c("a", "b", "a", "c", "d")
ct <- c("b", "c", "c", "d", "b")
nodes <- sort(unique(c(cf,ct)))
x <- match(cf,nodes)
y <- match(ct,nodes)
z <- c(1, 2, 3, 4, 5)
matrixcube(x,y,z,axis.labels=c("Ego","Alter","Onset"),tick.labels=list(nodes,nodes,sort(unique(z))))
```