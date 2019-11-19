# http://www.r-bloggers.com/visualising-crime-hotspots-in-england-and-wales-using-ggmap-2/

# 1. Obtain latitude and longitude of a user-defined location using ggmap::geocode.
# 2. Download crime data via the Police API as discussed above.
# 3. Convert JSON into a list and then a data frame.
# 4. Download a base map from Google using ggmap::get_googlemap.
# 5. Covert the base map into a ggplot object using ggmap::ggmap.
# 6. Add multiple layers on top of the base map using the data frame like a normal ggplot.

################################################################
crimeplot.wrapper <- function(
  point.of.interest = "London Eye",  ## user-defined location
  period = c("2013-01","2013-02"),  ## period of time in YYYY-MM
  type.map = "roadmap",  ## roadmap, terrain, satellite or hybrid
  type.facet = NA,  ## options: NA, month, category or type
  type.print = NA,  ## options: NA, panel or window
  output.plot = TRUE,  ## print it to a png file?
  output.filename = "temp.png",  ## provide a filename
  output.size = c(700,700)) ## width and height setting  
