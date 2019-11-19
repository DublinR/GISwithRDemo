Unit 3
========================================================


```r
# R code from vignette source 'unit3.Rnw'

# code chunk number 1: spmaps (eval = FALSE)
library(maptools)
```

```
## Warning: package 'maptools' was built under R version 3.0.3
```

```
## Loading required package: sp
```

```
## Warning: package 'sp' was built under R version 3.0.3
```

```
## Checking rgeos availability: TRUE
```

```r
library(maps)
ill <- map("county", regions = "illinois", plot = FALSE, fill = TRUE)
IDs <- sub("^illinois,", "", ill$names)
ill_sp <- map2SpatialPolygons(ill, IDs, CRS("+proj=longlat"))
plot(ill_sp, axes = TRUE)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 


```r
# code chunk number 2: unit3.Rnw:70-73 oopar <- par(mar=c(3,3,1,1)+0.1)
library(maptools)
library(maps)
ill <- map("county", regions = "illinois", plot = FALSE, fill = TRUE)
IDs <- sub("^illinois,", "", ill$names)
ill_sp <- map2SpatialPolygons(ill, IDs, CRS("+proj=longlat"))
plot(ill_sp, axes = TRUE)
# par(oopar)


# code chunk number 3: unit3.Rnw:81-82
options(width = 36)


# code chunk number 4: unit3.Rnw:86-87 (eval = FALSE)
library(maptools)
library(maps)
ill <- map("county", regions = "illinois", plot = FALSE, fill = TRUE)
IDs <- sub("^illinois,", "", ill$names)
ill_sp <- map2SpatialPolygons(ill, IDs, CRS("+proj=longlat"))
plot(ill_sp, axes = TRUE)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 

```r


# code chunk number 5: unit3.Rnw:90-91
options(width = 60)
```


```r

# code chunk number 6: unit3.Rnw:148-149
library(rgdal)
```

```
## Warning: package 'rgdal' was built under R version 3.0.3
```

```
## rgdal: version: 0.8-16, (SVN revision 498)
## Geospatial Data Abstraction Library extensions to R successfully loaded
## Loaded GDAL runtime: GDAL 1.11.0, released 2014/04/16
## Path to GDAL shared files: C:/Users/Computer5/Documents/R/win-library/3.0/rgdal/gdal
## GDAL does not use iconv for recoding strings.
## Loaded PROJ.4 runtime: Rel. 4.8.0, 6 March 2012, [PJ_VERSION: 480]
## Path to PROJ.4 shared files: C:/Users/Computer5/Documents/R/win-library/3.0/rgdal/proj
```

```r


# code chunk number 7: unit3.Rnw:151-157
ED50 <- CRS(paste("+init=epsg:4230", "+towgs84=-87,-96,-120,0,0,0,0"))
IJ.east <- as(char2dms("4d31'00\"E"), "numeric")
IJ.north <- as(char2dms("52d28'00\"N"), "numeric")
IJ.ED50 <- SpatialPoints(cbind(x = IJ.east, y = IJ.north), ED50)
res <- spTransform(IJ.ED50, CRS("+proj=longlat +datum=WGS84"))
spDistsN1(coordinates(IJ.ED50), coordinates(res), longlat = TRUE) * 
    1000
```

```
## [1] 124.1
```

```r


# code chunk number 8: unit3.Rnw:267-275 (eval = FALSE)
td <- tempdir()
dd <- paste(td, "shapes", sep = "/")
dir.create(dd)
rgdalvd <- system.file("vectors", package = "rgdal")
scots <- list.files(rgdalvd, pattern = "scot_BNG")
file.copy(from = paste(rgdalvd, scots, sep = "/"), to = paste(dd, 
    scots, sep = "/"))
```

```
## [1] TRUE TRUE TRUE TRUE
```

```r
oldwd <- getwd()
setwd(dd)
```


```r
# code chunk number 9: unit3.Rnw:277-281
library(maptools)
# list.files()
getinfo.shape("datasets/s_01au07.shp")
```

```
## Shapefile type: Polygon, (5), # of Shapes: 57
```

```r
US <- readShapePoly("datasets/s_01au07.shp")


# code chunk number 10: unit3.Rnw:283-284 (eval = FALSE)
setwd(oldwd)


# code chunk number 11: unit3.Rnw:304-306 (eval = FALSE)
oldwd <- getwd()
setwd(dd)


# code chunk number 12: unit3.Rnw:308-310
US1 <- readOGR(dsn = "datasets", layer = "s_01au07")
```

```
## Error: Cannot open file
```

```r
cat(strwrap(proj4string(US1)), sep = "\n")
```

```
## Error: error in evaluating the argument 'obj' in selecting a method for function 'proj4string': Error: object 'US1' not found
```

```r


# code chunk number 13: unit3.Rnw:312-313 (eval = FALSE)
setwd(oldwd)
```


```r
# code chunk number 14: unit3.Rnw:351-359
td <- tempdir()
dd <- paste(td, "pix", sep = "/")
dir.create(dd)
rgdalvd <- system.file("pictures", package = "rgdal")
wnd <- list.files(rgdalvd, pattern = "SP27GTIF")
file.copy(from = paste(rgdalvd, wnd, sep = "/"), to = paste(dd, 
    wnd, sep = "/"))
```

```
## [1] TRUE
```

```r
oldwd <- getwd()
setwd(dd)


# code chunk number 15: unit3.Rnw:361-362
options(width = 100)
```


```r
# code chunk number 16: unit3.Rnw:364-367
getGDALDriverNames()$name
```

```
##   [1] AAIGrid         ACE2            ADRG            AIG             AirSAR         
##   [6] ARG             BIGGIF          BLX             BMP             BSB            
##  [11] BT              CEOS            COASP           COSAR           CPG            
##  [16] CTable2         CTG             DIMAP           DIPEx           DOQ1           
##  [21] DOQ2            DTED            E00GRID         ECRGTOC         EHdr           
##  [26] EIR             ELAS            ENVI            ERS             ESAT           
##  [31] FAST            FIT             FujiBAS         GenBin          GFF            
##  [36] GIF             GRASSASCIIGrid  GRIB            GS7BG           GSAG           
##  [41] GSBG            GSC             GTiff           GTX             GXF            
##  [46] HF2             HFA             IDA             ILWIS           INGR           
##  [51] IRIS            ISIS2           ISIS3           JAXAPALSAR      JDEM           
##  [56] JPEG            KMLSUPEROVERLAY KRO             L1B             LAN            
##  [61] LCP             Leveller        LOSLAS          MAP             MEM            
##  [66] MFF             MFF2            MSGN            NDF             NGSGEOID       
##  [71] NITF            NTv2            NWT_GRC         NWT_GRD         OZI            
##  [76] PAux            PCIDSK          PCRaster        PDF             PDS            
##  [81] PNG             PNM             R               RIK             RMF            
##  [86] RPFTOC          RS2             RST             SAGA            SAR_CEOS       
##  [91] SDTS            SGI             SNODAS          SRP             SRTMHGT        
##  [96] Terragen        TIL             TSX             USGSDEM         VRT            
## [101] XPM             XYZ             ZMap           
## 103 Levels: AAIGrid ACE2 ADRG AIG AirSAR ARG BIGGIF BLX BMP BSB BT CEOS COASP COSAR CPG ... ZMap
```

```r
list.files()
```

```
##  [1] "datasets"           "dismap.pdf"         "dismap.R"           "figure"            
##  [5] "geos.pdf"           "geos.R"             "intro_spatial.pdf"  "intro_spatial.R"   
##  [9] "legend_image.R"     "models"             "point_patterns.pdf" "point_patterns.R"  
## [13] "results"            "spacetime_data.pdf" "spacetime_data.R"   "spateco.pdf"       
## [17] "spateco.R"          "st_dismap.R"        "st_geos.R"          "st_pp.R"           
## [21] "unit0.R"            "unit1.html"         "unit1.md"           "unit1.R"           
## [25] "unit1.Rmd"          "Unit2.html"         "Unit2.md"           "unit2.R"           
## [29] "Unit2.Rmd"          "unit3.R"            "Unit3.Rmd"
```

```r
SP27GTIF <- readGDAL("SP27GTIF.TIF")
```

```
## Error: `C:\Users\Computer5\Desktop\SSTMR\SP27GTIF.TIF' does not exist in the file system,
## and is not recognised as a supported dataset name.
```

```r


# code chunk number 17: unit3.Rnw:369-370
options(width = 36)
```


```r
# code chunk number 18:
# unit3.Rnw:372-376
setwd(oldwd)
summary(SP27GTIF)
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'SP27GTIF' not found
```

```r
summary(SP27GTIF)
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'SP27GTIF' not found
```

```r
summary(SP27GTIF)
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'SP27GTIF' not found
```

```r


# code chunk number 19: raster (eval
# = FALSE)
image(SP27GTIF, col = grey(1:99/100), 
    axes = TRUE)
```

```
## Error: object 'SP27GTIF' not found
```

```r


# code chunk number 20:
# unit3.Rnw:389-392
oopar <- par(mar = c(3, 3, 1, 1) + 0.1)
image(SP27GTIF, col = grey(1:99/100), 
    axes = TRUE)
```

```
## Error: object 'SP27GTIF' not found
```

```r
par(oopar)


# code chunk number 21:
# unit3.Rnw:401-402 (eval = FALSE)
image(SP27GTIF, col = grey(1:99/100), 
    axes = TRUE)
```

```
## Error: object 'SP27GTIF' not found
```

```r


# code chunk number 22:
# unit3.Rnw:413-414
options(width = 100)


# code chunk number 23:
# unit3.Rnw:416-417
summary(SP27GTIF)
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'SP27GTIF' not found
```

```r


# code chunk number 24:
# unit3.Rnw:419-420
options(width = 36)

```


