#################################################################
#
# PointGridOverlay() - NCEAS R Use Case Function
# Demonstration R script overlays points from ESRI Shape File
# over a satellite image (stored as a GeoTiff file), assigns
# the contents of underlying image pixel cell to each point,
# and writes the 'augmented' points to a new Shape File.
#
# Inputs: Satellite Images (Geotiff format): MODIS Surface Temperature
#                                            image covering the Hawaiian Islands.
#                                            Images in Geographic and Albers 
#                                            Equal Area projection are used.                                            
#
#         Point 'Locations of Interest': Ground points, in ESRI Shape file format, to
#                                        which scientist wishes to assign MODIS 
#                                        surface temperatures.
#         
# Outputs: 
#
#         Augmented Point Files:         Point files with assigned surface temperatures
#                                        contained as 'new' attribute columns.
# 
#  Author: Rick Reeves, NCEAS Scientific Programmer
#          May 3, 2010
#          National Center for Ecological Analysis and Synthesis 
#          http://www.nceas.ucsb.edu
# 
#################################################################
PointGridOverlay <- function()
{
   require(rgdal) # rgdal packages depends on sp pagckage,
                  # which is therefore automatically loaded.
#
# read point and raster files, in the same spatial frame of reference.
#
   inPoints <- readOGR(".","SamplePointsGeogProj")

# get 300 randomly selected points from input data set 
#   ss = sample(c(1:length(inPoints@data[,1])),300) 
#   pointSubset = inPoints[ss,]

   inGrid   <- readGDAL("SatImageGeogProj.tif")
   
# Want ocean to be black, land areas grey levels
# Define a greyscale for displaying the image
# Measure nonzero image range to get # grey levels;
# breakpoints map image values to grey levels.
   
   nonZero = (inGrid@data>0)
   minMax = range(inGrid@data[nonZero])  
   nColors = diff(minMax)
   greyMap = grey(0:nColors / nColors)
   breakPts = c(0,minMax[1]:minMax[2])

# display image with custom grey scale, 
# with point set overlay

   image(inGrid, col=greyMap, breaks=breakPts)
   plot(inPoints,add=TRUE,pch=20,col="green")             

# perform the point overlay

   PointsWithTempsGP = overlay(inGrid,inPoints)

# Add a suitable name to the added data column

   names(PointsWithTempsGP) <- "SurfTemp"

# write a new point shape file with the assignment as a NEW column attribute
# note: we use writeOGR because it will write the projection attribute
# into a .prj file. maptools/writeShapePoints() does not do so.

   writeOGR(PointsWithTempsGP,".","PointsWithTempsGP",driver="ESRI Shapefile")

# Create and write a simplified Comma Separated Value (CSV) file with Longitude/Longitude/Temperature

   tempPointsGP_CSV = data.frame(cbind(coordinates(PointsWithTempsGP),PointsWithTempsGP$SurfTemp))
   names(tempPointsGP_CSV) = c("Longitude","Latitude","SurfT_C")
   write.csv(tempPointsGP_CSV,"PointsWithTempsGP_CSV.csv",row.names=FALSE)

# Finally, repeat the process with a satellite image whose
# reference frame is the Albers Equal Area projection - reproject
# the point file into the Albers projection before
# performing the overlay operation.
    
   inGridAlbers   <- readGDAL("SatImageAlbersEqualArea.tif")   
   projStringAlbers <- proj4string(inGridAlbers)
   inPointsAlbers <- spTransform(inPoints, CRS=CRS(projStringAlbers))
   pointsWithTempsAE = overlay(inGridAlbers,inPointsAlbers)

# Display the Albers image as a 'pseudo-color' image:
# create custom color map after removing NAs from image

   NAs = (is.na(inGridAlbers@data)) 
   inGridAlbers@data[NAs] = 0      
   nonZero = (inGridAlbers@data>0)
   
   minMax = range(inGridAlbers@data[nonZero])  
   nColors = diff(minMax)
   colorMap = topo.colors(nColors+1)
   breakPts = c(0,minMax[1]:minMax[2])
   
   message("Press any key to see color image...")  
   browser() 
   dev.new()
   image(inGridAlbers, col=colorMap, breaks=breakPts)
   plot(pointsWithTempsAE,add=TRUE,pch=20,col="red")                
       
   names(pointsWithTempsAE) <- "SurfTemp"    
   writeOGR(pointsWithTempsAE,".","pointsWithTempsAE",driver="ESRI Shapefile")
   message("Done. hit key to erase maps")  
   browser()     
   graphics.off() 
}