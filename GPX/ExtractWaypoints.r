################################################################################
#
# Demonstration: Reading and converting GPS datasets 
# using the R readGPS function (maptools package)
#
# Abstract: This program reads GPX-format files containing, respectively,
#           waypoints and tracks collected with a GPS reciever, into 
#           an R Data Frame. Then, it extracts selected columns from
#           each incoming data frame (date/time/latitude/longitude/altitude)
#           into a new and separate data frame. The new data frame
#           is then written to a comma-separated-value (CSV) file.
#
# Functions: TheDriver()       - Manages execution of demonstration function  
#            ConvertGPXFiles() - Reads input .GPX- format file, writes
#                                a subset to an output .CSV file.
#
# Note: The R debug() and browser() statements are incorporated to allow the 
#       analysis to 'single-step' through the example:
#       debug()  :  Sets up single-line execution of the function.
#       browser():  Interrupts execution of function, allows inspection
#                   of R variable values.
# 
# Author: Rick Reeves, NCEAS Scientific Programmer
#
# Copyright  2008 National Center for Ecological Anslysis and Synthesis 
#            All Rights Reserved
# Intended for use by the scientific community
################################################################################

TheDriver <-function()
{
   library(maptools)
#
# debug(): single-step execution begins here.
#
   debug(ConvertGPXFiles)
#   setwd("C:/Projects/Condit/GPSData2008")
   setwd("C:/Projects/scicomp/NewSite/UseCases/ReadGPXFormatGPSData")
#
# convert a file containing Waypoints
#                                    
# browser()
   ConvertGPXFiles("SampleWaypointsOnlyNoOutliers.gpx","SampleWaypointsOut.csv","w")
#
# Plot the waypoints   
#                                         
   plot(dfWayptForPlotting@coords[,1:2],type="p",xlab="longitude",ylab="latitude")
   title("Waypoints from GPX-format GPS file")
#                                                                                                
# convert a file containing Tracks
#   
#  print(sprintf("Convert tracks file..."))
#browser()
  ConvertGPXFiles("SampleTracksOnly.gpx","SampleTracksOut.csv","t")
#
# Plot the track. Note: with the default form (below), plot axes do not display.   
#   plot(sldfTracksForPlotting,xlab="longitude",ylab="latitude",type="l") 
#
# To plot x and y axes, 'deconstruct' the # x and y coordinates:
# 'embedded' in the SpatialLinesDataFrame. Thus the syntax:
#
  print(sprintf("Plot tracks/waypoints together..."))
#browser()
   plot(sldfTracksForPlotting@lines[[1]]@Lines[[1]]@coords[,1],
        sldfTracksForPlotting@lines[[1]]@Lines[[1]]@coords[,2],
        type="l",xlab="longitude",ylab="latitude",add=TRUE)
   points(dfWayptForPlotting@coords[,1:2],type="p",col="red",pch=19)        
   title("GPX/GPS Tracks (black) | Waypoints (red)")          
#   
  print(sprintf("done with program"))
#  browser()
}
#
# Routine ConvertGPXFiles demonstrates 1) extraction of GPS data 
# stored in the standard GPX format into an R data frame,
# using the R readGPS function; 2) extraction of key fields
# (Date/Time, Latitude/Longitude, Elevation) from the initial 
# data frame into a new data frame.
#
# function arguments: 
# 
#     inGPSFile      (string): Input GPX file name
#     outConvertFile (string): Output CSV file name
#     FileType       (string): Flag indicates input
#                     file data type: "w" for waypoints,
#                                     "t" for tracks.
#
ConvertGPXFiles <- function(inGPSFile,outConvertFile,FileType) 
{
#   browser()
   if (FileType == "w")
   {                  
#
# Read the GPX-format waypoints into a Data Frame
# Note here: readGPS converts waypoints and tracks into 
# data frames with different column layouts. 
# Columns are labeled V1 - Vn)
#
       gRawWaypt = readGPS("gpx",inGPSFile,"w")
#        
# Get number of observations (waypoints)
# gRawWaypoint data frame contains the attributes that 
# we desire in the following columns:
#
# V3: Observation Date (factor)
# V4: Observation Time (factor)
# V8: Descruptive Label (string)
# V10: Latitude (numeric)
# V11: Longitude (numeric)
# V21: Elevation (Factor, includes 'M' in last character position)
#
# Let's extract these columns, convert Date, Time to strings 
# and elevation to numeric format, and construct a new data frame
# containing only the columns of interest.
#
      nObs = length(gRawWaypt[,"V3"])
      sDate = as.character(gRawWaypt[,"V3"])
      sTime = as.character(gRawWaypt[,"V4"])
      sLabel = as.character(gRawWaypt[,"V9"])      
      fLat = as.numeric(gRawWaypt[,"V10"])
      fLong = as.numeric(gRawWaypt[,"V11"])
#
# compute the spatial bounding box for the waypoint set:
#
      bounds = c(range(fLong),range(fLat))
      dim(bounds) = c(2,2)
      
#
# Elevation is a factor with the letter 'M' appended.
# Remove this, and convert the elevation to numeric
# This formula extracted from the HTML help file for the R readGPS package
# 
      fAlt <- as.numeric(substring(as.character(gRawWaypt$V21),
                         1,(nchar(as.character(gRawWaypt$V21))-1)))
#
# Output data frames - One 'standard' DF for file output,
# one 'SpatialPointsDataFrame' for plotting.
#
      dfWaypoints <<- as.data.frame(cbind(sLabel,sDate,sTime,fLat,fLong,fAlt))   
      write.csv(dfWaypoints,outConvertFile)
      LatLongCoords = SpatialPoints(cbind(fLong,fLat),proj4string = CRS("+proj=longlat"))
      dfWayptForPlotting <<- SpatialPointsDataFrame(LatLongCoords,
                                           bbox=as.matrix(bounds),dfWaypoints[1])
      print(sprintf("done - waypoints"))
    }
   else if (FileType == "t")
   {   
       gRawTracks = readGPS("gpx",inGPSFile,"t")
# 
# A GPX file can include multiple tracks, known as track sequences, each
# of which contains the vertices for a single track (line)
# However, the current version of readGPS() combines all points in all 
# track sequences into a single track. This may change in the future.
# For this demonstration, we will convert these track points into a 
# SpatialLinesData Frame (with a single SpatialLines object in one 'row'
# and a single attribute - "Track_1" - attached to the track (and stored
# in a DataFrame).
# The data frame generated by readGPS for Tracks has a different layout:
#       
# V3: Latitude (numeric)                                             
# V4: Longitude (numeric)
# V14: Elevation (Factor, includes 'M' in last character position)
# <Note: Date not yet returned for Tracks by readGPS>  
#                                                           
# Let's extract these columns, convert elevation to numeric format,
# and construct a new data frame containing only the columns of interest.
#
       fLat = gRawTracks[,"V3"]
       fLong = gRawTracks[,"V4"]
#
# Elevation is a factor with the letter 'M' appended.
# Remove this, and convert the elevation to numeric
# This formula extracted from the R HTML help file for the R readGPS package
# 
       fAlt <- as.numeric(substring(as.character(gRawTracks$V14),1,
               (nchar(as.character(gRawTracks$V14))-1)))
       fMeanAlt = mean(fAlt)
#
# Store the single track that we read in a 1 row, 2 column SpatialLinesDataFrame
# with attributes: Track Name, and average elevation for the entire track
# Build the SLDF in sevaral stages: 
#
       TrackAttributes = data.frame(ID = "Track_One",Alt=fMeanAlt,stringsAsFactors=FALSE)
       LatLongCoords = SpatialPoints(cbind(fLong, fLat),proj4string = CRS("+proj=longlat"))
#
# SpatialPointsDataFrame: one attribute (altitude) per point.
#       
       dfTrackPoints <<- SpatialPointsDataFrame(LatLongCoords,data.frame(fAlt))
#
# Create SpatialLinesDF from the SpatialPointsDF.
# First, SpatialLines object:
#
       slTrackLine = Lines(list(Line(dfTrackPoints@coords)))
       slTrackLine@ID = "Track_One"
       SLPath = SpatialLines(list(slTrackLine),proj4string = CRS("+proj=longlat"))
#
# Finally, the SpatialLinesDataFrame:
# Create a global variable using the "<<-" operator, Plot this in TheDriver().
#   
       sldfTracksForPlotting <<- SpatialLinesDataFrame(SLPath,TrackAttributes,match.ID=FALSE)
#
# Write the original track points to a CSV file.
#
       write.csv(dfTrackPoints,outConvertFile)
       print(sprintf("done - tracks"))  
   }
}