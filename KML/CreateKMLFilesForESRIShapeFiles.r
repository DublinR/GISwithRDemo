############################################################################################### 
#
# R Geospatial Use Case Code: CreateKMLFilesForESRIShapeFiles
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
# Creation Date: July, 2009
# Revised: May, 2010
# Author: Rick Reeves, Scientific Programmer, 
# National Center for Ecological Analysis and Synthesis (NCEAS)
# http://www.nceas.ucsb.edu/scicomp
###############################################################################################
#
 CreateKMLFilesForESRIShapeFiles <- function()
 {

# rgdal provides readOGR() and writeOGR()
# maptools/sp provides transformation and kml translators
# PBSmapping provides polygon centroid creation function

   library(rgdal)
   library(maptools)
   library(PBSmapping)  
#
# Remember to set the current working directory to the folder into which you unpacked this archive.
#                
#  setwd("C:/Projects/GeospatialUseCasesMar2009/CreateKMLFiles/dl") #example
#
# Re-project the counties into Geographic (unprojected) space.
# Then, write the new polygons to a NEW shape file.
# 
# Read a polygon shape file, which is in a Albers Equal Area map transformation
#
   NwCountiesDF <- readOGR("FiveNWStatesCounties.shp","FiveNWStatesCounties")

# Re-project the counties into Geographic (unprojected) space.
# Then, write the new polygons to a NEW shape file.

   GpProjString <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")
  
   NwCountiesGP <- NwCountiesDF
   proj4string(NwCountiesGP) <- GpProjString
   NwCountiesGP <- spTransform(NwCountiesGP,GpProjString)
   writeOGR(NwCountiesGP,".","NwCountiesGP",driver="ESRI Shapefile")  

# Read the (unprojected) Shape File with readOGR, which captures the 
# projection information

   NwCountiesGP2 <- readOGR("NwCountiesGP.shp","NwCountiesGP")

# Special Topic: Create centroids for the Washington County polygons
                                               
#  MapPolys.ps <- SpatialPolygons2PolySet(NwCountiesGP2)
#  MapPolys.centroids <- calcCentroid(MapPolys.ps, rollup=1)
#  centroidsWPolyAttr <- cbind(MapPolys.centroids,NwCountiesGP2)
#  coordinates(centroidsWPolyAttr) <- c("X", "Y")
#  proj4string(centroidsWPolyAttr) <- GpProjString
#  centroidsWPolyAttr <- spTransform(centroidsWPolyAttr,GpProjString)  
#  writeOGR(centroidsWPolyAttr,".","NwCountiesCentroids",driver="ESRI Shapefile")  
  
# Now, we generate some KML files using the three methods: 
# 
# Method 1: KmlPolygon() / KmlLine()
# Method 2: ReadOGR() / WriteOGR()
# Method 3: ogr2ogr 'command line' utility                                          
#
# We pass ONLY the Polygons component of the SPDF to kmlPolygon, so extract it.
# Create the KML with only Idaho counties (Idaho County FIPS code: 53)
# Extract the Polygons component of the SpatialPointsDataFrame,
# as needed by the kmlToPolygon() function.
# 
# Note: May 2010 -  kmlPolygon only writes the first spatial feature 
# (with Polygon ID 0) is written to the kml file...

#  CountyPolys <- slot(NwCountiesGP[NwCountiesGP$STATEFIPS %in% c("53"),], "polygons")[[1]]  
#  kmlPolygon(CountyPolys, kmlfile="NWStateCountyPolys.kml", name="NWStateCountyPolys", col="blue", lwd=1,
#             border=1, kmlname="R Test",kmldescription="KML File:NW USA State Counties")

# Creating a KML file containing all polygons in the file using kmlPolygon
# requires some parsing of the SpatialPointsDataFrame

   sw  <- NwCountiesGP[NwCountiesGP$STATEFIPS %in% c("53"),] # extract the desired subset of SpatialPointsDataFrame
   out <- sapply(slot(sw, "polygons"), function(x) {
                 kmlPolygon(x,
                            name=as(sw, "data.frame")[slot(x, "ID"), "STATEFIPS"],     
                            col=NULL, lwd=1, border="blue", 
                            description=paste("ISO3:", slot(x, "ID")))
                                                   }
                )  # outside of 'sapply' function call
   tf <- "WashingtonStateCountyPolys.kml" ##tempfile()
   kmlFile <- file(tf, "w")
   tf
   cat(kmlPolygon(kmlname="R Test", kmldescription="<i>Hello</i>")$header,file=kmlFile, sep="\n")
   cat(unlist(out["style",]), file=kmlFile, sep="\n")
   cat(unlist(out["content",]), file=kmlFile, sep="\n")
   cat(kmlPolygon()$footer, file=kmlFile, sep="\n")
   close(kmlFile)

# ..OR, we can use the GDAL tools readOGR to convert the shapefile to KML format, and write the file  
 
   writeOGR(NwCountiesGP, "NWStateCountyPolysOGR.kml", "NWStateCountyPolysOGR", driver="KML")
   
# Creating a KML file for POINT data: The only way within R is to use GDAL / OGR utilities

   MapPolysCent <- readOGR("NwCountiesCentroids.shp","NwCountiesCentroids")
   writeOGR(MapPolysCent, "NwCountyCentroids.kml", "NwCountyCentroids.kml", driver="KML")   
 
# Next, Create a KML file for a set of LINES (streams) 
  
   NevadaStreamsGP <- readOGR("NevadaStreamsGP.shp","NevadaStreamsGP")
  
# Same issue: only first feature (with Polygon ID 0) is written, so use GDAL OGR methods

#  kmlLine(NevadaStreamsGP, kmlfile="NevadaStreamsOneFeature.kml", name="NevadaStreamsOneFeature", col="green", lwd=1,
#          kmlname="R Test",kmldescription="KML File: Nevada Streams")        

   out <- sapply(slot(NevadaStreamsGP, "lines"), function(x) {
                 kmlLine(x,
                            name=as(sw, "data.frame")[slot(x, "ID"), "GNIS_NAMEhiso"],     
                            col="green", lwd=1, 
                            description=paste("ISO3:", slot(x, "ID")))
                                                   }
                )  # outside of 'sapply' function call
   tf <- "NevadaDesertStreams.kml" ##tempfile()
   kmlFile <- file(tf, "w")
   tf
   cat(kmlLine(kmlname="R Test", kmldescription="<i>Hello</i>")$header,file=kmlFile, sep="\n")
   cat(unlist(out["style",]), file=kmlFile, sep="\n")
   cat(unlist(out["content",]), file=kmlFile, sep="\n")
   cat(kmlLine()$footer, file=kmlFile, sep="\n")
   close(kmlFile)

# OR: call to GDAL/writeOGR 

   writeOGR(NevadaStreamsGP, "NevadaDesertStreamsOGR.kml", "NevadaDesertStreams", driver="KML")			 

# Method 2.1: Use kmlOverlay() to create a KML 'wrapper' for a raster image file
# 
# Convert a floating-point DEM elevation map image 
# into a KML file complex for display with GoogleEarth.
# Begin with Digital Elevation Map Iamage, floating point elevation values, .IMG format.
# Note: The input DEM image is a .tif file, with elevations in floating point format.
# Steps: 1) Convert image to a TIFF format integer raster with pixre values > 0 < 256
#        2) Convert the TIFF file to PNG image format.
#        3) Create a GoogleEarth-compatible Spatial Grid object from the PNG image.
#        4) Use maptools/KmlOverlay() to create the KML file 'complex' for GoogleEarth display.

    DEMImg <- readGDAL("NevadaSiteDemGP.img") 
    rng =range(DEMImg$band1)
   
# Translate floating point to integer-byte

    DEMImg$band1 <- as.integer((DEMImg$band1 / rng[2]) * 256)
    writeGDAL(DEMImg,"DemByteImg.tif",type="Byte",driver="GTiff") # normalized DEM data

# Create a PNG version of our byte /Tif image
# writeGDAL can not create a PNG, so we use 
# GDAL library routines to ceate, and then save
# as a .png image, a temporary dataset.
   
    DemTif <- GDAL.open("DemByteImg.tif")
    xx <- copyDataset(DemTif,driver="PNG") 
    saveDataset(xx,"NevadaDEMImg.png")     
    DemPng <- readGDAL("NevadaDEMImg.png")  # na proper 'integer' PNG file
 
 # Preprocessing step: create a special SpatialGrid object
 # for display in GoogleEarth
  
    DemPngGK <- GE_SpatialGrid(DemPng)

# Generate the KML 'wrapper' for the png file.
# 'GE-compatible' PNG file is now a complex of three files:
# .png, .kml, and .png.aux.xml files.
 
    kmlOverlay(DemPngGK,"NevadaDEMImageOverlay.kml","NevadaDEMImg.png",name="First R Dem Kml")  

# Method 3: Use the ogr2ogr function from the fwtools package to translate 
# the 'Northwest Washington Counties' polygon shape file into a KML file.
# For this example to work, the host computer must have: 
# 
# 1) The fwtools file conversion utilitues installed. 
#    Download the package at:   http://fwtools.maptools.org/

# 2) Add the path to the fwtools ./bin folder to your system 'path' environment variable.
#    (on my system, this path is: 'C:/Program Files (x86)/FWTools2.4.7/bin')

    sOgr2OgrArgs <- sprintf("-dsco NameField=%s","OurTestKMLRegion")
    sCommandString <- sprintf(" -f KML %s %s %s","NwCountiesGeogProjOgr2ogr.kml","NwCountiesGP.shp",sOgr2OgrArgs)
 
# Execute the operating system command: create the final KML file
   
    system(paste('"C:/Program Files (x86)/FWTools2.4.7/bin/ogr2ogr"',sCommandString))
}
