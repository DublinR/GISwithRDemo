install.packages("GEOmap")
library(GEOmap)
#############################################################

data(worldmap); data(namer.bdy);data(namer.riv)
plotGEOmap(worldmap)
plotGEOmap(namer.bdy , add=TRUE)
plotGEOmap(namer.riv , add=TRUE)
plotGEOmap(namer.riv , add=TRUE)

##############################################################
data(cosomap); data(faults); data(hiways) ; data(owens)
##
proj = cosomap$PROJ
plotGEOmapXY(cosomap, PROJ=proj, add=FALSE, ann=FALSE, axes=FALSE)
plotGEOmapXY(hiways, PROJ=proj, add=TRUE, ann=FALSE, axes=FALSE)
plotGEOmapXY(owens, PROJ=proj, add=TRUE, ann=FALSE, axes=FALSE)
plotGEOmapXY(faults, PROJ=proj, add=TRUE, ann=FALSE, axes=FALSE)

#############################################################
data(fujitopo)
data(japmap)
PLOC=list(LON=range(fujitopo$lon), x=range(fujitopo$lon), LAT=range(fujitopo$lat), y=range(fujitopo$lat))

#### with projectionplotGEOmap(japmap, add=FALSE)

PROJ = setPROJ(type=2, LAT0=mean(PLOC$y) , LON0=mean(PLOC$x) )

plotGEOmapXY(japmap, PROJ=PROJ, LIM=c(min(PLOC$LON), min(PLOC$LAT),
max(PLOC$LON), max(PLOC$LAT)), add=FALSE)
xy = GLOB.XY(fujitopo$lat, fujitopo$lon, PROJ)

points(xy$x, xy$y, pch=".", col="pink")
points(xy$x, xy$y, pch=".", col="pink")

#############################################################

data(kammap)
plotGEOmap(kammap)
str(kammap)
class(kammap)
