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
 
##########################################################
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
 
 ########################################################
