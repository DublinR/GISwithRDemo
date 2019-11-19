# Overlays on Google map tiles in R
# Markus Loecher, Berlin School of Economics and Law (BSEL)

### RGOOGLEMAPS ###
 
library(RgoogleMaps)
 
  # get maps from Google
newmap <- GetMap(center=c(36.7,-5.9), zoom =10, destfile = "newmap.png", maptype = "satellite")
  
  # View file in your wd
  # now using bounding box instead of center coordinates:

newmap2 <- GetMap.bbox(lonR=c(-5, -6), latR=c(36, 37), destfile = "newmap2.png", maptype="terrain")    

  # try different maptypes
newmap3 <- GetMap.bbox(lonR=c(-5, -6), latR=c(36, 37), destfile =  "newmap3.png", maptype="satellite")
 
  # and plot data onto these maps, e.g. these 3 points

PlotOnStaticMap(lat = c(36.3, 35.8, 36.4), lon = c(-5.5, -5.6, -5.8), zoom= 10, cex=2, 
pch= 19, col="red", FUN = points, add=F)
 
 
