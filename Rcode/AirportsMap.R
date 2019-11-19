#http://www.milanor.net/blog/?p=594

airports <- read.csv("http://openflights.svn.sourceforge.net/viewvc/openflights/openflights/data/airports.dat", header = FALSE)

colnames(airports) <- c("ID", "name", "city", "country", "IATA_FAA", "ICAO", "lat", "lon", "altitude", "timezone", "DST")
head(airports)


library(rworldmap)
newmap <- getMap(resolution = "low")
plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1)

points(airports$lon, airports$lat, col = "red", cex = .6)
