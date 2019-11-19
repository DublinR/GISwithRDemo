### R code from vignette source 'unit1.Rnw'

###################################################
### code chunk number 1: unit1.Rnw:198-211
###################################################
library(sp)

d<-read.csv(file="datasets/2009_torn.csv", header=FALSE)
#Names obtained from accompanying description file
names(d)<-c("Number", "Year", "Month", "Day", "Date",
   "Time", "TimeZone","State", "FIPS", "StateNumber",
   "EFscale", "Injuries", "Fatalities", "Loss", "CLoss",
   "SLat", "SLon", "ELat", "ELon", "Length",
   "Width","NStates", "SNumber", "SG", "1FIPS",
   "2FIPS", "3FIPS", "4FIPS")

coords <- SpatialPoints(d[, c("SLon", "SLat")])
summary(coords)


###################################################
### code chunk number 2: unit1.Rnw:224-228
###################################################
storn <- SpatialPointsDataFrame(coords, d)
names(storn)
summary(storn$Fatalities)
table(storn$Month)


###################################################
### code chunk number 3: unit1.Rnw:278-291
###################################################
sl<-lapply(unique(d$Number), function(X){
        dd<-d[which(d$Number==X),c("SLon", "SLat", "ELon", "ELat")]


        L<-lapply(1:nrow(dd), function(i){
           Line(matrix(as.numeric(dd[i,]),ncol=2, byrow=TRUE))
        })
        Lines(L, ID=as.character(X))
})

Tl<-SpatialLines(sl)

summary(Tl)


###################################################
### code chunk number 4: Tl (eval = FALSE)
###################################################
## load("datasets/statesth.RData")
## plot(statesth)
## plot(Tl, add=TRUE)


###################################################
### code chunk number 5: unit1.Rnw:316-317
###################################################
load("datasets/statesth.RData")
plot(statesth)
plot(Tl, add=TRUE)


###################################################
### code chunk number 6: unit1.Rnw:328-329
###################################################
library(maptools)


###################################################
### code chunk number 7: unit1.Rnw:331-336
###################################################
volcano_sl <- ContourLines2SLDF(contourLines(volcano))
row.names(slot(volcano_sl, "data"))
sapply(slot(volcano_sl, "lines"), function(x) slot(x, "ID"))
sapply(slot(volcano_sl, "lines"), function(x) length(slot(x, "Lines")))
volcano_sl$level


###################################################
### code chunk number 8: unit1.Rnw:400-414
###################################################
#Step of the grid
h<-1

xrange<-diff(bbox(statesth)[1,])
yrange<-diff(bbox(statesth)[2,])

nx<-ceiling( (xrange/h) )
ny<-ceiling(yrange/h)

grdtop<-GridTopology(cellcentre.offset=bbox(statesth)[,1], 
   cellsize=c(h,h), cells.dim=c(nx,ny))

grd<-SpatialGrid(grdtop, proj4string=CRS("+proj=longlat") )



###################################################
### code chunk number 9: grd (eval = FALSE)
###################################################
## plot(grd)
## plot(statesth, add=TRUE)


###################################################
### code chunk number 10: unit1.Rnw:426-427
###################################################
plot(grd)
plot(statesth, add=TRUE)


###################################################
### code chunk number 11: unit1.Rnw:443-448
###################################################
grdidx<-overlay(grd, statesth)

grd2<-SpatialPixels(SpatialPoints(coordinates(grd))[!is.na(grdidx),] )
proj4string(grd)<-CRS("+proj=longlat")



###################################################
### code chunk number 12: grd2 (eval = FALSE)
###################################################
## plot(grd2)
## plot(statesth, add=TRUE)


###################################################
### code chunk number 13: unit1.Rnw:458-459
###################################################
plot(grd2)
plot(statesth, add=TRUE)


###################################################
### code chunk number 14: unit1.Rnw:565-568
###################################################
sidx<-overlay(storn, statesth)
storn2<-storn[!is.na(sidx),]



###################################################
### code chunk number 15: plot2 (eval = FALSE)
###################################################
## plot(storn2)
## plot(statesth, add=TRUE)


###################################################
### code chunk number 16: unit1.Rnw:578-579
###################################################
plot(storn2)
plot(statesth, add=TRUE)


###################################################
### code chunk number 17: unit1.Rnw:604-605
###################################################
save(file="results/unit1.RData", list=ls())


