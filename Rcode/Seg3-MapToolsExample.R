# Baptiste Coulmont explains on his blog how to use the R package maptools. 
# It is based on shapefile files, for example the ones offered by the French geography agency 
# IGN (at départements and communes level). 
# Some additional material like roads and railways are provided by the OpenStreetMap project. 
# For the above map, you need to dowload and dezip the files departements.shp.zip and ile-de-france.shp.zip. 
# The red dots correspond to points of interest longitude / latitude, here churches stored in a vector 
# eglises (use e.g. this to geolocalise places of interest). Then run this code from Baptiste’s tutorial

library(maptools)

france<-readShapeSpatial("departements.shp",
  proj4string=CRS("+proj=longlat"))
routesidf<-readShapeLines(
  "ile-de-france.shp/roads.shp",
  proj4string=CRS("+proj=longlat")
  )
trainsidf<-readShapeLines(
  "ile-de-france.shp/railways.shp",
  proj4string=CRS("+proj=longlat")
  )
  
plot(france,xlim=c(2.2,2.4),ylim=c(48.75,48.95),lwd=2)
plot(routesidf[routesidf$type=="secondary",],add=TRUE,lwd=2,col="lightgray")
plot(routesidf[routesidf$type=="primary",],add=TRUE,lwd=2,col="lightgray")
plot(trainsidf[trainsidf$type=="rail",],add=TRUE,lwd=1,col="burlywood3")
points(eglises$lon,eglises$lat,pch=20,col="red")
