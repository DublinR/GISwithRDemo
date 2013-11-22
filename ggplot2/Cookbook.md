Maps with ggplot2
========================================================

### Loading Up The Relevant Packages


```r
library(maps)
library(ggplot2)
library(RColorBrewer)

states_map <- map_data("state")
```


Plot 1 : USA states Map


```r
ggplot(states_map, aes(x = long, y = lat, group = group)) + geom_polygon(fill = "white", 
    colour = "black")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 


Plot 2 : Projection


```r

ggplot(states_map, aes(x = long, y = lat, group = group)) + geom_path() + coord_map("mercator")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 


Plot 3 : Map of the World

You can also embed plots, for example:


```r

world_map <- map_data("world")
head(world_map)
```

```
##     long   lat group order region subregion
## 1 -133.4 58.42     1     1 Canada      <NA>
## 2 -132.3 57.16     1     2 Canada      <NA>
## 3 -132.0 56.99     1     3 Canada      <NA>
## 4 -131.9 56.74     1     4 Canada      <NA>
## 5 -130.2 56.10     1     5 Canada      <NA>
## 6 -130.0 55.91     1     6 Canada      <NA>
```




You can also embed plots, for example:


```r

east_asia <- map_data("world", region = c("Japan", "China", "North Korea", "South Korea"))
ggplot(east_asia, aes(x = long, y = lat, group = group, fill = region)) + geom_polygon(colours = "black") + 
    scale_fill_brewer(palette = "Set2")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 


You can also embed plots, for example:


```r
# Other Palettes : Accent,Paired, Set1


ggplot(east_asia, aes(x = long, y = lat, group = group, fill = region)) + geom_polygon(colours = "black") + 
    scale_fill_brewer(palette = "Set1")
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 

### Ireland
The main issue with this map is that it is constructed using a very small data set.


```r
IrlSet <- grep("Irel", world_map$region)
# IrlMap <- world_map[IrlSet,]
Ireland <- map_data("world", region = c("Ireland"))
```



```r

ggplot(Ireland, aes(x = long, y = lat, group = group, fill = region)) + geom_polygon(colours = "black") + 
    scale_fill_brewer(palette = "Set2")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

```r
# Not Great !
```


### Some European Countries
The main issue with this map is that it is constructed using a very small data set.


```r

NWE <- map_data("world", region = c("Portugal", "Ireland", "Italy", "Greece", 
    "Spain"))
```



```r
ggplot(NWE, aes(x = long, y = lat, group = group, fill = region)) + geom_polygon(colours = "black") + 
    scale_fill_brewer(palette = "Set1")
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 



```r

NZ1 <- map_data("world", region = "New Zealand")
NZ1 <- subset(NZ1, long > 0 & lat > -48)  #trim off outlying islands
```


```r

ggplot(NZ1, aes(x = long, y = lat, group = group)) + geom_path()
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 


Same map from a more detailed data source


```r
NZ2 <- map_data("nz")
ggplot(NZ2, aes(x = long, y = lat, group = group)) + geom_path()
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13.png) 


