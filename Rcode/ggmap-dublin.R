# journal.r-project.org/archive/2013-1/kahle-wickham.pdf

install.pacakges("ggmap")

library(ggmap)

#####################################################

geocode("Dublin")
geocode("Dublin Castle")
geocode("Temple Bar")
geocode("Sligeach")

#####################################################


# Where is the TCD Zoology Museum?

library(ggmap)
map.center <- geocode("Trinity College Dublin")

TCDZoo <- qmap(c(lon=map.center$lon, lat=map.center$lat), source="google", zoom=15)
TCDZoo + geom_point(y = 53.343159, x = -6.251797, size = 5, color = "red")

#####################################################

# maptools

library(maptools)
france <- readShapeSpatial("LIMITE_DEPARTEMENT.shp",
proj4string<-CRS("+proj=longlat"))
plot(france)

#####################################################
