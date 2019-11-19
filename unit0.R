### R code from vignette source 'unit0.Rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: unit0.Rnw:180-185 (eval = FALSE)
###################################################
## library(spgrass6)
## buildings <- readVECT6("vsnow4")
## sohoSG <- readRAST6(c("snowcost_broad", "snowcost_not_broad"))
## nb_pump <- readVECT6("vpump_not_broad")
## b_pump <- readVECT6("vpump_broad")


###################################################
### code chunk number 2: unit0.Rnw:187-191 (eval = FALSE)
###################################################
## deaths <- readVECT6("deaths3")
## o <- overlay(sohoSG, deaths)
## deaths <- spCbind(deaths, as(o, "data.frame"))
## deaths$b_nearer <- deaths$snowcost_broad < deaths$snowcost_not_broad


###################################################
### code chunk number 3: unit0.Rnw:193-195
###################################################
library(maptools)
load("datasets/JohnSnow.RData")


###################################################
### code chunk number 4: unit0.Rnw:204-208
###################################################
o <- overlay(sohoSG, deaths)
deaths <- spCbind(deaths, as(o, "data.frame"))
deaths$b_nearer <- deaths$snowcost_broad < deaths$snowcost_not_broad
by(deaths$Num_Cases, deaths$b_nearer, sum)


###################################################
### code chunk number 5: unit0.Rnw:219-241
###################################################
oopar <- par(mar=c(1,1,1,1)+0.1)
image(sohoSG, "snowcost_broad", breaks=seq(0,750,50),
 col=rev(heat.colors(15)))
symbols(coordinates(deaths), circles=4*sqrt(deaths$Num_Cases),
 inches=FALSE, add=TRUE, bg=c("pink","grey")[deaths$b_nearer+1])
source("legend_image.R") #from geoR
rect(528900, 180550, 529040, 180990, border=NA, col="white")
text(528970, 180950, "metres from\nBroad Street\npump", cex=0.6)
legend_image(c(528930, 528960), c(180600, 180900),
 sohoSG$snowcost_broad, vertical=TRUE, breaks=seq(0,750,50),
 col=rev(heat.colors(15)))
plot(nb_pump, add=TRUE, pch=8, cex=1.3)
plot(b_pump, add=TRUE, pch=3, cex=1.3, lwd=2)
rect(528900, 181330, 529140, 181380, border=NA, col="white")
legend(c(528910, 529100), c(181350, 181380),
 legend=c("Broad Street pump","other pumps"), pch=c(3,8), bty="n",
 cex=0.6, y.inter=0.7)
rect(528900, 181270, 529180, 181335, border=NA, col="white")
legend(c(528910, 529100), c(181275, 181325),
 legend=c("nearer Broad Street pump","nearer other pump"),
 fill=c("grey","pink"), bty="n", cex=0.6, y.inter=0.7)
par(oopar)


