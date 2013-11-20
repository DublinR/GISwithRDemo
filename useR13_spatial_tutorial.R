### R code from vignette source 'useR13_spatial_tutorial.Rnw'
### Encoding: UTF-8
# packages: sp rgdal RColorBrewer classInt DCluster INLA rgeos maptools spdep
# raster CARBayes
#
# data: Prem_mort_sim setor1 UTM_dem.tif DEM_out.tif stream1 L8s.tif
# L_ETMps.tif 
###################################################
### code chunk number 17: useR13_spatial_tutorial.Rnw:151-157
###################################################
library(rgdal)
sm <- readOGR(".", "Prem_mort_sim")
sm1 <- sm[!is.na(sm$Value),]
library(RColorBrewer)
at <- c(200, 257, 268, 283, 505)
pal <- rev(brewer.pal(5, "RdYlGn")[-5])


###################################################
### code chunk number 18: useR13_spatial_tutorial.Rnw:165-168
###################################################
spplot(sm1, "Value", at=at, col.regions=pal, main="Premature mortalities per 100,000")


###################################################
### code chunk number 19: useR13_spatial_tutorial.Rnw:183-187
###################################################
library(classInt)
PHE <- classIntervals(sm1$Value, n=4, style="fixed", fixedBreaks=at)
Sd <- classIntervals(sm1$Value, n = 4, style = "sd")
fish <- classIntervals(sm1$Value, n=length(Sd$brks)-1, style="fisher")


###################################################
### code chunk number 20: useR13_spatial_tutorial.Rnw:191-198
###################################################
oopar <- par(mfrow=c(3,1), mar=c(2,1,3,1))
plot(PHE, pal=pal, main="PHE", xlab="", ylab="")
plot(Sd, pal=pal, main="S.D.", xlab="", ylab="")
plot(fish, pal=pal, main="Fisher", xlab="", ylab="")
par(oopar)


###################################################
### code chunk number 21: useR13_spatial_tutorial.Rnw:207-213
###################################################
at1 <- fish$brks
at1[1] <- at1[1] - at1[1]/100
at1[length(at1)] <- at1[length(at1)] + at1[length(at1)]/100
spplot(sm1, "Value", at=at1, col.regions=colorRampPalette(pal)(length(at1)-1), main="Premature mortalities per 100,000")


###################################################
### code chunk number 22: useR13_spatial_tutorial.Rnw:227-231
###################################################
at2 <- c(185, 257, 268, 283, 470)
spplot(sm1, c("Lowr_CI", "Value", "Uppr_CI"), at=at2, col.regions=pal, main="Premature mortalities per 100,000")


###################################################
### code chunk number 23: useR13_spatial_tutorial.Rnw:254-257
###################################################
plot(I(Uppr_CI-Lowr_CI) ~ Denmntr, data=sm1)


###################################################
### code chunk number 24: useR13_spatial_tutorial.Rnw:276-287
###################################################
library(DCluster)
grt <- sum(sm1$Count)/sum(sm1$Denmntr)
sm1$Expected <- grt*(sm1$Denmntr)
sm1$EB_SMR <- empbaysmooth(sm1$Count, sm1$Expected)$smthrr
if(!("INLA" %in% .packages(all = TRUE))) source("http://www.math.ntnu.no/inla/givemeINLA.R")
library(INLA)
sm1$AREAID <- 1:nrow(sm1)
pginla <- inla(Count ~ offset(log(Expected)) -1 + f(AREAID, model = "iid"), family = "poisson", data = as(sm1, "data.frame"), control.predictor = list(compute = TRUE), control.compute = list(dic = TRUE))
sm1$PGINLA <- pginla$summary.fitted.values$mean/sm1$Expected
sm1$PGINLA_L <- pginla$summary.fitted.values[[3]]/sm1$Expected
sm1$PGINLA_U <- pginla$summary.fitted.values[[5]]/sm1$Expected


###################################################
### code chunk number 25: useR13_spatial_tutorial.Rnw:291-296
###################################################
at <- seq(0.5, 1.9, 0.1)
pal <- c(rev(brewer.pal(5, "Blues")), brewer.pal(9, "Reds"))
spplot(sm1, "EB_SMR", at=at, col.regions=pal, main="ML empirical Bayes SMR")


###################################################
### code chunk number 26: useR13_spatial_tutorial.Rnw:306-309
###################################################
spplot(sm1, "PGINLA", at=at, col.regions=pal, main="INLA Poisson-Gamma SMR")


###################################################
### code chunk number 27: useR13_spatial_tutorial.Rnw:325-328
###################################################
spplot(sm1, c("PGINLA_L", "PGINLA_U"), at=at, col.regions=pal, main="INLA CIs")


###################################################
### code chunk number 28: useR13_spatial_tutorial.Rnw:372-373
###################################################
library(rgdal)


###################################################
### code chunk number 29: useR13_spatial_tutorial.Rnw:385-387
###################################################
olinda <- readOGR(".", "setor1")
names(olinda)


###################################################
### code chunk number 32: useR13_spatial_tutorial.Rnw:404-407
###################################################
spplot(olinda, "DEPRIV", col.regions=grey.colors(20, 0.9, 0.3))


###################################################
### code chunk number 34: useR13_spatial_tutorial.Rnw:668-671
###################################################
olinda$Expected <- olinda$POP * sum(olinda$CASES, na.rm=TRUE) / sum(olinda$POP, na.rm=TRUE)
str(olinda, max.level=2)
str(as(olinda, "data.frame"))


###################################################
### code chunk number 37: useR13_spatial_tutorial.Rnw:694-695
###################################################
str(model.frame(CASES ~ DEPRIV + offset(log(POP)), olinda), give.attr=FALSE)


###################################################
### code chunk number 39: useR13_spatial_tutorial.Rnw:760-762
###################################################
library(sp)
getClass("GridTopology")


###################################################
### code chunk number 40: useR13_spatial_tutorial.Rnw:809-810
###################################################
options("width"=100)


###################################################
### code chunk number 41: useR13_spatial_tutorial.Rnw:812-815
###################################################
DEM <- readGDAL("UTM_dem.tif")
summary(DEM)
is.na(DEM$band1) <- DEM$band1 < 1


###################################################
### code chunk number 44: useR13_spatial_tutorial.Rnw:833-836
###################################################
image(DEM, "band1", axes=TRUE, col=terrain.colors(20))


###################################################
### code chunk number 46: useR13_spatial_tutorial.Rnw:969-972
###################################################
proj4string(olinda)
EPSG <- make_EPSG()
EPSG[grep("Corrego Alegre", EPSG$note), 1:2]


###################################################
### code chunk number 49: useR13_spatial_tutorial.Rnw:993-1000
###################################################
set_ReplCRS_warn(FALSE)
proj4string(olinda) <- CRS("+init=epsg:22525")
proj4string(olinda)
proj4string(DEM)
proj4string(DEM) <- CRS("+init=epsg:31985")
proj4string(DEM)
set_ReplCRS_warn(TRUE)


###################################################
### code chunk number 52: useR13_spatial_tutorial.Rnw:1024-1025
###################################################
olinda1 <- spTransform(olinda, CRS(proj4string(DEM)))


###################################################
### code chunk number 55: useR13_spatial_tutorial.Rnw:1043-1047
###################################################
image(DEM, "band1", axes=TRUE, col=terrain.colors(20))
plot(olinda1, add=TRUE, lwd=0.5)


###################################################
### code chunk number 56: useR13_spatial_tutorial.Rnw:1220-1223 (eval = FALSE)
###################################################
## library(spgrass6)
## myGRASS <- "/home/rsb/topics/grass/g642/grass-6.4.2"
## initGRASS(myGRASS, tempdir(), SG=DEM, override=TRUE)


###################################################
### code chunk number 57: useR13_spatial_tutorial.Rnw:1248-1253 (eval = FALSE)
###################################################
## writeRAST6(DEM, "dem", flags="o")
## execGRASS("g.region", rast="dem")
## execGRASS("r.resamp.rst", input="dem", ew_res=14.25, ns_res=14.25, elev="DEM_resamp", slope="slope", aspect="aspect")
## execGRASS("g.region", rast="DEM_resamp")
## DEM_out <- readRAST6(c("DEM_resamp", "slope", "aspect"))


###################################################
### code chunk number 58: useR13_spatial_tutorial.Rnw:1257-1264
###################################################
DEM_out <- readGDAL("DEM_out.tif")
names(DEM_out) <- c("DEM_resamp", "slope", "aspect")
set_ReplCRS_warn(FALSE)
proj4string(DEM_out) <- CRS("+init=epsg:31985")
stream1 <- readOGR(".", "stream1")
proj4string(stream1) <- CRS("+init=epsg:31985")
set_ReplCRS_warn(TRUE)


###################################################
### code chunk number 59: useR13_spatial_tutorial.Rnw:1288-1290 (eval = FALSE)
###################################################
## execGRASS("r.watershed", elevation="DEM_resamp", stream="stream", threshold=1000L, convergence=5L, memory=300L)
## execGRASS("r.thin", input="stream", output="stream1", iterations=200L)


###################################################
### code chunk number 60: useR13_spatial_tutorial.Rnw:1310-1312 (eval = FALSE)
###################################################
## execGRASS("r.to.vect", input="stream1", output="stream", feature="line")
## stream1 <- readVECT6("stream")


###################################################
### code chunk number 61: useR13_spatial_tutorial.Rnw:1321-1326
###################################################
image(DEM_out, "DEM_resamp", col=terrain.colors(20), axes=TRUE)
plot(olinda1, add=TRUE, lwd=0.5)
plot(stream1, add=TRUE, col="blue")


###################################################
### code chunk number 62: useR13_spatial_tutorial.Rnw:1359-1363
###################################################
olinda1$area <- sapply(slot(olinda1, "polygons"), slot, "area")
km2 <- olinda1$area/1000000
olinda1$dens <- olinda1$POP/km2
library(RColorBrewer)


###################################################
### code chunk number 64: useR13_spatial_tutorial.Rnw:1374-1377
###################################################
spplot(olinda1, "dens", at=c(0, 8000, 12000, 15000, 20000, 60000), col.regions=brewer.pal(6, "YlOrBr")[-1], main="Population density per square km", col="grey", lwd=0.5)


###################################################
### code chunk number 65: useR13_spatial_tutorial.Rnw:1391-1392
###################################################
library(rgeos)


###################################################
### code chunk number 66: useR13_spatial_tutorial.Rnw:1394-1398
###################################################
getScale()
pols <- as(olinda1, "SpatialPolygons")
Area <- gArea(pols, byid=TRUE)
all.equal(unname(Area), olinda1$area)


###################################################
### code chunk number 67: useR13_spatial_tutorial.Rnw:1419-1424
###################################################
lns0 <- as(stream1, "SpatialLines")
length(lns0)
summary(gLength(lns0, byid=TRUE))
t0 <- gTouches(lns0, lns0, byid=TRUE)
any(t0)


###################################################
### code chunk number 68: useR13_spatial_tutorial.Rnw:1444-1445
###################################################
library(spdep)


###################################################
### code chunk number 69: useR13_spatial_tutorial.Rnw:1447-1454
###################################################
lw <- mat2listw(t0)
is.symmetric.nb(lw$neighbours)
nComp <- n.comp.nb(lw$neighbours)
IDs <- as.character(nComp$comp.id)
lns <- gLineMerge(lns0, id=IDs)
length(lns)
summary(gLength(lns, byid=TRUE))


###################################################
### code chunk number 70: useR13_spatial_tutorial.Rnw:1474-1483
###################################################
GI <- gIntersects(lns, pols, byid=TRUE)
unname(which(GI[2,]))
res <- numeric(length=nrow(GI))
for (i in seq(along=res)) {
  if (any(GI[i,])) {
    resi <- gIntersection(lns[GI[i,]], pols[i])
    res[i] <- gLength(resi)
}}
olinda1$stream_len <- res


###################################################
### code chunk number 71: useR13_spatial_tutorial.Rnw:1505-1515
###################################################
tree <- gBinarySTRtreeQuery(lns, pols)
tree[[2]]
res1 <- numeric(length=length(tree))
for (i in seq(along=res1)) {
  if (!is.null(tree[[i]])) {
    gi <- gIntersection(lns[tree[[i]]], pols[i])
    res1[i] <- ifelse(is.null(gi), 0, gLength(gi))
  }
}
all.equal(res, res1)


###################################################
### code chunk number 72: useR13_spatial_tutorial.Rnw:1536-1548
###################################################
buf50m <- gBuffer(lns, width=50)
GI1 <- gIntersects(buf50m, pols, byid=TRUE)
res <- numeric(length=nrow(GI1))
for (i in seq(along=res)) {
  if (any(GI1[i,])) {
    out <- gIntersection(buf50m[GI1[i,]], pols[i])
    res[i] <- gArea(out)
  }
}
olinda1$buf_area <- res
prop <- olinda1$buf_area/olinda1$area
olinda1$prop_50m <- prop


###################################################
### code chunk number 73: useR13_spatial_tutorial.Rnw:1574-1576
###################################################
bounds <- gUnaryUnion(pols)
stream_inside <- gIntersection(lns, bounds)


###################################################
### code chunk number 75: useR13_spatial_tutorial.Rnw:1588-1591
###################################################
spplot(olinda1, "prop_50m", col.regions=colorRampPalette(brewer.pal(5, "Blues"))(20), col="transparent", sp.layout=list("sp.lines", stream_inside), main="Prop. of area < 50m of streams")


###################################################
### code chunk number 76: useR13_spatial_tutorial.Rnw:1631-1637
###################################################
pan <- readGDAL("L8s.tif")
bb0 <- set_ReplCRS_warn(FALSE)
proj4string(pan) <- CRS("+init=epsg:31985")
bb0 <- set_ReplCRS_warn(TRUE)
brks <- quantile(pan$band1, seq(0,1,1/255))
pan$lut <- findInterval(pan$band1, brks, all.inside=TRUE)


###################################################
### code chunk number 78: useR13_spatial_tutorial.Rnw:1651-1658
###################################################
image(pan, "lut", col=grey.colors(20))
plot(olinda1, add=TRUE, border="brown", lwd=0.5)
title(main="Landsat panchromatic channel 15m")


###################################################
### code chunk number 79: useR13_spatial_tutorial.Rnw:1680-1688
###################################################
letm <- readGDAL("L_ETMps.tif")
bb0 <- set_ReplCRS_warn(FALSE)
proj4string(letm) <- CRS("+init=epsg:31985")
bb0 <- set_ReplCRS_warn(TRUE)
letm$ndvi <- (letm$band4 - letm$band3)/(letm$band4 + letm$band3)
library(RColorBrewer)
mypal <- brewer.pal(5, "Greens")
greens <- colorRampPalette(mypal)


###################################################
### code chunk number 81: useR13_spatial_tutorial.Rnw:1701-1709
###################################################
library(RColorBrewer)
greens <- colorRampPalette(brewer.pal(5, "Greens"))
image(letm, "ndvi", col=greens(20))
plot(olinda1, add=TRUE, lwd=0.5)


###################################################
### code chunk number 83: useR13_spatial_tutorial.Rnw:1753-1755
###################################################
olinda_ll <- spTransform(olinda1, CRS("+proj=longlat +datum=WGS84"))
writeOGR(olinda_ll, dsn="olinda_ll.kml", layer="olinda_ll", driver="KML", overwrite_layer=TRUE)


###################################################
### code chunk number 85: useR13_spatial_tutorial.Rnw:1787-1791
###################################################
o_ndvi <- over(olinda1, letm[,,"ndvi"], fn=median)
o_alt <- over(olinda1, DEM_out[,,"DEM_resamp"], fn=median)
olinda1A <- spCbind(olinda1, cbind(o_ndvi, o_alt))
olinda2 <- olinda1A[!is.na(olinda1A$POP),]


###################################################
### code chunk number 86: useR13_spatial_tutorial.Rnw:1798-1801
###################################################
spplot(olinda2, "ndvi", col.regions=greens(20), main="Normalized difference vegetation index", col="transparent")


###################################################
### code chunk number 88: useR13_spatial_tutorial.Rnw:1826-1827
###################################################
library(raster)


###################################################
### code chunk number 89: useR13_spatial_tutorial.Rnw:1829-1832
###################################################
TMrs <- stack(letm)
e1 <- extract(TMrs, as(olinda2, "SpatialPolygons"))
all.equal(sapply(e1, function(x) median(x[,"ndvi"])), olinda2$ndvi)


###################################################
### code chunk number 91: useR13_spatial_tutorial.Rnw:1871-1873
###################################################
library(spdep)
ch <- choynowski(olinda2$CASES, olinda2$POP)


###################################################
### code chunk number 92: useR13_spatial_tutorial.Rnw:1880-1890
###################################################
cols <- rep("white", length(ch$pmap))
cols[(ch$pmap < 0.05) & (ch$type)] <- "grey35"
cols[(ch$pmap < 0.05) & (!ch$type)] <- "grey75"
plot(olinda2, col=cols)
title(main="Choynowski probability map")
legend("topleft", fill=c("grey35", "white", "grey75"), legend=c("low", "N/S", "high"), bty="n")


###################################################
### code chunk number 93: useR13_spatial_tutorial.Rnw:1906-1909
###################################################
pm <- probmap(olinda2$CASES, olinda2$POP)
names(pm)
olinda2$SMR <- pm$relRisk


###################################################
### code chunk number 94: useR13_spatial_tutorial.Rnw:1916-1931
###################################################
brks_prob <- c(0,0.05,0.1,0.2,0.8,0.9,0.95,1)
library(classInt)
fixed_prob <- classIntervals(pm$pmap, style="fixed", fixedBreaks=brks_prob)
library(RColorBrewer)
pal_prob <- rev(brewer.pal(5, "RdBu"))
cols <- findColours(fixed_prob, pal_prob)
plot(olinda2, col=cols)
title(main="Poisson probability map")
table <- attr(cols, "table")
legtext <- paste(names(table), " (", table, ")", sep="")
legend("topleft", fill=attr(cols, "palette"), legend=legtext, bty="n", cex=0.7, y.inter=0.8)


###################################################
### code chunk number 95: useR13_spatial_tutorial.Rnw:1947-1948
###################################################
table(findInterval(pm$pmap, seq(0,1,1/10)))


###################################################
### code chunk number 96: useR13_spatial_tutorial.Rnw:1955-1958
###################################################
hist(pm$pmap, breaks=8, col="grey", main="Poisson probability map")


###################################################
### code chunk number 97: useR13_spatial_tutorial.Rnw:1979-1982
###################################################
library(DCluster)
olinda2$RR <- olinda2$CASES/olinda2$Expected
olinda2$EB_ml <- empbaysmooth(olinda2$CASES, olinda2$Expected)$smthrr


###################################################
### code chunk number 99: useR13_spatial_tutorial.Rnw:1994-1997
###################################################
spplot(olinda2, c("RR", "EB_ml"), col.regions=brewer.pal(10, "RdBu"), at=c(seq(0,1,0.25), seq(1,6,1)))


###################################################
### code chunk number 100: useR13_spatial_tutorial.Rnw:2183-2185
###################################################
nb <- poly2nb(olinda2)
nb


###################################################
### code chunk number 101: useR13_spatial_tutorial.Rnw:2192-2198
###################################################
plot(olinda2, border="grey")
plot(nb, coordinates(olinda2), col="blue3", add=TRUE)


###################################################
### code chunk number 102: useR13_spatial_tutorial.Rnw:2214-2217
###################################################
olinda2$Observed <- olinda2$CASES
eb2 <- EBlocal(olinda2$Observed, olinda2$Expected, nb)
olinda2$EB_mm_local <- eb2$est


###################################################
### code chunk number 103: useR13_spatial_tutorial.Rnw:2224-2227
###################################################
spplot(olinda2, c("RR", "EB_ml", "EB_mm_local"), col.regions=brewer.pal(10, "RdBu"), at=c(seq(0,1,0.25), seq(1,6,1)))


###################################################
### code chunk number 104: useR13_spatial_tutorial.Rnw:2243-2246
###################################################
lw <- nb2listw(nb)
set.seed(130709)
moran.boot <- boot(as(olinda2, "data.frame"), statistic=moranI.boot, R=999, listw=lw, n=length(nb), S0=Szero(lw))


###################################################
### code chunk number 105: useR13_spatial_tutorial.Rnw:2253-2256
###################################################
plot(moran.boot)


###################################################
### code chunk number 106: useR13_spatial_tutorial.Rnw:2271-2272
###################################################
moran.pgboot <- boot(as(olinda2, "data.frame"), statistic=moranI.pboot, sim="parametric", ran.gen=negbin.sim, R=999, listw=lw, n=length(nb), S0=Szero(lw))


###################################################
### code chunk number 107: useR13_spatial_tutorial.Rnw:2279-2282
###################################################
plot(moran.pgboot)


###################################################
### code chunk number 109: useR13_spatial_tutorial.Rnw:2298-2299
###################################################
EBImoran.mc(olinda2$CASES, olinda2$Expected, lw, nsim=999)


###################################################
### code chunk number 112: useR13_spatial_tutorial.Rnw:2326-2333
###################################################
m0p <- glm(CASES ~ 1 + offset(log(Expected)), data=olinda2, family=poisson)
DeanB(m0p)
m0 <- glm(CASES ~ 1 + offset(log(Expected)), data=olinda2, family=quasipoisson)
m1 <- update(m0, . ~ . + DEPRIV)
m2 <- update(m1, . ~ . + ndvi)
m3 <- update(m2, . ~ . + DEM_resamp)
anova(m0, m1, m2, m3, test="F")


###################################################
### code chunk number 114: useR13_spatial_tutorial.Rnw:2356-2359
###################################################
olinda2$f1 <- fitted(m1)
olinda2$f2 <- fitted(m2)
olinda2$f3 <- fitted(m3)


###################################################
### code chunk number 116: useR13_spatial_tutorial.Rnw:2371-2374
###################################################
spplot(olinda2, c("CASES", "f1", "f2", "f3"), col.regions=brewer.pal(8, "Reds"), at=seq(0,40,5))


###################################################
### code chunk number 117: useR13_spatial_tutorial.Rnw:2396-2399
###################################################
olinda2$r1 <- residuals(m1, type="response")
olinda2$r2 <- residuals(m2, type="response")
olinda2$r3 <- residuals(m3, type="response")


###################################################
### code chunk number 119: useR13_spatial_tutorial.Rnw:2411-2414
###################################################
spplot(olinda2, c("r1", "r2", "r3"), col.regions=brewer.pal(8, "RdBu"), at=c(-30,-15,-10,-5,0,5,10,15,31))


###################################################
### code chunk number 120: useR13_spatial_tutorial.Rnw:2472-2478
###################################################
if(!("INLA" %in% .packages(all = TRUE))) source("http://www.math.ntnu.no/inla/givemeINLA.R")
library(INLA)
olinda2$INLA_ID <- 1:nrow(olinda2)
INLA_BYM <- inla(CASES ~ DEPRIV + ndvi + DEM_resamp + f(INLA_ID, model="bym",
 graph=nb2mat(nb, style="B")) + offset(log(Expected)), family="poisson",
 data=as(olinda2, "data.frame"), control.predictor=list(compute=TRUE))


###################################################
### code chunk number 122: useR13_spatial_tutorial.Rnw:2493-2494
###################################################
summary(INLA_BYM)


###################################################
### code chunk number 125: useR13_spatial_tutorial.Rnw:2516-2517
###################################################
olinda2$INLA <- exp(INLA_BYM$summary.linear.predictor[,1]-log(olinda2$Expected))


###################################################
### code chunk number 128: useR13_spatial_tutorial.Rnw:2530-2533
###################################################
spplot(olinda2, c("INLA"), col.regions=brewer.pal(10, "RdBu"), at=c(seq(0,1,0.25), seq(1,6,1)))


###################################################
### code chunk number 130: useR13_spatial_tutorial.Rnw:2552-2553
###################################################
library(CARBayes)


###################################################
### code chunk number 131: useR13_spatial_tutorial.Rnw:2555-2559 
###################################################
df <- as(olinda2, "data.frame")
attach(df)
obj <- poisson.bymCAR(CASES ~ DEPRIV + ndvi + DEM_resamp + offset(log(Expected)), W=nb2mat(nb, style="B"), n.sample=30000, burnin=20000, thin=10)
detach(df)


###################################################
### code chunk number 133: useR13_spatial_tutorial.Rnw:2564-2565
###################################################
olinda2$CARBayes <- obj$fitted.values[,1]/olinda2$Expected


###################################################
### code chunk number 138: useR13_spatial_tutorial.Rnw:2607-2610
###################################################
splom(as(olinda2, "data.frame")[,c("RR", "INLA", "CARBayes")])

