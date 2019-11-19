### R code from vignette source 'geos.Rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: geos.Rnw:6-7
###################################################
library(mgcv)#Loaded here to avoid a clash later


###################################################
### code chunk number 2: geos.Rnw:138-139
###################################################
options(width=36)


###################################################
### code chunk number 3: geos.Rnw:142-147
###################################################
library(rgdal)
BMcD <- readOGR("datasets", "BMcD")
BMcD$Fldf <- factor(BMcD$Fldf)
names(BMcD)
proj4string(BMcD) <- CRS("+init=epsg:28992")


###################################################
### code chunk number 4: geos.Rnw:150-151
###################################################
options(width=60)


###################################################
### code chunk number 5: geos.Rnw:170-171
###################################################
print(bubble(BMcD, "Zn"))


###################################################
### code chunk number 6: geos.Rnw:179-180 (eval = FALSE)
###################################################
## bubble(BMcD, "Zn")


###################################################
### code chunk number 7: geos.Rnw:193-194
###################################################
print(boxplot(Zn ~ Fldf, BMcD, width=table(BMcD$Fldf), col="grey"))


###################################################
### code chunk number 8: geos.Rnw:203-204
###################################################
options(width=36)


###################################################
### code chunk number 9: geos.Rnw:207-208 (eval = FALSE)
###################################################
## boxplot(Zn ~ Fldf, BMcD, width=table(BMcD$Fldf), col="grey")


###################################################
### code chunk number 10: geos.Rnw:211-212
###################################################
options(width=60)


###################################################
### code chunk number 11: geos.Rnw:227-231
###################################################
oopar <- par(mfrow=c(4,1))
plot(density(BMcD$Zn), main="", xlim=c(0,2000), lwd=2)
tull <- by(as(BMcD, "data.frame"), BMcD$Fldf, function(x) plot(density(x$Zn), main="", xlim=c(0,2000), lwd=2))
par(oopar)


###################################################
### code chunk number 12: geos.Rnw:240-241
###################################################
options(width=36)


###################################################
### code chunk number 13: geos.Rnw:244-246 (eval = FALSE)
###################################################
## plot(density(BMcD$Zn), main="", xlim=c(0,2000), lwd=2)
## by(as(BMcD, "data.frame"), BMcD$Fldf, function(x) plot(density(x$Zn), main="", xlim=c(0,2000), lwd=2))


###################################################
### code chunk number 14: geos.Rnw:249-250
###################################################
options(width=60)


###################################################
### code chunk number 15: geos.Rnw:270-271
###################################################
options(width=30)


###################################################
### code chunk number 16: geos.Rnw:274-279
###################################################
BMcD_grid <- as(readGDAL("datasets/BMcD_fldf.txt"), 
   "SpatialPixelsDataFrame")
names(BMcD_grid) <- "Fldf"
BMcD_grid$Fldf <- as.factor(BMcD_grid$Fldf)
proj4string(BMcD_grid) <- CRS("+init=epsg:28992")


###################################################
### code chunk number 17: geos.Rnw:281-283 (eval = FALSE)
###################################################
## pts = list("sp.points", BMcD, pch = 4, col = "white")
## spplot(BMcD_grid, "Fldf", col.regions=1:3, sp.layout=list(pts))


###################################################
### code chunk number 18: geos.Rnw:286-287
###################################################
options(width=60)


###################################################
### code chunk number 19: geos.Rnw:294-296
###################################################
pts = list("sp.points", BMcD, pch = 4, col = "white")
print(spplot(BMcD_grid, "Fldf", col.regions=1:3, sp.layout=list(pts)))


###################################################
### code chunk number 20: geos.Rnw:310-311
###################################################
options("width"=100)


###################################################
### code chunk number 21: geos.Rnw:313-324
###################################################
crds <- coordinates(BMcD)
poly <- crds[chull(crds),]
poly <- rbind(poly, poly[1,])
SPpoly <- SpatialPolygons(list(Polygons(list(Polygon(poly)), ID="poly")))
bbox(BMcD)
(apply(bbox(BMcD), 1, diff) %/% 50) + 1
grd <- GridTopology(c(178600, 330300), c(50,50), c(48, 41))
SG <- SpatialGrid(grd)
inside <- overlay(SG, SPpoly)
SGDF <- SpatialGridDataFrame(grd, data=data.frame(list(ins=inside)))
SPDF <- as(SGDF, "SpatialPixelsDataFrame")


###################################################
### code chunk number 22: geos.Rnw:326-327
###################################################
options("width"=36)


###################################################
### code chunk number 23: geos.Rnw:338-341
###################################################
plot(BMcD, axes=TRUE)
plot(SPpoly, add=TRUE)
plot(SPDF, col="red", add=TRUE)


###################################################
### code chunk number 24: geos.Rnw:349-352 (eval = FALSE)
###################################################
## plot(BMcD, axes=TRUE)
## plot(SPpoly, add=TRUE)
## plot(SPDF, col="red", add=TRUE)


###################################################
### code chunk number 25: geos.Rnw:366-367
###################################################
options("width"=100)


###################################################
### code chunk number 26: geos.Rnw:369-376
###################################################
bluepal <- colorRampPalette(c("azure1", "steelblue4"))
brks <- c(0,130,155,195,250,330,450,630,890,1270,1850)
cols <- bluepal(length(brks)-1)
sepal <- colorRampPalette(c("peachpuff1", "tomato3"))
brks.se <- c(0,240,250,260,270,280,290,300,350,400,1000)
cols.se <- sepal(length(brks.se)-1)
scols <- c("green", "red")


###################################################
### code chunk number 27: geos.Rnw:378-379
###################################################
options("width"=36)


###################################################
### code chunk number 28: geos.Rnw:392-394
###################################################
options("width"=80, "show.signif.stars"=FALSE)



###################################################
### code chunk number 29: geos.Rnw:396-405
###################################################
library(ipred)
res <- errorest(Zn ~ 1, data = as(BMcD, "data.frame"), model=lm, est.para=control.errorest(k=nrow(BMcD), 
   random=FALSE, predictions=TRUE))
round(res$error, 2)
fres <- lm(Zn ~ Fldf, data=BMcD)
anova(fres)
eres <- errorest(Zn ~ Fldf, data = as(BMcD, "data.frame"), model=lm, est.para=control.errorest(k=nrow(BMcD), 
   random=FALSE, predictions=TRUE))
round(eres$error, 2)


###################################################
### code chunk number 30: geos.Rnw:407-408
###################################################
options("width"=36)


###################################################
### code chunk number 31: geos.Rnw:419-428
###################################################
library(maptools)
BMcD_grid$lm_pred <- predict(fres, newdata=BMcD_grid)
image(BMcD_grid, "lm_pred", breaks=brks, col=cols)
title("Flood frequency model interpolation")
pe <- BMcD$Zn-eres$predictions
symbols(coordinates(BMcD), circles=sqrt(abs(pe)), 
   fg="black", bg=scols[(pe < 0)+1], inches=FALSE, add=TRUE)
legend("topleft", fill=cols, legend=leglabs(brks), 
   bty="n", cex=0.8)


###################################################
### code chunk number 32: geos.Rnw:436-443 (eval = FALSE)
###################################################
## library(maptools)
## BMcD_grid$lm_pred <- predict(fres, newdata=BMcD_grid)
## image(BMcD_grid, "lm_pred", breaks=brks, col=cols)
## title("Flood frequency model interpolation")
## pe <- BMcD$Zn-eres$predictions
## symbols(coordinates(BMcD), circles=sqrt(abs(pe)), fg="black", bg=scols[(pe < 0)+1], inches=FALSE, add=TRUE)
## legend("topleft", fill=cols, legend=leglabs(brks), bty="n", cex=0.8)


###################################################
### code chunk number 33: geos.Rnw:457-458
###################################################
options("width"=100)


###################################################
### code chunk number 34: geos.Rnw:460-470
###################################################
library(fields)
pe_tps <- numeric(nrow(BMcD))
cBMcD <- coordinates(BMcD)
for (i in seq(along=pe_tps)) {
  tpsi <- Tps(cBMcD[-i,], BMcD$Zn[-i])
  pri <- predict(tpsi, cBMcD[i,,drop=FALSE])
  pe_tps[i] <- BMcD$Zn[i]-pri
}
round(sqrt(mean(pe_tps^2)), 2)
tps <- Tps(coordinates(BMcD), BMcD$Zn)


###################################################
### code chunk number 35: geos.Rnw:472-473
###################################################
options("width"=36)


###################################################
### code chunk number 36: geos.Rnw:485-491
###################################################
BMcD_grid$spl_pred <- predict(tps, 
   coordinates(BMcD_grid))
image(BMcD_grid, "spl_pred", breaks=brks, col=cols)
title("Thin plate spline model")
symbols(coordinates(BMcD), circles=sqrt(abs(pe_tps)), fg="black", bg=scols[(pe_tps < 0)+1], inches=FALSE, add=TRUE)
legend("topleft", fill=cols, legend=leglabs(brks), bty="n", cex=0.8)


###################################################
### code chunk number 37: geos.Rnw:499-501 (eval = FALSE)
###################################################
## BMcD_grid$spl_pred <- predict(tps, coordinates(BMcD_grid))
## image(BMcD_grid, "spl_pred", breaks=brks, col=cols)


###################################################
### code chunk number 38: geos.Rnw:517-522
###################################################
library(gstat)
cvgm <- variogram(Zn~1, data=BMcD, width=100, cutoff=1000)
efitted <- fit.variogram(cvgm, vgm(psill=1, model="Exp", 
   range=100, nugget=1))
efitted


###################################################
### code chunk number 39: geos.Rnw:528-529
###################################################
print(plot(cvgm, model=efitted, plot.numbers=TRUE, col="black"))


###################################################
### code chunk number 40: geos.Rnw:611-612
###################################################
options("width"=100)


###################################################
### code chunk number 41: geos.Rnw:614-620
###################################################
OK_fit <- gstat(id="OK_fit", formula = Zn ~ 1, data = BMcD, model=efitted)
pe <- gstat.cv(OK_fit,  nfold=nrow(OK_fit$data[[1]]$data), debug.level=0, random=FALSE)$residual
round(sqrt(mean(pe^2)), 2)
z <- predict(OK_fit, newdata=BMcD_grid, debug.level=0)
BMcD_grid$OK_pred <- z$OK_fit.pred
BMcD_grid$OK_se <- sqrt(z$OK_fit.var)


###################################################
### code chunk number 42: geos.Rnw:622-623
###################################################
options("width"=36)


###################################################
### code chunk number 43: geos.Rnw:634-638
###################################################
image(BMcD_grid, "OK_pred", breaks=brks, col=cols)
title("Fitted exponential OK model")
symbols(coordinates(BMcD), circles=sqrt(abs(pe)), fg="black", bg=scols[(pe < 0)+1], inches=FALSE, add=TRUE)
legend("topleft", fill=cols, legend=leglabs(brks), bty="n", cex=0.8)


###################################################
### code chunk number 44: geos.Rnw:646-647 (eval = FALSE)
###################################################
## image(BMcD_grid, "OK_pred", breaks=brks, col=cols)


###################################################
### code chunk number 45: geos.Rnw:660-664
###################################################
image(BMcD_grid, "OK_se", breaks=brks.se, col=cols.se)
title("Fitted exponential OK standard errors")
symbols(coordinates(BMcD), circles=sqrt(abs(pe)), fg="black", bg=scols[(pe < 0)+1], inches=FALSE, add=TRUE)
legend("topleft", fill=cols.se, legend=leglabs(brks.se), bty="n", cex=0.8)


###################################################
### code chunk number 46: geos.Rnw:672-673 (eval = FALSE)
###################################################
## image(BMcD_grid, "OK_se", breaks=brks.se, col=cols.se)


###################################################
### code chunk number 47: geos.Rnw:712-717
###################################################
cvgm <- variogram(Zn~Fldf, data=BMcD, width=100, 
   cutoff=1000)
uefitted <- fit.variogram(cvgm, vgm(psill=1, model="Exp", 
   range=100, nugget=1))
uefitted


###################################################
### code chunk number 48: geos.Rnw:723-724
###################################################
print(plot(cvgm, model=uefitted, plot.numbers=TRUE, col="black"))


###################################################
### code chunk number 49: geos.Rnw:736-737
###################################################
options("width"=100)


###################################################
### code chunk number 50: geos.Rnw:739-745
###################################################
UK_fit <- gstat(id="UK_fit", formula = Zn ~ Fldf, data = BMcD, model=uefitted)
pe_UK <- gstat.cv(UK_fit, nfold=nrow(UK_fit$data[[1]]$data), debug.level=0, random=FALSE)$residual
round(sqrt(mean(pe_UK^2)), 2)
z <- predict(UK_fit, newdata=BMcD_grid, debug.level=0)
BMcD_grid$UK_pred <- z$UK_fit.pred
BMcD_grid$UK_se <- sqrt(z$UK_fit.var)


###################################################
### code chunk number 51: geos.Rnw:747-748
###################################################
options("width"=36)


###################################################
### code chunk number 52: geos.Rnw:759-763
###################################################
image(BMcD_grid, "UK_pred", breaks=brks, col=cols)
title("Flood frequency UK model")
symbols(coordinates(BMcD), circles=sqrt(abs(pe_UK)), fg="black", bg=scols[(pe_UK < 0)+1], inches=FALSE, add=TRUE)
legend("topleft", fill=cols, legend=leglabs(brks), bty="n", cex=0.8)


###################################################
### code chunk number 53: geos.Rnw:771-772 (eval = FALSE)
###################################################
## image(BMcD_grid, "UK_pred", breaks=brks, col=cols)


###################################################
### code chunk number 54: geos.Rnw:785-789
###################################################
image(BMcD_grid, "UK_se", breaks=brks.se, col=cols.se)
title("Flood frequency UK interpolation standard errors")
symbols(coordinates(BMcD), circles=sqrt(abs(pe_UK)), fg="black", bg=scols[(pe_UK < 0)+1], inches=FALSE, add=TRUE)
legend("topleft", fill=cols.se, legend=leglabs(brks.se), bty="n", cex=0.8)


###################################################
### code chunk number 55: geos.Rnw:797-798 (eval = FALSE)
###################################################
## image(BMcD_grid, "UK_se", breaks=brks.se, col=cols.se)


###################################################
### code chunk number 56: geos.Rnw:811-814
###################################################
pts = list("sp.points", BMcD, pch = 4, col = "black", 
   cex=0.5)
print(spplot(BMcD_grid, c("lm_pred", "spl_pred", "OK_pred", "UK_pred"), at=brks, col.regions=cols, sp.layout=list(pts)) )


###################################################
### code chunk number 57: geos.Rnw:822-826 (eval = FALSE)
###################################################
## pts = list("sp.points", BMcD, pch = 4, col = "black", 
##    cex=0.5)
## spplot(BMcD_grid, c("lm_pred", "spl_pred", "OK_pred", 
##    "UK_pred"), at=brks, col.regions=cols, sp.layout=list(pts))


###################################################
### code chunk number 58: geos.Rnw:840-841
###################################################
options("width"=100)


###################################################
### code chunk number 59: geos.Rnw:843-844 (eval = FALSE)
###################################################
## writeGDAL(BMcD_grid["UK_pred"], "UK_pred.tif")


###################################################
### code chunk number 60: geos.Rnw:846-847
###################################################
options("width"=36)


###################################################
### code chunk number 61: geos.Rnw:865-866
###################################################
options("width"=90)


###################################################
### code chunk number 62: geos.Rnw:868-884
###################################################
library(maptools)
grd <- as(BMcD_grid, "SpatialPolygons")
proj4string(grd) <- CRS(proj4string(BMcD))
grd.union <- unionSpatialPolygons(grd, rep("x", length(slot(grd, "polygons"))))
grd.union.ll <- spTransform(grd.union, CRS("+proj=longlat"))
llGRD <- GE_SpatialGrid(grd.union.ll, maxPixels = 100)
llGRD_in <- overlay(llGRD$SG, grd.union.ll)
llSPix <- as(SpatialGridDataFrame(grid=slot(llGRD$SG, "grid"), proj4string=CRS(proj4string(llGRD$SG)), data=data.frame(in0=llGRD_in)), "SpatialPixelsDataFrame")
SPix <- spTransform(llSPix, CRS("+init=epsg:28992"))
z <- predict(OK_fit, newdata=SPix, debug.level=0)
llSPix$pred <- z$OK_fit.pred
png(file="zinc_OK.png", width=llGRD$width, height=llGRD$height, bg="transparent")
par(mar=c(0,0,0,0), xaxs="i", yaxs="i")
image(llSPix, "pred", col=bpy.colors(20))
dev.off()
kmlOverlay(llGRD, "zinc_OK.kml", "zinc_OK.png")


###################################################
### code chunk number 63: geos.Rnw:886-887
###################################################
options("width"=36)


###################################################
### code chunk number 64: geos.Rnw:962-968
###################################################
SPDFgrd<- as(BMcD_grid, "SpatialPolygonsDataFrame")

idxgrd<- over(BMcD, as(SPDFgrd, "SpatialPolygons"))

SPDFgrd$Zn<-NA
SPDFgrd$Zn[idxgrd] <- BMcD$Zn


###################################################
### code chunk number 65: geos.Rnw:991-1003
###################################################
#Adjacency
library(spdep)
meusenb<-poly2nb(SPDFgrd, queen=TRUE)
Wadj<-nb2INLA("meuseadj.txt", meusenb)

#Wadj<-as(nb2mat(meusenb, style="B"), "sparseMatrix")

lw <- nb2listw(meusenb, style="B")
Wadj <- as(as_dgRMatrix_listw(lw), "CsparseMatrix")

#Index for random effect
SPDFgrd$IDX<-1:nrow(SPDFgrd)


###################################################
### code chunk number 66: geos.Rnw:1029-1046
###################################################
#Fit model
library(INLA)
if(!file.exists("results/INLA-geos.RData")) {

meuseinla<-inla(Zn ~Fldf+f(IDX, model="bym", graph=Wadj),
   control.predictor=list(compute=TRUE),
   data=as(SPDFgrd, "data.frame") )

save(file="results/INLA-geos.RData", list=c("meuseinla"))

} else{
   load("results/INLA-geos.RData")
}

BMcD_grid$INLA_pred<-meuseinla$summary.fitted.values[, "mean"]
BMcD_grid$INLA_sd<-meuseinla$summary.fitted.values[, "sd"]



###################################################
### code chunk number 67: inlapred (eval = FALSE)
###################################################
## image(BMcD_grid, "INLA_pred", breaks=brks, col=cols)
## legend("topleft", fill=cols, legend=leglabs(brks), 
##    bty="n", cex=0.8)


###################################################
### code chunk number 68: geos.Rnw:1065-1066
###################################################
image(BMcD_grid, "INLA_pred", breaks=brks, col=cols)
legend("topleft", fill=cols, legend=leglabs(brks), 
   bty="n", cex=0.8)


###################################################
### code chunk number 69: geos.Rnw:1073-1074 (eval = FALSE)
###################################################
## image(BMcD_grid, "INLA_pred", breaks=brks, col=cols)
## legend("topleft", fill=cols, legend=leglabs(brks), 
##    bty="n", cex=0.8)


###################################################
### code chunk number 70: inlapredsd (eval = FALSE)
###################################################
## image(BMcD_grid, "INLA_sd", breaks=brks.se, 
##    col=cols.se)
## legend("topleft", fill=cols.se, legend=leglabs(brks.se), bty="n", cex=0.8)


###################################################
### code chunk number 71: geos.Rnw:1095-1096
###################################################
image(BMcD_grid, "INLA_sd", breaks=brks.se, 
   col=cols.se)
legend("topleft", fill=cols.se, legend=leglabs(brks.se), bty="n", cex=0.8)


###################################################
### code chunk number 72: geos.Rnw:1103-1104 (eval = FALSE)
###################################################
## image(BMcD_grid, "INLA_sd", breaks=brks.se, 
##    col=cols.se)
## legend("topleft", fill=cols.se, legend=leglabs(brks.se), bty="n", cex=0.8)


###################################################
### code chunk number 73: geos.Rnw:1127-1145
###################################################

#WinBUGS directory
BugsDir <- "/home/virgil/.wine/dosdevices/c:/Program Files/WinBUGS14"

N<-nrow(SPDFgrd)

WBnb<-nb2WB(meusenb)


d<-list(N=N, observed=SPDFgrd$Zn, 
  adj=WBnb$adj,  weights=WBnb$weights, num=WBnb$num)

#Add flood depth
d$cov1<-as.numeric(SPDFgrd$Fldf=="2")
d$cov2<-as.numeric(SPDFgrd$Fldf=="3")

inits<-list(u=rep(0,N), v=rep(0,N), alpha=0, prec=1, precu=.001, precv=.001,
   beta1=0, beta2=0)


###################################################
### code chunk number 74: geos.Rnw:1155-1178
###################################################
bymmodelfile<-paste(getwd(), "/models/bym-geos.txt", sep="")
wdir<-paste(getwd(), "/results/BYM-geos", sep="")
if(!file.exists(wdir)){dir.create(wdir)}

library(R2WinBUGS)

if(!file.exists("results/WB-geos.RData")) {
MCMCres<- bugs(data=d, inits=list(inits),
   working.directory=wdir,
   #parameters.to.save=c("mu", "alpha", "u", "v", "sigma", "sigmau", "sigmav"),
   parameters.to.save=c("mu"),
   n.chains=1, n.iter=2000, n.burnin=500, n.thin=5,
   model.file=bymmodelfile,
   bugs.directory=BugsDir)
save(file="results/WB-geos.RData", list=c("MCMCres"))
} else{
	load("results/WB-geos.RData")
}


BMcD_grid$WB_pred<-MCMCres$summary[1:d$N,"mean"]
BMcD_grid$WB_sd<-MCMCres$summary[1:d$N,"sd"]



###################################################
### code chunk number 75: WBpred (eval = FALSE)
###################################################
## print(image(BMcD_grid, "WB_pred", breaks=brks, col=cols))
## legend("topleft", fill=cols, legend=leglabs(brks), bty="n", cex=0.8)


###################################################
### code chunk number 76: geos.Rnw:1194-1195
###################################################
print(image(BMcD_grid, "WB_pred", breaks=brks, col=cols))
legend("topleft", fill=cols, legend=leglabs(brks), bty="n", cex=0.8)


###################################################
### code chunk number 77: geos.Rnw:1203-1204 (eval = FALSE)
###################################################
## print(image(BMcD_grid, "WB_pred", breaks=brks, col=cols))
## legend("topleft", fill=cols, legend=leglabs(brks), bty="n", cex=0.8)


###################################################
### code chunk number 78: WBsd (eval = FALSE)
###################################################
## print(image(BMcD_grid, "WB_sd", breaks=brks.se, col=cols.se))
## legend("topleft", fill=cols.se, legend=leglabs(brks.se), bty="n", cex=0.8)


###################################################
### code chunk number 79: geos.Rnw:1225-1226
###################################################
print(image(BMcD_grid, "WB_sd", breaks=brks.se, col=cols.se))
legend("topleft", fill=cols.se, legend=leglabs(brks.se), bty="n", cex=0.8)


###################################################
### code chunk number 80: geos.Rnw:1234-1235 (eval = FALSE)
###################################################
## print(image(BMcD_grid, "WB_sd", breaks=brks.se, col=cols.se))
## legend("topleft", fill=cols.se, legend=leglabs(brks.se), bty="n", cex=0.8)


###################################################
### code chunk number 81: geos.Rnw:1247-1250
###################################################
print(spplot(BMcD_grid, 
   c( "lm_pred", "spl_pred", "OK_pred", "UK_pred", "INLA_pred", "WB_pred"), 
   col.regions=cols, at=brks))


###################################################
### code chunk number 82: geos.Rnw:1310-1333
###################################################

idxobs<- !is.na(SPDFgrd$Zn)
Nfit<-sum(idxobs)
#Npred<-sum(!idxobs)
Npred<-10#Use 10 points only

dspat<-list(Nfit=Nfit, Npred=Npred, observed=SPDFgrd$Zn[idxobs],
   xx= (SPDFgrd$xx[idxobs]-min(SPDFgrd$xx))/2400, 
   yy= (SPDFgrd$yy[idxobs]-min(SPDFgrd$yy))/2400 ) 

#Add flood depth
dspat$cov1<-as.numeric(SPDFgrd$Fldf[idxobs]=="2")
dspat$cov2<-as.numeric(SPDFgrd$Fldf[idxobs]=="3")

#Data for prediction
dspat$covpred1<-as.numeric(SPDFgrd$Fldf[!idxobs]=="2")
dspat$covpred2<-as.numeric(SPDFgrd$Fldf[!idxobs]=="3")
dspat$x.pred<-(SPDFgrd$xx[!idxobs]-min(SPDFgrd$xx))/2400
dspat$y.pred<-(SPDFgrd$yy[!idxobs]-min(SPDFgrd$yy))/2400


initsspat<-list(tau=1 , phi=1, kappa=1 , alpha=0, beta1=0, beta2=0, 
   pred=rep(0, Npred))


###################################################
### code chunk number 83: geos.Rnw:1356-1375 (eval = FALSE)
###################################################
## spatpredmf<-paste(getwd(), "/models/spat_pred.txt", sep="")
## wdir<-paste(getwd(), "/results/spatpred-geos", sep="")
## if(!file.exists(wdir)){dir.create(wdir)}
## 
## library(R2WinBUGS)
## 
## if(!file.exists("results/spatpred-geos.RData")) {
## MCMCressp<- bugs(data=dspat, inits=list(initsspat),
##    working.directory=wdir,
##    #parameters.to.save=c("mu", "alpha", "u", "v", "sigma", "sigmau", "sigmav"),
##    parameters.to.save=c("pred"),
##    n.chains=1, n.iter=2000, n.burnin=500, n.thin=5,
##    model.file=spatpredmf,
##    bugs.directory=BugsDir
## )
## save(file="results/spatpredWB-geos.RData", list=c("MCMCressp"))
## } else{
##         load("results/spatpredWB-geos.RData")
## }


###################################################
### code chunk number 84: geos.Rnw:1378-1390 (eval = FALSE)
###################################################
## spatpredmf<-paste(getwd(), "/models/spat_pred.txt", sep="")
## wdir<-paste(getwd(), "/results/spatpred-geos", sep="")
## 
## library(R2WinBUGS)
## 
## MCMCressp<- bugs(data=dspat, inits=list(initsspat),
##    working.directory=wdir,
##    parameters.to.save=c("pred"),
##    n.chains=1, n.iter=2000, n.burnin=500, n.thin=5,
##    model.file=spatpredmf,
##    bugs.directory=BugsDir
## )


###################################################
### code chunk number 85: geos.Rnw:1394-1398 (eval = FALSE)
###################################################
## library(coda)
## MCMCres<-read.coda("results/spatpred-geos/coda1.txt", 
##    "results/spatpred-geos/codaIndex1.txt")
## summary(MCMCres)


###################################################
### code chunk number 86: geos.Rnw:1438-1473
###################################################

library(R2BayesX)

attr(meusenb, "region.id")<-1:length(meusenb)
meusegra <- nb2gra(meusenb)

SPDFgrd$IDXSP <- as.numeric(rownames(meusegra))#Index for spatial effect

#Coordinates
SPDFgrd$xx<-coordinates(SPDFgrd)[,1]
SPDFgrd$yy<-coordinates(SPDFgrd)[,2]



if(!file.exists("results/bayesx-geos.RData")) {

meusebayesx <- bayesx(Zn ~ Fldf+ sx(IDX, bs = "re") + 
   sx(xx, yy, bs = "te"),
#   sx(IDXSP, bs = "spatial", map = meusegra),
   data = as(SPDFgrd, "data.frame")[idxobs,] )

#Prediction
predbayesx<-predict(meusebayesx, as(SPDFgrd, "data.frame")[!idxobs,])

save(file="results/bayesx-geos.RData", list=c("meusebayesx", "predbayesx"))

} else{
   load("results/bayesx-geos.RData")
}

BMcD_grid$"BAYESX_pred"<-NA
BMcD_grid$"BAYESX_pred"[idxobs]<-meusebayesx$fitted.values[order(meusebayesx$bayesx.setup$order),2]
BMcD_grid$"BAYESX_pred"[!idxobs]<-predbayesx




###################################################
### code chunk number 87: geos.Rnw:1484-1488
###################################################
print(spplot(BMcD_grid, 
   c( "lm_pred", "spl_pred", "OK_pred", "UK_pred", "INLA_pred", 
   "WB_pred", "BAYESX_pred"), 
   col.regions=cols, at=brks))


