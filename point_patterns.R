### R code from vignette source 'point_patterns.Rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: point_patterns.Rnw:83-84
###################################################
options("width"=75)


###################################################
### code chunk number 2: point_patterns.Rnw:193-212
###################################################
d<-read.csv(file="datasets/2009_torn.csv", header=FALSE)


#Names obtanied from accompanying description file
names(d)<-c("Number", "Year", "Month", "Day", "Date",
   "Time", "TimeZone","State", "FIPS", "StateNumber",
   "EFscale", "Injuries", "Fatalities", "Loss", "CLoss",
   "SLat", "SLon", "ELat", "ELon", "Length",
   "Width","NStates", "SNumber", "SG", "1FIPS",
   "2FIPS", "3FIPS", "4FIPS")

storn<-d

#Convert data into sp-objects and assign CRS
library(sp)

coordinates(storn)<-~SLon+SLat
proj4string(storn)<-"+proj=longlat"



###################################################
### code chunk number 3: point_patterns.Rnw:216-217
###################################################
plot(storn)


###################################################
### code chunk number 4: point_patterns.Rnw:237-238
###################################################
options(width=36)


###################################################
### code chunk number 5: point_patterns.Rnw:241-250
###################################################
library(maptools)
states<-readShapePoly(fn="datasets/s_01au07")
proj4string(states)<-"+proj=longlat"


#Remove some states...
states2<-states[-which(states$STATE %in% c("AK", "AS", "HI", "UM", "GU", "PR", "VI")),]
states2<-states2[!is.na(states2$STATE),]



###################################################
### code chunk number 6: point_patterns.Rnw:253-254
###################################################
options(width=60)


###################################################
### code chunk number 7: point_patterns.Rnw:257-258
###################################################
plot(states2)


###################################################
### code chunk number 8: point_patterns.Rnw:300-303 (eval = FALSE)
###################################################
## #Thin lines. THis is useful for displaying results
## statesth<-thinnedSpatialPoly(states2,  tolerance=0.05, minarea=0.001)
## save(file="statesth.RData", "statesth")


###################################################
### code chunk number 9: point_patterns.Rnw:306-307
###################################################
load("datasets/statesth.RData")


###################################################
### code chunk number 10: point_patterns.Rnw:311-314 (eval = FALSE)
###################################################
## #Create continental boundary
## USboundary<-unionSpatialPolygons(statesth, rep(1, nrow(statesth)))
## save(file="USboundary.RData", "USboundary")


###################################################
### code chunk number 11: point_patterns.Rnw:317-321
###################################################
load("datasets/USboundary.RData")
l<-slot(USboundary[1], "polygons")
ll<-slot(l[[1]], "Polygons")
USboundary<- SpatialPolygons(list(Polygons(list(ll[[1]]), ID="US")))


###################################################
### code chunk number 12: point_patterns.Rnw:324-327
###################################################
#Overlay
sidx<-overlay(storn, states2)
storn2<-storn[!is.na(sidx),]


###################################################
### code chunk number 13: point_patterns.Rnw:331-334
###################################################
#plot(states2)
plot(USboundary)
points(coordinates(storn2), col="red", pch=".")


###################################################
### code chunk number 14: point_patterns.Rnw:387-399
###################################################

sl<-lapply(unique(d$Number), function(X){
	dd<-d[which(d$Number==X),c("SLon", "SLat", "ELon", "ELat")]


	L<-lapply(1:nrow(dd), function(i){
	   Line(matrix(as.numeric(dd[i,]),ncol=2, byrow=TRUE))
	})
	Lines(L, ID=as.character(X))
})

Tl<-SpatialLines(sl)


###################################################
### code chunk number 15: point_patterns.Rnw:405-407
###################################################
plot(USboundary)
plot(Tl, add=TRUE)


###################################################
### code chunk number 16: point_patterns.Rnw:437-440
###################################################
tab<-(table(sidx))
barplot(tab)



###################################################
### code chunk number 17: point_patterns.Rnw:449-454
###################################################
states2$NTorn<-0
states2$NTorn[as.numeric(names(tab))]<-tab

print(spplot(states2, "NTorn"))



###################################################
### code chunk number 18: point_patterns.Rnw:475-489
###################################################
library(maptools)
library(spatstat)

#Use data form Kansas state
kansas<-states2[which(states2$NAME=="Kansas"),]
kidx<-overlay(storn2, kansas)
kstorn<-storn2[!is.na(kidx), ]

kstorn_ppp <- as(kstorn, "ppp")
kstorn_ppp


kstorn_ppp2<-ppp(kstorn_ppp$x, kstorn_ppp$y, owin=as(kansas, "owin"))



###################################################
### code chunk number 19: point_patterns.Rnw:603-628
###################################################

rr<-ripras(kstorn_ppp)
xlim <- rr$xrange
ylim <- rr$yrange
m_asp <- (diff(ylim)/diff(xlim))
maxDim <- 100
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
### code chunk number 20: point_patterns.Rnw:632-647
###################################################

k025 <- density(kstorn_ppp, sigma = 0.25, xy = crds)
SG <- as(k025, "SpatialGridDataFrame")
proj4string(SG)<-"+proj=longlat"

k050 <- density(kstorn_ppp, sigma = 0.50, xy = crds)
SG <- cbind(SG, as(k050, "SpatialGridDataFrame"))

k075 <- density(kstorn_ppp, sigma = 0.75, xy = crds)
SG <- cbind(SG, as(k075, "SpatialGridDataFrame"))

k100 <- density(kstorn_ppp, sigma = 1.00, xy = crds)
SG <- cbind(SG, as(k100, "SpatialGridDataFrame"))
names(SG) <- c("k025", "k050", "k075", "k100")



###################################################
### code chunk number 21: kernelplot (eval = FALSE)
###################################################
## spl <- list("sp.points", kstorn, pch=".", col=1)
## print(spplot(SG, c("k025", "k050", "k075", "k100"), col.regions=terrain.colors(16), cuts=15, sp.layout=list(spl), par.strip.text=list(cex=0.7)) )
## 


###################################################
### code chunk number 22: point_patterns.Rnw:667-668
###################################################
spl <- list("sp.points", kstorn, pch=".", col=1)
print(spplot(SG, c("k025", "k050", "k075", "k100"), col.regions=terrain.colors(16), cuts=15, sp.layout=list(spl), par.strip.text=list(cex=0.7)) )



###################################################
### code chunk number 23: point_patterns.Rnw:681-682
###################################################
summary(as(SG, "data.frame")[, 1:4])


###################################################
### code chunk number 24: point_patterns.Rnw:741-751
###################################################
library(rgl)
z <- as(SG["k025"], "matrix")
z[is.na(z)] <- 0
x <- 1:nrow(z)
y <- 1:ncol(z)
rgl.bg(color = "white")
rgl.clear()
rgl.viewpoint(theta = 350, phi = 35)
rgl.surface(x, y, z)
rgl.snapshot("images/k025.png")


###################################################
### code chunk number 25: point_patterns.Rnw:780-798
###################################################
#if(!file.exists("spatstat.pdf"))
#{
library(spatstat)
library(maptools)

#stornppp<-as.ppp(storn2[1:1000,])
stornppp<-as.ppp(as(storn2[1:1000,], "SpatialPoints"))

pmodel<-ppm(stornppp, ~1+x+I(x*x)+y+I(y*y))

#pdf(file="spatstat.pdf")
plot(pmodel, superimpose=FALSE,
  trend = TRUE, cif = FALSE, se = FALSE, pause =FALSE)
plot(USboundary, add=TRUE)
#dev.off()


#}


###################################################
### code chunk number 26: point_patterns.Rnw:891-893
###################################################
nns <- nndist(kstorn_ppp)
summary(nns)


###################################################
### code chunk number 27: point_patterns.Rnw:902-903
###################################################
plot(ecdf(nns))


###################################################
### code chunk number 28: G1 (eval = FALSE)
###################################################
## plot(ecdf(nns), xlim = c(0, 0.5))
## plot(Gest(kstorn_ppp), add = TRUE,  lwd = 3)


###################################################
### code chunk number 29: point_patterns.Rnw:941-942
###################################################
plot(ecdf(nns), xlim = c(0, 0.5))
plot(Gest(kstorn_ppp), add = TRUE,  lwd = 3)


###################################################
### code chunk number 30: point_patterns.Rnw:966-972
###################################################
n <- kstorn_ppp$n
ex <- expression(runifpoint(n, win = kstorn_ppp$window))

res <- envelope(kstorn_ppp, Gest, nsim = 99, simulate = ex, 
   verbose = FALSE, saveall = TRUE)



###################################################
### code chunk number 31: point_patterns.Rnw:981-982
###################################################
plot(res)


###################################################
### code chunk number 32: point_patterns.Rnw:1038-1043
###################################################
ex <- expression(runifpoint(n, win = kstorn_ppp$window))
res <- envelope(kstorn_ppp,
   Kest, nsim = 99, simulate = ex,
   verbose = FALSE, saveall = TRUE)



###################################################
### code chunk number 33: point_patterns.Rnw:1051-1052
###################################################
plot(res)


###################################################
### code chunk number 34: point_patterns.Rnw:1069-1099
###################################################

library(maptools)
library(rgdal)

grd1 <- as(as(SG, "SpatialPixels"), "SpatialPolygons")

proj4string(grd1) <- CRS(proj4string(SG))
grd.union <- unionSpatialPolygons(grd1, rep("x", length(slot(grd1, "polygons"))))
grd.union.ll <- spTransform(grd.union, CRS("+proj=longlat"))


llGRD <- GE_SpatialGrid(grd.union.ll, maxPixels = 100)
llGRD_in <- overlay(llGRD$SG, grd.union.ll)
llSPix <- as(SpatialGridDataFrame(grid=slot(llGRD$SG, "grid"), 
   proj4string=CRS(proj4string(llGRD$SG)), 
   data=data.frame(in0=llGRD_in)), "SpatialPixelsDataFrame")

#SPix <- spTransform(llSPix, CRS("+init=epsg:28992"))
#z <- predict(OK_fit, newdata=SPix, debug.level=0)
#llSPix$pred <- z$OK_fit.pred


png(file="tornado_kansas.png", width=llGRD$width, height=llGRD$height, 
   bg="transparent")
par(mar=c(0,0,0,0), xaxs="i", yaxs="i")
image(SG, "k025", col=bpy.colors(20))
dev.off()
kmlOverlay(llGRD, "tornado_kansas.kml", "tornado_kansas.png")




###################################################
### code chunk number 35: point_patterns.Rnw:1199-1213
###################################################
rm(list=ls())

library(rgdal)
spasthma <- readOGR("datasets", "spasthma")
spbdry <- readOGR("datasets", "spbdry")
spsrc <- readOGR("datasets", "spsrc")
sproads <- readOGR("datasets", "sproads")


plot(spbdry, axes=TRUE)
plot(sproads, add=TRUE, lty=2)
plot(spasthma, add=TRUE, pch=c(4,17)[(spasthma$Asthma == "case") + 1], cex=c(0.6, 0.75)[(spasthma$Asthma == "case") + 1])
plot(spsrc, pch=22, add=TRUE, cex=1.2, bg="grey60")



###################################################
### code chunk number 36: point_patterns.Rnw:1223-1248
###################################################
bwasthma <- .125 #.275

library(maptools)
sG <- Sobj_SpatialGrid(spbdry, maxDim=50)$SG
gt <- slot(sG, "grid")
summary(gt)

pbdry <- slot(slot(slot(spbdry, "polygons")[[1]], "Polygons")[[1]], "coords")

library(splancs)
cases<-spasthma[spasthma$Asthma=="case",]
ncases<-nrow(cases)
controls<-spasthma[spasthma$Asthma=="control",]
ncontrols<-nrow(controls)

kcases<-spkernel2d(cases, pbdry, h0=bwasthma, gt)
kcontrols<-spkernel2d(controls, pbdry, h0=bwasthma, gt)

df0 <- data.frame(kcases=kcases, kcontrols=kcontrols)
spkratio0 <- SpatialGridDataFrame(gt, data=df0)
spkratio <- as(spkratio0, "SpatialPixelsDataFrame")
spkratio$kratio <- spkratio$kcases/spkratio$kcontrols
is.na(spkratio$kratio) <- !is.finite(spkratio$kratio)
spkratio$logratio <- log(spkratio$kratio)-log(ncases/ncontrols)



###################################################
### code chunk number 37: point_patterns.Rnw:1258-1259
###################################################
print(spplot(spkratio, "kratio"))


###################################################
### code chunk number 38: point_patterns.Rnw:1274-1298
###################################################
idxinbdry <- overlay(sG, spbdry)
idxna <- !is.na(idxinbdry)

niter <- 99
ratio <- rep(NA, niter)
pvaluemap <- rep(0, sum(idxna))
rlabelratio <- matrix(NA, nrow=niter, ncol=sum(idxna))

for(i in 1:niter)
{
      idxrel <- sample(spasthma$Asthma) == "case"
      casesrel <- spasthma[idxrel,]
      controlsrel <- spasthma[!idxrel,]
 
      kcasesrel <- spkernel2d(casesrel, pbdry, h0=bwasthma, gt)
      kcontrolsrel <- spkernel2d(controlsrel, pbdry, h0=bwasthma, gt)
      kratiorel <- kcasesrel[idxna]/kcontrolsrel[idxna]
         is.na(kratiorel) <- !is.finite(kratiorel)
      rlabelratio[i,] <- kratiorel
 
      pvaluemap <- pvaluemap + (spkratio$kratio < kratiorel)
}
#save(pvaluemap, rlabelratio, file="sppaRlabelratio.RData")



###################################################
### code chunk number 39: point_patterns.Rnw:1308-1322
###################################################
idxna2 <- apply(rlabelratio, 2, function(x) all(is.finite(x)))
rhomean <- apply(rlabelratio[, idxna2], 2, mean)
c <- prod(slot(gt, "cellsize"))
ratiorho <- c*sum((spkratio$kratio[idxna2]-ncases/ncontrols)^2)
ratio <- c*apply(rlabelratio[,idxna2], 1,
 function(X, rho0 ){sum((X-rho0)^2)}, rho0=ncases/ncontrols
)
pvaluerho <- (sum(ratio > ratiorho)+1)/(niter+1)

spkratio$pvaluemap <- (pvaluemap+1)/(niter+1)
imgpvalue <- as.image.SpatialGridDataFrame(spkratio["pvaluemap"])
clpvalue <- contourLines(imgpvalue, levels=c(0,.05, .95, 1))
cl <- ContourLines2SLDF(clpvalue)



###################################################
### code chunk number 40: point_patterns.Rnw:1333-1348
###################################################
library(RColorBrewer)
cl05 <- cl[cl$level == "0.05",]
xzx <- slot(slot(cl05, "lines")[[1]], "Lines")
cl05a <- SpatialLines(list(Lines(xzx, ID="0.05")))
lyt05 <- list("sp.lines", cl05a, lwd=2, lty=2, col="grey95")
lyt95 <- list("sp.lines", cl[cl$level == "0.95",], lwd=2, lty=1)
lytb <- list("sp.polygons", spbdry)
lytp <- list("sp.points", spsrc, cex=0.9, pch=4, col="grey95", lwd=3)
brks <- quantile(spkratio$kratio[spkratio$kratio>0], seq(0,1,1/10), na.rm=TRUE)
brks[1] <- 0
lbrks <- formatC(brks, 3, 6, "g", " ")
cols <- colorRampPalette(grey.colors(5, 0.95, 0.55, 2.2))(length(brks)-1)
# RSB quietening greys
colorkey<-list(labels=lbrks,
  at=(0:10)/10, height=.5)


###################################################
### code chunk number 41: point_patterns.Rnw:1355-1364
###################################################
print(spplot(spkratio, "kratio",
   col.regions=cols,
   do.log=TRUE,
   colorkey=colorkey,
   at=c(0, brks[-c(1,11)], max(spkratio$kratio, na.rm=TRUE)),
   sp.layout=list(lyt05, lyt95, lytb, lytp)
))




###################################################
### code chunk number 42: point_patterns.Rnw:1401-1421
###################################################
spasthma$y <- as.integer(!as.integer(spasthma$Asthma)-1)
spasthma$HayFeverf<- as.factor(spasthma$HayFever)


glmasthma<-glm(y~HayFeverf, data=spasthma, family="binomial")
prob<-fitted(glmasthma)
weights<-exp(glmasthma$linear.predictors)
#weights<-fitted(glmasthma)
library(spatialkernel)
setkernel("gaussian")
lambda0<- lambdahat(coordinates(controls), bwasthma, coordinates(cases),
   pbdry, FALSE)$lambda
lambda1<- weights[spasthma$Asthma=="case"]*lambda0

ratiocc<-ncases/ncontrols

s<-seq(0, .15, by=.01)

kihnocov<-kinhat(coordinates(cases), ratiocc*lambda0, pbdry,s)$k
kih<-kinhat(coordinates(cases), lambda1, pbdry,s)$k


###################################################
### code chunk number 43: point_patterns.Rnw:1457-1476
###################################################
niter<-99
 
 kinhomrelnocov<-matrix(NA, nrow=length(s), ncol=niter)
 kinhomrel<-matrix(NA, nrow=length(s), ncol=niter)
 
 for(i in 1:niter)
 {
         idxrel<-sample(spasthma$Asthma, prob=prob)=="case"
         casesrel<-coordinates(spasthma[idxrel,])
         controlsrel<-coordinates(spasthma[!idxrel,])
 
      lambda0rel<-lambdahat(controlsrel, bwasthma, casesrel, pbdry, FALSE)$lambda
      lambda1rel<-weights[idxrel]*lambda0rel
 
      kinhomrelnocov[,i]<-kinhat(casesrel, ratiocc*lambda0rel, pbdry,s)$k
      kinhomrel[,i]<-kinhat(casesrel, lambda1rel, pbdry,s)$k
 
 }
#    save(kinhomrelnocov, kinhomrel, file="sppaKinhom.RData")


###################################################
### code chunk number 44: point_patterns.Rnw:1487-1497
###################################################

kinhsdnocov<-apply(kinhomrelnocov, 1, sd)
kihmeannocov<-apply(kinhomrelnocov, 1,mean)

D0nocov<-sum((kihnocov-kihmeannocov)/kinhsdnocov)
Dnocov<-apply(kinhomrelnocov, 2,
   function(X){ sum((X-kihmeannocov)/kinhsdnocov)})

pvaluenocov<-(sum(Dnocov>D0nocov)+1)/(niter+1)



###################################################
### code chunk number 45: point_patterns.Rnw:1505-1514
###################################################
kinhsd<-apply(kinhomrel, 1, sd)
kihmean<-apply(kinhomrel, 1,mean)

D0<-sum((kih-kihmean)/kinhsd)
D<-apply(kinhomrel, 2,
   function(X){ sum((X-kihmean)/kinhsd)})

pvalue<-(sum(D>D0)+1)/(niter+1)



###################################################
### code chunk number 46: point_patterns.Rnw:1523-1542
###################################################

par(mfrow=c(1,2))
plot(s, kihnocov-kihmeannocov, type="l",
   ylim= c(-0.06,  0.22),
   xlab="s", ylab= expression(hat(k)[I][","][hat(lambda)]-"E[s]"),
    main ="No covariates" )

envnocov<-apply(kinhomrelnocov, 1, function(X){quantile(X, c(.025, .975))})
lines(s, envnocov[1,]-kihmeannocov, lty=2)
lines(s, envnocov[2,]-kihmeannocov, lty=2)
plot(s, kih-kihmean, type="l", ylim=c(-0.06,  0.22), #c(-2e-4, 2e-4),
   xlab="s", ylab= expression(hat(k)[I][","][hat(lambda)]-"E[s]"),
   main ="Adjusting for Hay Fever"  )

env<-apply(kinhomrel, 1, function(X){quantile(X, c(.025, .975))})
lines(s, env[1,]-kihmean, lty=2)
lines(s, env[2,]-kihmean, lty=2)




###################################################
### code chunk number 47: point_patterns.Rnw:1587-1588
###################################################
save(file="results/pp.RData", list=ls())


