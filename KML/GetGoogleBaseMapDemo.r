###############################################################################################
#
# R Geospatial Use Case Code: GetGoogleBaseMap
#
# Demonstrates three techniques for creating Keyhole Markup Language
# (KML) files for vector and raster geospatial files within R:
#
#   kmlLine() or kmlPolygon() functions, included in maptools package,
#   to convert line and polygon shape files to SEPARATE kml files.
#   writeOGR() function, included in the rgdal package. This is the most
#   convenient and straightforward method for use in creating KML files from ESRI Shape Files.
#   ogr2ogr() function, from the open-source FWTools package, and the R system() command,
#   to convert shape files to KML format.
#
# Vector files are ESRI Shape Files containing Points, Lines, and Polygons.
#
# Raster files are GeoTIFF format files readable as R SpatialGridDataFrame objects.
#
# This is the code that appears in Use Case example on the NCEAS SciComp Web site:
#
#  http://www.nceas.ucsb.edu/scicomp/usecases/shapeFileToKML
#
# Creation Date: August, 2010
# Author: Rick Reeves, Scientific Programmer,
# National Center for Ecological Analysis and Synthesis (NCEAS)
# http://www.nceas.ucsb.edu/scicomp
###############################################################################################
GetGoogleBaseMap <- function()
{
# Demonstrates use of RgoogleMaps package to grab GoogleMaps map/image
# for user-specified geographic rectangle.

   require(RgoogleMaps)
   require(rgdal)      # required if the 'png' image file format is to be used....
   require(PBSmapping) # for PolySet type, the correct class for passing shape files to PlotPolysOnStaticMap()
   require(ReadImages) # includes read.jpeg function, used by GetMap to produce a JPEG-format output image

# Use the GetMap() function to obtain one of several GoogleMaps spatial image types:
#    Examples: "roadmap" : Highway map; "satellite" : satellite image; "terrain" : terrain image.
#    See rGoogleMaps package / GetMap() documentation for more options

# Two ways to specify the 'region of interest' for which to extract the GoogleMaps image:
# 1) Supply a square Lat/Long 'bounding box', and supply this to the GetMap.bbox function
# 2) provide a Lat/Long pair defining the desired image 'center point', and 'zoom factor'
# (image magnification).

# Note: As of August 2010, the maximum map image size returned by the Google server is 640 X 640.
# As necessary, GetMap() routines will adjust the image magnification factor in concert with
# the user's spatial coordinates to deliver the most detailed ('zoomed') map image within the
# 640 x 480 image size constraint. Two examples presented here

# First, use GoogleMap qbbox() method to generate a bounding box from three user-specified lat/long
# coordinate pairs. Then, extract a map by supplying this bounding box to GetMap.bbox() routine.

# Using PBSmapping routine, read the ESRI polygon Shape File that we wish to overlay on the Google image

   polyShpFile="./FiveNWStatesCounties.shp"
   shpPolySet=importShapefile(polyShpFile,projection="LL");
   pointShpFile="./MyCountyCentroidsGP.shp"
   shpPointSet=importShapefile(pointShpFile,projection="LL");

# Specify our 'study area' (Northwestern USA) Lower Left-Hand and Upper Right-Hand corner coords in a vector.

   lats = c(40.9,49.0)
   lons = c(-125.0, -104.0)
   centerPt = c(mean(lats),mean(lons))
   boundBox = qbbox(lat = lats,lon = lons)

   mapFromBbox = GetMap.bbox(boundBox$lonR,boundBox$latR,maptype="terrain",destfile="MapFromBbox.png")
   
# Display the GoogleMaps 'base map', then overlay the polygons (outlines ONLY, 'col=0') on the map
   
   PlotPolysOnStaticMap(mapFromBbox, shpPolySet,destfile="c:/temp/MapFromBboxAnno.png", lwd=1.5, col=0, add = F)

# Second, compute the maximum (most detailed) zoom level that will contain user-specified point set;
# use this in conjunction with the computed 'center point' of the user points to extract the
# desired map using GetMap() function.

   zoomFact = min(MaxZoom(range(lats),range(lons)))
   
   mapFromCenterPt = GetMap(center=centerPt,zoom=zoomFact,maptype="roadmap",destfile="MapFromCenterPt.jpg")

# Overlay the point set on top of the second, "roadmap" base map.
# Then, add the polygons (only) displayed on the original map.

   PlotOnStaticMap(mapFromCenterPt, shpPointSet$Y,shpPointSet$X, col="red",pch='*', add = F)
   PlotPolysOnStaticMap(mapFromCenterPt,shpPolySet, lwd=1.5, col=rgb(0,0,0,0), add = T)

# August 2010: For this version of RgoogleMaps, here is the method for writing the new map to a file
# (until the destfile=fn argument is implemented).
   
   png("./MapFromBbox.png", 640, 640);
   PlotOnStaticMap(mapFromCenterPt, shpPointSet$Y,shpPointSet$X, col="red",pch='*', add = F)
   PlotPolysOnStaticMap(mapFromCenterPt,shpPolySet, lwd=1.5, col=rgb(0,0,0,0), add = T)
   dev.off() 
}



