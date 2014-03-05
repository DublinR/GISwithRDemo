### Basic packages ###
 
library(sp)             # classes for spatial data
library(raster)         # grids, rasters
library(rasterVis)      # raster visualisation
library(maptools)
# and their dependencies
 
 
###########################################################
 
### VISUALISATION OF GEOGRAPHICAL DATA ###
 
 
### RWORLDMAP ###
 
library(rworldmap)   # visualising (global) spatial data
 
  # examples:
  newmap <- getMap(resolution="medium", projection="none")
  plot(newmap)
 
  mapCountryData()
  mapCountryData(mapRegion="europe")
  mapGriddedData()
  mapGriddedData(mapRegion="europe")
 
 
### GOOGLEVIS ###
 
library(googleVis)    
# visualise data in a web browser using Google Visualisation API
 
  # demo(googleVis)   # run this demo to see all the possibilities
 
  # Example: plot country-level data
  data(Exports)
  View(Exports)
  Geo <- gvisGeoMap(Exports, locationvar="Country", numvar="Profit",
                    options=list(height=400, dataMode='regions'))
  plot(Geo)
  print(Geo)
  # this HTML code can be embedded in a web page (and be dynamically updated!)
 
  # Example: Plotting point data onto a google map (internet)
  data(Andrew)
  M1 <- gvisMap(Andrew, "LatLong" , "Tip", options=list(showTip=TRUE,
showLine=F, enableScrollWheel=TRUE,
                           mapType='satellite', useMapTypeControl=TRUE,
width=800,height=400))
  plot(M1)
 
 
### RGOOGLEMAPS ###
 
library(RgoogleMaps)
 
  # get maps from Google


  newmap <- GetMap(center=c(53.343159,-6.251797), zoom =10, destfile = "newmap.png",
maptype = "satellite")
  # View file in your wd
  # now using bounding box instead of center coordinates:
  newmap2 <- GetMap.bbox(lonR=c(-5, -6), latR=c(36, 37), destfile =
"newmap2.png", maptype="terrain")    # try different maptypes
  newmap3 <- GetMap.bbox(lonR=c(-5, -6), latR=c(36, 37), destfile =
"newmap3.png", maptype="satellite")
 
  # and plot data onto these maps, e.g. these 3 points
   PlotOnStaticMap(lat = c(53.3, 52.8, 53.4), lon = c(-6.5, -6.6, -6.8), zoom=
10, cex=2, pch= 19, col="red", FUN = points, add=F)
 
