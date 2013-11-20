# read-write-shapefiles.R
#
# R code intended as a basic demonstration of how to read and write ESRI
# Shapefiles in R, including points, lines, and polygons.
#
# Input Data
#  * nw-counties.* 
#      Polygon shapefile of counties across five US states (WA, OR, ID,
#      MT, and WY)
#  * nw-centroids.*
#      Point shapefile of county centroids       
#  * nw-rivers.*
#      Line shapefile of major rivers in the region
#
# Output
#  * Two different copies of the county polygon shapefile, written out
#    by rgdal and maptools functions.
#  * Map visualization (PNG format).
#
# Notes
#  * The rgdal and maptools approaches both produce Spatial*DataFrame
#    objects in R, as defined in the 'sp' package.
#  * The PBSmapping approach produces objects in a custom format
#    specific to that package.
# 
# Authors: Jim Regetz & Rick Reeves
# Last modified: 21-Nov-2011
# National Center for Ecological Analysis and Synthesis (NCEAS),
# http://www.nceas.ucsb.edu/scicomp


# ---------- rgdal ---------- #

library(rgdal)

# for shapefiles, first argument of the read/write/info functions is the
# directory location, and the second is the file name without suffix

# optionally report shapefile details
ogrInfo(".", "nw-rivers")
# Source: ".", layer: "nw-rivers"
# Driver: ESRI Shapefile number of rows 12 
# Feature type: wkbLineString with 2 dimensions
# +proj=longlat +datum=WGS84 +no_defs  
# Number of fields: 2 
#     name type length typeName
#     1   NAME    4     80   String
#     2 SYSTEM    4     80   String

# read in shapefiles
centroids.rg <- readOGR(".", "nw-centroids")
rivers.rg <- readOGR(".", "nw-rivers")
counties.rg <- readOGR(".", "nw-counties")

# note that readOGR will read the .prj file if it exists
print(proj4string(counties.rg))
# [1] " +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

# generate a simple map showing all three layers
plot(counties.rg, axes=TRUE, border="gray")
points(centroids.rg, pch=20, cex=0.8)
lines(rivers.rg, col="blue", lwd=2.0)

# write out a new shapefile (including .prj component)
writeOGR(counties.rg, ".", "counties-rgdal", driver="ESRI Shapefile")


# ---------- maptools ---------- #

library(maptools)

# read in shapefiles; here we use the specialized readShape* functions,
# but readShapeSpatial would produce identical output in all three cases
centroids.mp <- readShapePoints("nw-centroids")
rivers.mp <- readShapeLines("nw-rivers")
counties.mp <- readShapePoly("nw-counties")

# note that readShape* does _not_ read the shapefile's .prj file
print(proj4string(counties.mp))
## [1] NA

# specifying projection information is not strictly necessary for
# plotting, but does yield nicer default axis labels and aspect ratio in
# the case of geographic data
proj4string(counties.mp) <- "+proj=longlat +datum=WGS84"

# generate a simple map showing all three layers
plot(counties.mp, axes=TRUE, border="gray")
points(centroids.mp, pch=20, cex=0.8)
lines(rivers.mp, col="blue", lwd=2.0)

# write out a new shapefile (but without .prj); the more general
# writeSpatialShape would produce equivalent output
writePolyShape(counties.mp, "counties-maptools")


# ---------- PBSmapping ---------- #

library(PBSmapping)
   
# read in shapefiles
centroids.pb <- importShapefile("nw-centroids")
rivers.pb <- importShapefile("nw-rivers")
counties.pb <- importShapefile("nw-counties")
   
# note that importShapefile reads the .prj file if it exists, but it
# does not adopt the proj4 format used by the above approaches
proj.abbr <- attr(counties.pb, "projection") # abbreviated projection info
proj.full <- attr(counties.pb, "prj") # full projection info
print(proj.abbr)
# [1] "LL"

# generate map using PBSmapping plotting functions
plotPolys(counties.pb, projection=proj.abbr, border="gray",
    xlab="Longitude", ylab="Latitude")
addPoints(centroids.pb, pch=20, cex=0.8)
addLines(rivers.pb, col="blue", lwd=2.0)  


# ---------- generate PNG map ---------- #

png("map-points-lines-polys.png", height=600, width=400)
par(mfrow=c(2,1))

# generate the same map as above
plot(counties.rg, axes=TRUE, border="gray")
points(centroids.rg, pch=20, cex=0.8)
lines(rivers.rg, col="blue", lwd=2.0)
title("plot() using data read via rgdal/maptools")

plotPolys(counties.pb, projection=proj.abbr, border="gray",
    xlab="Longitude", ylab="Latitude")
title("plotPolys() using data read via PBSmapping")
addPoints(centroids.pb, pch=20, cex=0.8)
addLines(rivers.pb, col="blue", lwd=2.0)  

dev.off()
