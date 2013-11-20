#
# R Programmng language demonstration script: 
# Transforms GPS-collected points stored in an 
# ESRI Shapefile into UTM coordinate system,
# and creates a simple point plot. 
#
# This demo uses the rgdal and maptools packages.
# 
# Author: Rick Reeves, Scientific Programmer,
# National Center for Ecological Analysis and Synthesis (NCEAS)
# University of California, Santa Barbara 
# www.nceas.ucsb.edu
# reeves@nceas.ucsb.edu
#
# To run this example:
#  Start R 
#  > setwd("folder where this example (and the Gpoint shape file) lives")
#  > source("TransformGPSPoints.r")
#  > DemoDriver()
# Note: uncomment the line 'debug(TransformGPSPoints)'
#       in debugging mode.
#
DemoDriver <- function()
{
#
# debug() function lets you step through 
# the example using the (n)ext key to step, 
# and the (c)ontinue key to jump to the 
# next browser() statement
#                                                                             ??pl
  debug(TransformGPSPoints)
  browser()
  TransformGPSPoints()
  print("back from TransformGPSPoints")
}
TransformGPSPoints <- function()
{
#
# R code for GPS point export example. 
#
   library(maptools)
   library(rgdal)
#
# Read and create simple plot using the ASCII input point file
# The output shape file from Trimble Pathfinder is 'GPSCoordsLL.csv'
#
   PointsFromGPS <- read.csv("GPSCoordsLL.csv")
#
# Create a SpatialPointsDataFrame data object, which streamlines
# use of the plot() and spTransform() methods.
# Column 1 is the single point attribute (ID number),
# Columns 2 - 3 are Longitude (X) and Latitude (Y) components.
#
   PointsAsFrame <- SpatialPointsDataFrame(PointsFromGPS[2:3],PointsFromGPS[1])
   plot(PointsAsFrame@coords[,1:2],xlab="longitude",ylab="latitude")
   title("Points From GPS (latitude/longitude in decimal degrees")
#
# we need to set the projection string attribute to the point set to be transformed.Demo
# The following line sets the incoming point set to the closet guess to the GPS environment:
#
   proj4string(PointsAsFrame) <- CRS("+proj=longlat +datum=NAD27")
#
# perform the transformation and plot the points
#
   ThePointsUTM <- spTransform(PointsAsFrame,CRS("+proj=utm +zone=11 +datum=NAD27"))
   dev.set(1)
   plot(ThePointsUTM@coords[,1:2],axes=TRUE)
   title("Points From GPS (latitude/longitude in UTM-meters)",xlab="longitude",ylab="latitude")
#
   attributes(ThePointsUTM)
   write.table(ThePointsUTM,"CoordsUTM.csv",sep=",",row.names=FALSE,
              col.names=c("ID","easting","northing"))
#
# Done. close all Graphics devices
#  
   print("end of example. Hit key to close graphics windows.")
   browser()
#
   while(dev.cur() > 1)
   dev.off()
}