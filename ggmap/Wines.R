## David Smith - Revolution Analytics
## http://blog.revolutionanalytics.com/2012/07/making-beautiful-maps-in-r-with-ggmap.html
##
##################################################

require(ggmap)
require(mapproj)

## source data from: http://www.napawineproject.com/project-notes/index.asp
## Excel file exported as CSV with header rows removed

wine <- read.csv("Napa-Winery-List62012.csv", stringsAsFactors=FALSE)
nwines <- nrow(wine)

# wineries that accept tastings, either by appointment or walk-ins
tasting <- wine$App=="No" | wine$App=="Yes"
# sum(tasting)
# wine$Address[tasting]

# wineries with valid addresses (P.O. Boxes not counted as valid)
good.address <- wine$Address != ""
good.address[grep("Box", wine$Address)] <- F
# wine$Address[!good.address]

# wineries you can visit to taste
visit <- good.address & tasting
# sum(visit) # 354 total

## filter data frame to visitable wineries
visit.wine <- wine[visit,]

## paste address fields into a single CA address for geocoding
addresses <- with(visit.wine, 
 paste(Address, City, "CA", sep=", ")
)
## some non-ASCII characters in source data will mess up geocoding
addresses <- iconv(addresses, to="ASCII",sub="")

## convert addresses to lat/long
# locs <- geocode(addresses)
# I got a "there is no connection 3" error when trying to do all at once, so breaking up into batches

loc1 <- geocode(addresses[1:100])
loc2 <- geocode(addresses[101:200])
loc3 <- geocode(addresses[201:300])
loc4 <- geocode(addresses[301:345])
locs <- rbind(loc1, loc2, loc3, loc4)

visit.wine$lon <- locs$lon
visit.wine$lat <- locs$lat

## Couldn't get the watercolor maps to work
## SHmap <- qmap(c(lon=map.center$lon, lat=map.center$lat), source="stamen", maptype="watercolor")

map.center <- geocode("Saint Helena, CA")
SHmap <- qmap(c(lon=map.center$lon, lat=map.center$lat), source="google", zoom=12)
SHmap + geom_point(
  aes(x=lon, y=lat, colour=App), data=visit.wine) +
  scale_colour_manual(values=c("dark blue","orange"))+
  labs(colour="Appointment Required")
  
