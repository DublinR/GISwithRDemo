### R code from vignette source 'st_pp.Rnw'

###################################################
### code chunk number 1: st_pp.Rnw:4-67
###################################################
library(sp)
library(xts)
load("datasets/USboundary.RData")

#Tornado files
tserver<-"http://www.spc.noaa.gov/wcm/data"
tfiles<-c("2009_torn.csv", "2008_torn.csv", "2005-2007_torn.csv",
"2000-2004_torn.csv", "90-99_torn.csv", "80-89_torn.csv", "70-79_torn.csv",
"60-69_torn.csv", "50-59_torn.csv")

#Data structure is described in the following document:
#download.file("http://www.spc.noaa.gov/wcm/data/SPC_severe_database_description.pdf", "SPC_severe_database_description.pdf")

setwd("datasets")
for(fl in tfiles)
{
	if(!file.exists(fl))
	{
   download.file(paste(tserver, fl, sep="/"), fl)
	}
}


#Read data
d<-as.list(rep(NA, length(tfiles)))
coords<-as.list(rep(NA, length(tfiles)))

for(i in 1:length(d))
{
	d[[i]]<-read.csv(tfiles[i], header=FALSE)
	#Names obtanied from accompanying description file
names(d[[i]])<-c("Number", "Year", "Month", "Day", "Date",
   "Time", "TimeZone","State", "FIPS", "StateNumber",
   "EFscale", "Injuries", "Fatalities", "Loss", "CLoss",
   "SLat", "SLon", "ELat", "ELon", "Length",
   "Width","NStates", "SNumber", "SG", "1FIPS",
   "2FIPS", "3FIPS", "4FIPS")
	coords[[i]] <- SpatialPoints(d[[i]][, c("SLon", "SLat")])


}

setwd("..")

#Put data altogether
dall<-d[[1]]
for(i in 2:length(d))
	dall<-rbind(dall, d[[i]])
#Make space-time object
library(spacetime)

#times=xts(dall$Year, as.Date(dall$Date, format="%Y-%m-%d"))
times=xts(1:nrow(dall), as.Date(dall$Date, format="%Y-%m-%d"))

dst<-STIDF(SpatialPoints(dall[, c("SLon", "SLat")]), times, dall)

#Display maps
#stplot(dst)


#Select years after 2008
dst2009<-dst[as.Date(dall$Date, format="%Y-%m-%d")>as.Date("2008-12-31", format="%Y-%m-%d")]



###################################################
### code chunk number 2: st_pp.Rnw:117-122
###################################################
load("datasets/statesth.RData")

plot(statesth)
points(coordinates(dst), pch=".", col="grey")



###################################################
### code chunk number 3: st_pp.Rnw:196-216
###################################################
#Use data form Kansas state
if(!file.exists("results/dst2.RData"))
{
   idx<-overlay(SpatialPoints(coordinates(dst)), USboundary)
   dst2<-dst[!is.na(idx),]
   save(file="dst2.RData", list=c("dst2"))
}


if(file.exists("results/dst2.RData"))
{
   load("results/dst2.RData") 
}

#kansas<-states2[which(states2$NAME=="Kansas"),]
#kidx<-overlay(storn2, kansas)
#kstorn<-storn2[!is.na(kidx), ]
#
#kstorn_ppp <- as(kstorn, "ppp")
#kstorn_ppp


###################################################
### code chunk number 4: st_pp.Rnw:220-245
###################################################
#Define spatial grid for predicition


xlim <- bbox(USboundary)[1,]
ylim <- bbox(USboundary)[2,]
m_asp <- (diff(ylim)/diff(xlim))
maxDim <- 50
mywidth <- myheight <- maxDim
if (m_asp < 1) {
    myheight1 <- mywidth * m_asp
    myheight <- ceiling(myheight1)
    cellsize <- c(diff(xlim)/mywidth, diff(ylim)/myheight1)
} else {
    mywidth1 <- myheight/m_asp
    mywidth <- ceiling(mywidth1)
    cellsize <- c(diff(xlim)/mywidth1, diff(ylim)/myheight)
}
cells.dim <- c(mywidth, myheight)
cellcentre.offset <- c(xlim[1] + (0.5 * cellsize[1]), ylim[1] +
    (0.5 * cellsize[2]))
names(cellcentre.offset) <- c("x", "y")
grd <- GridTopology(cellcentre.offset, cellsize, cells.dim)
crds <- coordinates(grd)
crds <- list(x=crds[,1], y=crds[,2])



###################################################
### code chunk number 5: st_pp.Rnw:248-265
###################################################
library(splancs)
#Kernel smoothing of this point pattern

sptorn<-SpatialPoints(coordinates(dst2))

USbdy<-coordinates((slot(slot(USboundary, "polygons")[[1]], "Polygons"))[[1]])

if(!file.exists("results/spint.RData")) {
spint<-spkernel2d(coordinates(dst2), USbdy, h0=10, grd)
save(file="results/spint.RData", list=c("spint"))
} else {
   load("results/spint.RData")
}

dspint<-data.frame(SPK=spint)
#row.names(dspint)
spk <- SpatialGridDataFrame(grd, data=dspint )


###################################################
### code chunk number 6: st_pp.Rnw:271-277
###################################################
library(RColorBrewer)

tolpal<-colorRampPalette(brewer.pal(9, "Oranges")[-(1:2)])

print(spplot(spk, cuts=50, col.regions=tolpal(51)) )



###################################################
### code chunk number 7: st_pp.Rnw:297-315
###################################################
#if(!file.exists("spatstat.pdf"))
#{
library(spatstat)
library(maptools)

stornppp<-as.ppp(sptorn[1:1000,])

pmodel<-ppm(stornppp, ~1+x+I(x*x)+y+I(y*y))


#pdf(file="spatstat.pdf")
plot(pmodel, superimpose=FALSE, 
  trend = TRUE, cif = FALSE, se = FALSE, pause =FALSE)
plot(USboundary, add=TRUE)
#dev.off()


#}


###################################################
### code chunk number 8: st_pp.Rnw:324-327
###################################################
tyear<-apply.yearly(times, length)

plot(tyear, main="Number of Tornados per year")


###################################################
### code chunk number 9: st_pp.Rnw:336-337
###################################################
print(stplot(dst2, type="p", pch="."))


###################################################
### code chunk number 10: st_pp.Rnw:346-368
###################################################

if(!file.exists("results/kyear.RData"))
{
ep<-endpoints(dst2@time, on="years")

kyear<-lapply(2:length(ep), function(X)
{

        d<-SpatialPoints(coordinates(dst2[,(ep[X-1]+1):ep[X]]))

	spint<-spkernel2d(coordinates(d), USbdy, h0=10, grd)
	print(X)
        return(spint)

})
save(file="results/kyear.RData", list=c("kyear"))
}


if(file.exists("results/kyear.RData"))
	load("results/kyear.RData")



###################################################
### code chunk number 11: st_pp.Rnw:372-385
###################################################

#Reescale
#kyear2<-lapply(kyear, function(X){X/sum(X, na.rm=TRUE)} )
kyear2<-kyear
for(i in 1:length(kyear2))
	kyear2[[i]]<-kyear2[[i]]/tyear[[i]]

	sptkernels<-STFDF(SpatialGrid(grd), 
   xts(1:length(tyear), as.Date(time(tyear))),
   data.frame(kyear2=unlist(kyear2), kyear=unlist(kyear)) )


print(stplot(sptkernels, 1950:2009, cuts=50, col.regions=tolpal(51)))


###################################################
### code chunk number 12: st_pp.Rnw:446-449 (eval = FALSE)
###################################################
## #Overlay with US states
## sidx<-overlay(storn, states2)
## storn2<-storn[!is.na(sidx),]


###################################################
### code chunk number 13: st_pp.Rnw:453-492
###################################################

if(!file.exists("results/kk.RData"))
{
ep<-endpoints(dst2@time, on="years")

kk<-lapply(2:length(ep), function(X)
{

	d<-SpatialPoints(coordinates(dst2[,(ep[X-1]+1):ep[X]]))
#	print(length(d))
	kkk<-overlay(d, statesth)
#	print(c(length(X), length(kkk)))
	return(kkk)

})

save(file="results/kk.RData", list=c("kk"))
}else
{
	load("results/kk.RData")
}

if(FALSE)#Alternative way. DO NOT RUN.
{


source("myxts.R")
kk<-lapply.yearly(dst2@time[1:2000], function(X){
#	print(X)
#	print(length(X))
	d<-SpatialPoints(coordinates(dst2[,X]))
	print(length(d))
	kkk<-overlay(d, statesth)
	print(c(length(X), length(kkk)))
	return(kkk)
})

}#IF



###################################################
### code chunk number 14: st_pp.Rnw:496-518
###################################################
#Put data together

#time(tyear)#Gets times...

ntorn<-data.frame(rep(0, length(statesth)) )
tt<-table(kk[[1]])
ntorn[as.numeric(names(tt)),1]<- tt

ntornv<-ntorn[,1]

for(i in 2:length(kk))
{
	ntorn[,i]<-0
	tt<-table(kk[[i]])
	ntorn[as.numeric(names(tt)),i]<- tt

	ntornv<-c(ntornv, ntorn[,i])
}

names(ntorn)<-time(tyear)




###################################################
### code chunk number 15: st_pp.Rnw:522-527
###################################################
#Create STFDF

stfdf<-STFDF(statesth, xts(1:ncol(ntorn), as.Date(names(ntorn)) ), 
   data.frame(NTORN=ntornv))



###################################################
### code chunk number 16: st_pp.Rnw:533-542
###################################################

if(!file.exists("images/tornstate.pdf"))
{
tolpal2<-colorRampPalette(brewer.pal(9, "Blues")[-(1:2)])

pdf(file="images/tornstate.pdf")
print(stplot(stfdf, 1950:2009, cuts=50, col.regions=tolpal2(51) ))
dev.off()
}


###################################################
### code chunk number 17: st_pp.Rnw:672-682
###################################################
stareas<-unlist(lapply((slot(statesth, "polygons")), function(X){slot(X, "area")}))

ntimes<-length(tyear)

stfdf$AREA<-rep(stareas, ntimes)
#stfdf$STATEID<-rep(unlist(lapply(slot(statesth, "polygons"), function(X){slot(X, "ID")})), ntimes)
stfdf$STATEID<-rep(1:49, ntimes)
stfdf$YEAR<-rep(1950:2009, each=49)
stfdf$STATEST<-rep(as.factor(as.character(statesth$STATE)), ntimes)



###################################################
### code chunk number 18: st_pp.Rnw:685-706
###################################################

#Adjacency matrix
if(!file.exists("results/statesth.adj"))
{
library(spdep)
#source("nb2inla.R")
neib<-poly2nb(statesth)
nb2INLA("results/statesth.adj", neib)
}

#Fit spatio-temporal model with INLA
library(INLA)
#form<-NTORN~1+AREA+f(YEAR, model="rw2")+f(STATE, model="iid")+f(STATEID, model="besag", graph.file="statesth.adj")
form<-NTORN~1+AREA+f(YEAR, model="rw2")+f(STATEID, model="besag", graph="results/statesth.adj")

inlares<-inla(form, family="Poisson", data=as.data.frame(stfdf),
control.predictor=list(compute=TRUE),
#   quantiles=qnts,
   control.results=list(return.marginals.predictor=TRUE)
)



###################################################
### code chunk number 19: st_pp.Rnw:710-713
###################################################
#Add results

stfdf$PREDNTORN<-inlares$summary.fitted[,1]


###################################################
### code chunk number 20: st_pp.Rnw:717-720 (eval = FALSE)
###################################################
## #ink(file="inlares.txt")
## summary(inlares)
## #sink()


###################################################
### code chunk number 21: st_pp.Rnw:733-742 (eval = FALSE)
###################################################
## 
## statesth$IND<-inlares$summary.random$STATE[,2]
## statesth$CAR<-inlares$summary.random$STATEID[,2]
## 
## tolpalind<-colorRampPalette(brewer.pal(11, "PRGn"))
## 
## 
## print(spplot(statesth, c("IND"), cuts=50, col.regions=tolpalind(51)))#,main="Random Effects"))
## 


###################################################
### code chunk number 22: st_pp.Rnw:752-762
###################################################

statesth$IND<-inlares$summary.random$STATE[,2]
statesth$CAR<-inlares$summary.random$STATEID[,2]


tolpalcar<-colorRampPalette(brewer.pal(11, "PuOr"))


print(spplot(statesth, c("CAR"), cuts=50, col.regions=tolpalcar(51)) )



###################################################
### code chunk number 23: st_pp.Rnw:774-781
###################################################

plot(1950:2009, inlares$summary.random$YEAR[,2], type="l", lwd=1.5, 
main="YEAR (with credible intervals)")

lines(1950:2009, inlares$summary.random$YEAR[,4], lty=2)
lines(1950:2009, inlares$summary.random$YEAR[,6], lty=2)



###################################################
### code chunk number 24: st_pp.Rnw:794-802
###################################################

if(!file.exists("images/predntorn.pdf"))
{
pdf(file="images/predntorn.pdf")
print(stplot(stfdf[,, "PREDNTORN"], 1950:2009, 
   main="Predicted Number of Tornados"))
dev.off()
}


