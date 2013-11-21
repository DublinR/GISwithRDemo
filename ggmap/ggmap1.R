library(ggmap)
get_googlemap(urlonly = TRUE)

# get_googlemap has several argument checks
get_googlemap(zoom = 13)
get_googlemap(scale = 4)
get_googlemap(center = c(53,-6))

# markers and paths are easy to access
d <- function(x=-95.36, y=29.76, n,r,a){
  round(data.frame(
    lon = jitter(rep(x,n), amount = a),
    lat = jitter(rep(y,n), amount = a)
  ), digits = r)
}
############################################################
df <- d(n=50,r=3,a=.3)
map <- get_googlemap(markers = df, path = df,, scale = 2)
ggmap(map)
ggmap(map, fullpage = TRUE) +
  geom_point(aes(x = lon, y = lat), data = df, size = 3, colour = 'black') +
  geom_path(aes(x = lon, y = lat), data = df)
############################################################
gc <- geocode('Dublin,Ireland')
center <- as.numeric(gc)
ggmap(get_googlemap(center = center, color = 'bw', scale = 2), fullpage = T)

############################################################
# the scale argument can be seen in the following
# (make your graphics device as large as possible)
ggmap(get_googlemap(center, scale = 1), fullpage = TRUE) # pixelated
ggmap(get_googlemap(center, scale = 2), fullpage = TRUE) # fine
