install.packages("rgdal")
install.packages("rgeos")
install.packages("sp")
install.packages("raster")
#install.packages("maptools")
library(sp)     #  vector data
library(raster) #  grid data
library(rgdal)  # input/output, coordinate systems
library(rgeos)  # geometric calculations on vector data
library(rgdal)

#library(maptools)
##################################################################
map <- getData('GADM',country='IRL', level=0)
projection(map)
# [1] "+proj=longlat +datum=WGS84"
plot(map)

newproj <- "+proj=aea +lat_1=20 ... +ellps=WGS84 +units=km"
map <- spTransform(map,CRS(newproj))
gArea(map)

polylist <- lapply(1:421,
                    function(i) Polygons(list(map@polygons[[1]]@Polygons[[i]]),i) )
map <- SpatialPolygons(polylist,proj4string=CRS(newproj))

map.areas <- sapply(1:421, function(i) gArea(map[i,]))
df <- data.frame(island=NA, area=map.areas)
map <- SpatialPolygonsDataFrame(map, df)

map <- map[order(-map$area),]
coastline <- map[1,]
islands <- map[2:421,]
##############################
#Vector example: soil map of world
# ESRI shape-file from fao.org

soils  <- readShapePoly("DSMW")

# soils <- readOGR("~/DSMW/", "DSMW") #read

projection(soils) <- "+proj=longlat +datum=WGS84"
dim(soils@data)
#[1] 34112 12
soils@data[5000:5002,]
############################
# Black Earth Soils

blackearth <- subset(soils, substr(DOMSOI,1,1) %in% c("C","K"))
blackearth <- gUnaryUnion(blackearth)