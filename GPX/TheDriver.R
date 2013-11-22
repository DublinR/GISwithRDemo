TheDriver <-function()
{
  library(maptools)
  #
  # debug(): single-step execution begins here.
  #
  # debug(ConvertGPXFiles)
  # setwd("C:/Projects/scicomp/NewSite/UseCases/ReadGPXFormatGPSData")
  #
  # convert a file containing Waypoints
  # 
  # browser() - execution stops here, waiting for a keystroke...
  #
  ConvertGPXFiles("SampleWaypointsOnlyNoOutliers.gpx","SampleWaypointsOut.csv","w")
  ##################################################
  # Plot the waypoints 
  # 
  plot(dfWayptForPlotting@coords[,1:2],type="p",xlab="longitude",ylab="latitude")
  title("Waypoints from GPX-format GPS file")
  
  # 
  # convert a file containing Tracks
  # print(sprintf("Convert tracks file..."))
  #browser()
  
  ConvertGPXFiles("SampleTracksOnly.gpx","SampleTracksOut.csv","t")
  
  #
  
  
  # Plot the track. Note: with the default form (below), plot axes do not display. 
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
  # browser()
}