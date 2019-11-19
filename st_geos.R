### R code from vignette source 'st_geos.Rnw'

###################################################
### code chunk number 1: st_geos.Rnw:24-32
###################################################
library(sp)
library(spacetime)
library(gstat)
data(wind)
wind.loc$y = as.numeric(char2dms(as.character(wind.loc[["Latitude"]])))
wind.loc$x = as.numeric(char2dms(as.character(wind.loc[["Longitude"]])))
coordinates(wind.loc) = ~x+y
proj4string(wind.loc) = "+proj=longlat +datum=WGS84"


###################################################
### code chunk number 2: st_geos.Rnw:45-50
###################################################
library(mapdata)
plot(wind.loc, xlim = c(-11,-5.4), ylim = c(51,55.5), axes=T, col="red",
        cex.axis =.7)
map("worldHires", add=T, col = grey(.5))
text(coordinates(wind.loc), pos=1, label=wind.loc$Station, cex=.7)


###################################################
### code chunk number 3: st_geos.Rnw:67-81
###################################################
#Date transformation
wind$time = ISOdate(wind$year+1900, wind$month, wind$day)
wind$jday = as.numeric(format(wind$time, '%j'))
stations = 4:15

# knots -> m/s
windsqrt = sqrt(0.5148 * as.matrix(wind[stations]))

#Trend removal
Jday = 1:366
daymeans = sapply(split(windsqrt, wind$jday), mean)

meanwind = lowess(daymeans ~ Jday, f = 0.1)$y[wind$jday]
velocities = apply(windsqrt, 2, function(x) { x - meanwind })


###################################################
### code chunk number 4: st_geos.Rnw:98-114
###################################################
# order locations to order of columns in wind;
# connect station names to location coordinates
wind.loc = wind.loc[match(names(wind[4:15]), wind.loc$Code),]
pts = coordinates(wind.loc[match(names(wind[4:15]), wind.loc$Code),])
rownames(pts) = wind.loc$Station
pts = SpatialPoints(pts)
# convert to utm zone 29, to be able to do interpolation in
# proper Euclidian (projected) space:
proj4string(pts) = "+proj=longlat +datum=WGS84"
library(rgdal)
utm29 = CRS("+proj=utm +zone=29 +datum=WGS84")
pts = spTransform(pts, utm29)
# construct from space-wide table:
wind.data = stConstruct(velocities, 
   space = list(values = 1:ncol(velocities)),
        time = wind$time, SpatialObj = pts)


###################################################
### code chunk number 5: st_geos.Rnw:131-151
###################################################
library(maptools)

m = map2SpatialLines(
        map("worldHires", xlim = c(-11,-5.4), ylim = c(51,55.5), plot=F))
proj4string(m) = "+proj=longlat +datum=WGS84"
m = spTransform(m, utm29)

# setup grid
grd = SpatialPixels(SpatialPoints(makegrid(m, n = 300)),
        proj4string = proj4string(m))
# select april 1961:
wind.data = wind.data[, "1961-04"]

# 10 prediction time points, evenly spread over this month:
library(xts)
n = 10
tgrd = seq(min(index(wind.data)), max(index(wind.data)), length=n)
pred.grd = STF(grd, tgrd)




###################################################
### code chunk number 6: st_geos.Rnw:173-181
###################################################
# separable covariance model, exponential with ranges 750 km and 1.5 day:
v = vgmST("separable", space = vgm(1, "Exp", 750000), 
   time = vgm(1, "Exp", 1.5 * 3600 * 24),
         sill=0.6)
wind.ST = krigeST(values ~ 1, wind.data, pred.grd, v)
colnames(wind.ST@data) <- "sqrt_speed"




###################################################
### code chunk number 7: st_geos.Rnw:197-202
###################################################
layout = list(list("sp.lines", m, col='grey'),
        list("sp.points", pts, first=F, cex=.5))
print(stplot(wind.ST, col.regions=bpy.colors(),
        par.strip.text = list(cex=.5), sp.layout = layout))


###################################################
### code chunk number 8: st_geos.Rnw:219-229
###################################################
library(lattice)
library(RColorBrewer)
b = brewer.pal(12,"Set3")
par.settings = list(superpose.symbol = list(col = b, fill = b),
        superpose.line = list(col = b),
        fontsize = list(text=9))
print(xyplot(values~time, groups=sp.ID, as.data.frame(wind.data),
        type='l', auto.key=list(space="right"),
        xlab = "1961", ylab = expression(sqrt(speed)),
        par.settings = par.settings))


