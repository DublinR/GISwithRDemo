# http://www.r-bloggers.com/maps-in-r-introduction-drawing-the-map-of-europe/
# http://www.inside-r.org/packages/cran/RgoogleMaps/docs/GetMap

library(ggmap)
library(mapproj)
map <- get_map(location = 'Europe', zoom = 4)
ggmap(map)

##############################

library(rworldmap)
newmap <- getMap(resolution = "low")
plot(newmap)


##############################
lat = c(40.702147,40.718217,40.711614);
 
 
  lon = c(-74.012318,-74.015794,-73.998284);
 
 
  center = c(mean(lat), mean(lon));
 
 
  zoom <- min(MaxZoom(range(lat), range(lon)));
 
 
  #this overhead is taken care of implicitly by GetMap.bbox(); 
 
 
  markers = paste0("&markers=color:blue|label:S|40.702147,-74.015794&markers=color:",
 
 
                   "green|label:G|40.711614,-74.012318&markers=color:red|color:red|",
 
 
                   "label:C|40.718217,-73.998284")
 
 
  MyMap <- GetMap(center=center, zoom=zoom,markers=markers,destfile = "MyTile1.png");
 
