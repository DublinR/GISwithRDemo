### R code from vignette source 'dismap.Rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: dismap.Rnw:200-217
###################################################
library(spdep)
data(nc.sids)

nc.sids$NWPROP74<-nc.sids$NWBIR74/nc.sids$BIR74
nc.sids$NWPROP79<-nc.sids$NWBIR79/nc.sids$BIR79

r74<-sum(nc.sids$SID74)/sum(nc.sids$BIR74)
nc.sids$EXP74<-r74*nc.sids$BIR74
nc.sids$SMR74<-nc.sids$SID74/nc.sids$EXP74

r79<-sum(nc.sids$SID79)/sum(nc.sids$BIR79)
nc.sids$EXP79<-r79*nc.sids$BIR79
nc.sids$SMR79<-nc.sids$SID79/nc.sids$EXP79

ncglm74<-glm(SID74~offset(log(EXP74))+NWPROP74, data=nc.sids, family="poisson")
ncglm79<-glm(SID79~offset(log(EXP79))+NWPROP79, data=nc.sids, family="poisson")



###################################################
### code chunk number 2: dismap.Rnw:225-226
###################################################
summary(ncglm74)


###################################################
### code chunk number 3: dismap.Rnw:234-235
###################################################
summary(ncglm79)


###################################################
### code chunk number 4: dismap.Rnw:246-257
###################################################
library(maptools)
#Read North Carolina county map
nc.sidsmap <- readShapePoly(system.file("etc/shapes/sids.shp",
   package="spdep")[1], ID="FIPSNO")

#Compute SMR
nc.sidsmap$SMR74<-nc.sids$SMR74
nc.sidsmap$RR74<-exp(coefficients(ncglm74)[1]+coefficients(ncglm74)[2]*nc.sids$NWPROP74)
nc.sidsmap$SMR79<-nc.sids$SMR79
nc.sidsmap$RR79<-exp(coefficients(ncglm79)[1]+coefficients(ncglm79)[2]*nc.sids$NWPROP79)



###################################################
### code chunk number 5: dismap.Rnw:261-265
###################################################
library(RColorBrewer)
print(spplot(nc.sidsmap, c("SMR74", "RR74", "SMR79", "RR79"),
   at=c(0, .5, .75, .9, 1.1, 1.25, 1.5, 4.8),
   col.regions=brewer.pal(7, "Oranges") ) )


###################################################
### code chunk number 6: dismap.Rnw:354-364
###################################################
nc.sidsmap$Observed<-nc.sidsmap$SID74
nc.sidsmap$Expected<-nc.sids$EXP74

nc.sidsmap$NWPROP<-nc.sids$NWBIR74/nc.sids$BIR74


nc.sidsmap$SMR<-nc.sidsmap$Observed/nc.sidsmap$Expected

nc.sidsmap$PPOIS<-ppois(nc.sidsmap$Observed, 
   nc.sidsmap$Expected, lower.tail =FALSE)


###################################################
### code chunk number 7: dismap.Rnw:368-369
###################################################
print(spplot(nc.sidsmap, "PPOIS"))


###################################################
### code chunk number 8: dismap.Rnw:410-412
###################################################
table(findInterval(nc.sidsmap$PPOIS, seq(0, 1, 1/10)))



###################################################
### code chunk number 9: dismap.Rnw:571-572
###################################################
library(spdep)


###################################################
### code chunk number 10: dismap.Rnw:575-578
###################################################
eb1 <- EBest(nc.sidsmap$Observed,nc.sidsmap$Expected)
unlist(attr(eb1, "parameters"))
nc.sidsmap$EB_mm <-eb1$estmm


###################################################
### code chunk number 11: dismap.Rnw:581-585
###################################################
library(DCluster)
res <- empbaysmooth(nc.sidsmap$Observed,nc.sidsmap$Expected)
unlist(res[2:3])
nc.sidsmap$EB_ml <- res$smthrr


###################################################
### code chunk number 12: dismap.Rnw:678-679
###################################################
neigh<-poly2nb(nc.sidsmap)


###################################################
### code chunk number 13: plotneigh (eval = FALSE)
###################################################
## 
## plot(nc.sidsmap, border="gray")
## plot(neigh, coordinates(nc.sidsmap), pch=".", col="blue", add=TRUE)
## 


###################################################
### code chunk number 14: dismap.Rnw:692-694
###################################################
plot(nc.sidsmap, border="gray")
plot(neigh, coordinates(nc.sidsmap), pch=".", col="blue", add=TRUE)


###################################################
### code chunk number 15: dismap.Rnw:714-716
###################################################
eb2 <- EBlocal(nc.sidsmap$Observed, nc.sidsmap$Expected, neigh)
nc.sidsmap$EB_mm_local <- eb2$est


###################################################
### code chunk number 16: dismap.Rnw:724-725
###################################################
print(spplot(nc.sidsmap, c("SMR", "EB_ml", "EB_mm", "EB_mm_local")) )


###################################################
### code chunk number 17: dismap.Rnw:738-744
###################################################
RR<-sum(nc.sidsmap$Observed)/sum(nc.sidsmap$Expected)

#Boxplot of EB estimates
boxplot(as(nc.sidsmap, "data.frame")[,c("SMR", "EB_ml", "EB_mm", "EB_mm_local")],
   cex.lab=.5, las=1, horizontal=TRUE)
abline(v=RR, lty=2, col="red", lwd=2)


###################################################
### code chunk number 18: dismap.Rnw:792-798
###################################################
lw <- nb2listw(neigh)
set.seed(1)


moran.boot <- boot(as(nc.sidsmap, "data.frame"), statistic = moranI.boot,
R = 999, listw = lw, n = length(neigh), S0 = Szero(lw))


###################################################
### code chunk number 19: dismap.Rnw:804-805
###################################################
plot(moran.boot)


###################################################
### code chunk number 20: dismap.Rnw:821-824
###################################################
moran.pgboot <- boot(as(nc.sidsmap, "data.frame"), statistic = moranI.pboot,
   sim = "parametric", ran.gen = negbin.sim, R = 999, listw = lw, n =
length(neigh), S0 = Szero(lw))


###################################################
### code chunk number 21: dismap.Rnw:831-832
###################################################
plot(moran.pgboot)


###################################################
### code chunk number 22: dismap.Rnw:847-848
###################################################
EBImoran.mc(nc.sidsmap$Observed, nc.sidsmap$Expected, lw, nsim = 999)


###################################################
### code chunk number 23: dismap.Rnw:915-922
###################################################
base.glm <- glm(Observed ~ 1 + offset(log(Expected)), data = nc.sidsmap,
   family = poisson())
base.glmQ <- glm(Observed ~ 1 + offset(log(Expected)), data = nc.sidsmap,
   family = quasipoisson())

library(MASS)
base.nb <- glm.nb(Observed ~ 1 + offset(log(Expected)), data = nc.sidsmap)


###################################################
### code chunk number 24: dismap.Rnw:981-984
###################################################
test.nb.pois(base.nb, base.glm)

DeanB(base.glm)


###################################################
### code chunk number 25: dismap.Rnw:1000-1012
###################################################
nc.sidsmap.glm <- glm(Observed ~ offset(log(Expected))+NWPROP,
   data = nc.sidsmap, family = poisson())

nc.sidsmap.glmQ <- glm(Observed ~ offset(log(Expected))+NWPROP,
   data = nc.sidsmap, family = quasipoisson())

nc.sidsmap.nb <- glm.nb(Observed ~ offset(log(Expected))+NWPROP,
   data = nc.sidsmap)

#unlist(summary(nc.sidsmap.nb)[20:21])

anova(base.nb, nc.sidsmap.nb)


###################################################
### code chunk number 26: dismap.Rnw:1020-1023
###################################################

summary(nc.sidsmap.nb)



###################################################
### code chunk number 27: dismap.Rnw:1039-1041
###################################################
DeanB(base.glm)



###################################################
### code chunk number 28: dismap.Rnw:1044-1045
###################################################
DeanB(nc.sidsmap.glm)


###################################################
### code chunk number 29: dismap.Rnw:1061-1067
###################################################
nc.sidsmap$base_glm_rst <- rstandard(base.glm)
nc.sidsmap$base_glmQ_rst <- rstandard(base.glmQ)
nc.sidsmap$base_nb_rst <- rstandard(base.nb)
nc.sidsmap$COV_glm_rst <- rstandard(nc.sidsmap.glm)
nc.sidsmap$COV_glmQ_rst <- rstandard(nc.sidsmap.glmQ)
nc.sidsmap$COV_nb_rst <- rstandard(nc.sidsmap.nb)


###################################################
### code chunk number 30: dismap.Rnw:1079-1083
###################################################
print(spplot(nc.sidsmap,
   c("base_glm_rst", "base_glmQ_rst", "base_nb_rst",
   "COV_glm_rst", "COV_glmQ_rst", "COV_nb_rst"))
)


###################################################
### code chunk number 31: dismap.Rnw:1172-1182
###################################################
nc.sidsmap$x<-coordinates(nc.sidsmap)[,1]
nc.sidsmap$y<-coordinates(nc.sidsmap)[,2]

mle<-calculate.mle(as(nc.sidsmap, "data.frame"), model="poisson")
knresults<-opgam(data=as(nc.sidsmap, "data.frame"),
   thegrid=as(nc.sidsmap, "data.frame")[,c("x","y")],
   alpha=.05, iscluster=kn.iscluster, fractpop=.5, R=100, model="poisson",
   mle=mle)

knresults[order(knresults$statistic, decreasing =TRUE), ][1:10, ]


###################################################
### code chunk number 32: dismap.Rnw:1322-1323
###################################################
options(width=36)


###################################################
### code chunk number 33: WB (eval = FALSE)
###################################################
## 
## WBneigh<-nb2WB(neigh)
## WBdata<-list(observed=nc.sidsmap$Observed, expected=nc.sidsmap$Expected, 
##    N=nrow(nc.sidsmap), NWPROP=nc.sidsmap$NWPROP)
## 
## WBdata<-c(WBdata, WBneigh)
## 
## WBinits<-list(alpha=0, beta=c(0),
##    u=rep(0, nrow(nc.sidsmap)), v=rep(0, nrow(nc.sidsmap)), precu=1, precv=1
## )
## 
## 
## 
## 
## #Set model file and working directory
## modelf<-paste(getwd(), "models/BYM-model.txt", sep="/")
## wdbym<-paste(getwd(), "results/BYM-dismap", sep="/")
## 
## library(R2WinBUGS)
## BYM<-bugs(data=WBdata, inits=list(WBinits), parameters.to.save=c("theta"),
## n.chains=1, n.thin=5, DIC=TRUE,
##    working.directory = wdbym,
##    n.iter=15000, n.burnin=10000, debug=TRUE,
##    model.file=modelf
## )
## 
## 


###################################################
### code chunk number 34: dismap.Rnw:1358-1359
###################################################
options(width=60)


###################################################
### code chunk number 35: dismap.Rnw:1364-1366 (eval = FALSE)
###################################################
## 
## WBneigh<-nb2WB(neigh)
## WBdata<-list(observed=nc.sidsmap$Observed, expected=nc.sidsmap$Expected, 
##    N=nrow(nc.sidsmap), NWPROP=nc.sidsmap$NWPROP)
## 
## WBdata<-c(WBdata, WBneigh)
## 
## WBinits<-list(alpha=0, beta=c(0),
##    u=rep(0, nrow(nc.sidsmap)), v=rep(0, nrow(nc.sidsmap)), precu=1, precv=1
## )
## 
## 
## 
## 
## #Set model file and working directory
## modelf<-paste(getwd(), "models/BYM-model.txt", sep="/")
## wdbym<-paste(getwd(), "results/BYM-dismap", sep="/")
## 
## library(R2WinBUGS)
## BYM<-bugs(data=WBdata, inits=list(WBinits), parameters.to.save=c("theta"),
## n.chains=1, n.thin=5, DIC=TRUE,
##    working.directory = wdbym,
##    n.iter=15000, n.burnin=10000, debug=TRUE,
##    model.file=modelf
## )
## 
## 
## save(file="results/BYMWB-dismap.RData", list=c("WBneigh", "WBdata", "WBinits", "BYM"))


###################################################
### code chunk number 36: dismap.Rnw:1369-1370
###################################################
load("results/BYMWB-dismap.RData")


###################################################
### code chunk number 37: dismap.Rnw:1373-1374
###################################################
nc.sidsmap$BYM<-BYM$mean$theta


###################################################
### code chunk number 38: dismap.Rnw:1456-1471
###################################################
library(INLA)
library(spdep)

nb2INLA(file="nc.sidsmap.graph", neigh)
nc.sidsmap$ID<-1:100#as.character(1:100)

formula  <-  Observed~1+NWPROP+f(ID,model="bym",graph="nc.sidsmap.graph",param=c(1,0.00005),initial=2.8)#+ f(FIPSNO,model="iid")

mod  <-  inla(formula,family="poisson",data=as(nc.sidsmap, "data.frame"),
   E=nc.sidsmap$Expected, control.inla=list(h=0.01),verbose=TRUE,
   control.compute=list(dic=TRUE),
   control.predictor=list(compute=TRUE))


nc.sidsmap$INLA<-mod$summary.fitted.values$mean


###################################################
### code chunk number 39: dismap.Rnw:1479-1480
###################################################
print(spplot(nc.sidsmap, c("SMR", "INLA")))


###################################################
### code chunk number 40: dismap.Rnw:1491-1494
###################################################
cat("DIC computed with WinBUGS:", BYM$DIC, "\n\n")

cat("DIC computed with INLA:", mod$dic$dic, "\n")


###################################################
### code chunk number 41: dismap.Rnw:1499-1501
###################################################
plot(nc.sidsmap$BYM, nc.sidsmap$INLA)
abline(0,1)


###################################################
### code chunk number 42: dismap.Rnw:1572-1593
###################################################

library(R2BayesX)

ncgra <- nb2gra(neigh)
nc.sidsmap$IDXSP <- as.numeric(rownames(ncgra))#Index for spatial effect

if(!file.exists("results/bayesx-dismap.RData")) {

sidsbayesx <- bayesx(Observed ~ NWPROP+ sx(ID, bs = "re") +
   sx(IDXSP, bs = "spatial", map = ncgra),
   offset = log(nc.sidsmap$Expected), family = "poisson",
   data = as(nc.sidsmap, "data.frame") )


save(file="results/bayesx-dismap.RData", list=c("sidsbayesx"))

} else{
   load("results/bayesx-dismap.RData")
}

nc.sidsmap$BAYESX <- sidsbayesx$fitted.values[order(sidsbayesx$bayesx.setup$order),2]/nc.sidsmap$Expected


###################################################
### code chunk number 43: dismap.Rnw:1604-1608
###################################################
print(spplot(nc.sidsmap, c("SMR", "BYM", "INLA", "BAYESX"),
 at=c(0, .5, .75, .9, 1.1, 1.25, 1.5, 4.8),
   col.regions=brewer.pal(7, "Oranges") ) )



###################################################
### code chunk number 44: dismap.Rnw:1616-1617
###################################################
save(file="results/dismap.RData", list=ls())


