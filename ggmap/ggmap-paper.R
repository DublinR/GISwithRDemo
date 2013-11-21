baylor <- "baylor university"
qmap(baylor, zoom = 14)
qmap(baylor, zoom = 14, source = "osm")
###################################
geocode("Trinity College Dublin")
#         lon      lat
# 1 -6.254759 53.34375
TCD <- "Trinity College Dublin"
qmap(TCD, zoom = 15)
qmap(TCD, zoom = 17, source = "osm")
#Lincoln Place
qmap(c(-6.251659, 53.34225),zoom = 17, source = "osm")
###################################
baylor <- "baylor university"
qmap(baylor, zoom = 14)
qmap(baylor, zoom = 14, source = "osm")
#========================================================#
set.seed(500)
df <- round(data.frame(
  x = jitter(rep(-95.36, 50), amount = .3),
  y = jitter(rep( 29.76, 50), amount = .3)
), digits = 2)
map <- get_googlemap(’houston’, markers = df, path = df, scale = 2)
ggmap(map, extent = ’device’)
#========================================================#
# maptype = "watercolor" 
# maptype = "toner".




paris <- get_map(location = "paris")
# str(paris)
ggmap(paris, extent = "normal")
#########################################

qmap(baylor, zoom = 14, maptype = 53428, api_key = api_key,
     source = "cloudmade")
qmap("houston", zoom = 10, maptype = 58916, api_key = api_key,
     source = "cloudmade")


#########################################
theme_set(theme_bw(16))
HoustonMap <- qmap("houston", zoom = 14, color = "bw", legend = "topleft")
HoustonMap +
  geom_point(aes(x = lon, y = lat, colour = offense, size = offense),
             data = violent_crimes)
HoustonMap +
  stat_bin2d(
    aes(x = lon, y = lat, colour = offense, fill = offense),
    size = .5, bins = 30, alpha = 1/2,
    data = violent_crimes
  )


houston <- get_map("houston", zoom = 14)
HoustonMap <- ggmap("houston", extent = "device", legend = "topleft")
HoustonMap +
  stat_density2d(
    aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
    size = 2, bins = 4, data = violent_crimes,
    geom = "polygon"
  )
overlay <- stat_density2d(
  aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
  bins = 4, geom = "polygon",
  data = violent_crimes
)
HoustonMap + overlay + inset(
  grob = ggplotGrob(ggplot() + overlay + theme_inset()),
  xmin = -95.35836, xmax = Inf, ymin = -Inf, ymax = 29.75062
)
########################################
houston <- get_map(location = "houston", zoom = 14, color = "bw",
                   source = "osm")
HoustonMap <- ggmap(houston, base_layer = ggplot(aes(x = lon, y = lat),
                                                 data = violent_crimes))
HoustonMap +
  stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                 bins = 5, geom = "polygon",
                 data = violent_crimes) +
  scale_fill_gradient(low = "black", high = "red") +
  facet_wrap(~ day)
