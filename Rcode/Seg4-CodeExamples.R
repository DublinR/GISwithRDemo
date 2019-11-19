#http://www.molecularecologist.com/2012/09/making-maps-with-r/


install.packages("maps","mapdata","scales","maptools")

####################################################

library(maps)
library(mapdata)
library(maptools)  #for shapefiles
library(scales)  #for transparency

####################################################

NewMap <- map("worldHires","Canada", xlim=c(-141,-53), ylim=c(40,85), 
 col="lightblue", fill=TRUE)

####################################################

#layer of data for species range
pcontorta <- readShapePoly("pinucont.shp")   

#my data for sampling sites, contains a column of "lat" and a column of "lon" with GPS points in decimal degrees
samps <- read.csv("FieldSamples.csv") 

#plot the region of Canada I want
map("worldHires","Canada", xlim=c(-140,-110),ylim=c(48,64), col="gray90", fill=TRUE)  

#add the adjacent parts of the US; can't forget my homeland
map("worldHires","usa", xlim=c(-140,-110),ylim=c(48,64), col="gray95", fill=TRUE, add=TRUE)  


#plot the species range
plot(pcontorta, add=TRUE, xlim=c(-140,-110),ylim=c(48,64), col=alpha("darkgreen", 0.6), 
border=FALSE)  

#plot my sample sites
points(samps$lon, samps$lat, pch=19, col="red", cex=0.5)  
####################################################

library(RgoogleMaps)

lat <- c(48,64) #define our map's ylim

lon <- c(-140,-110) #define our map's xlim

center = c(mean(lat), mean(lon))  #tell what point to center on

zoom <- 5  #zoom: 1 = furthest out (entire globe), larger numbers = closer in

terrmap <- GetMap(center=center, zoom=zoom, maptype= "terrain", destfile = "terrain.png") 
# lots of visual options, just like 
# google maps: maptype = c("roadmap", "mobile", "satellite",
# "terrain", "hybrid", "mapmaker-roadmap", "mapmaker-hybrid")
####################################################
