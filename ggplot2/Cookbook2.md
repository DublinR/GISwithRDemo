Maps with ggplot2 : Choropleth Maps
========================================================

First, make sure packages are installed and loaded.


```r
# install.packages('plyr')
library(ggplot2)
library(maps)
library(plyr)
```


Set up our Data Set. Comprised of the the USA arrests data set and the states data.



```r
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
head(crimes)
```

```
##                 state Murder Assault UrbanPop Rape
## Alabama       alabama   13.2     236       58 21.2
## Alaska         alaska   10.0     263       48 44.5
## Arizona       arizona    8.1     294       80 31.0
## Arkansas     arkansas    8.8     190       50 19.5
## California california    9.0     276       91 40.6
## Colorado     colorado    7.9     204       78 38.7
```





```r
# library(maps)
states_map <- map_data("state")
crime_map <- merge(states_map, crimes, by.x = "region", by.y = "state")
head(crime_map)
```

```
##    region   long   lat group order subregion Murder Assault UrbanPop Rape
## 1 alabama -87.46 30.39     1     1      <NA>   13.2     236       58 21.2
## 2 alabama -87.48 30.37     1     2      <NA>   13.2     236       58 21.2
## 3 alabama -87.95 30.25     1    13      <NA>   13.2     236       58 21.2
## 4 alabama -88.01 30.24     1    14      <NA>   13.2     236       58 21.2
## 5 alabama -88.02 30.25     1    15      <NA>   13.2     236       58 21.2
## 6 alabama -87.53 30.37     1     3      <NA>   13.2     236       58 21.2
```


### Crime Data Set
Let's look at the Assault data set in particular


```r
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
head(crimes)
```

```
##                 state Murder Assault UrbanPop Rape
## Alabama       alabama   13.2     236       58 21.2
## Alaska         alaska   10.0     263       48 44.5
## Arizona       arizona    8.1     294       80 31.0
## Arkansas     arkansas    8.8     190       50 19.5
## California california    9.0     276       91 40.6
## Colorado     colorado    7.9     204       78 38.7
```


### Crime Data Set
Let's look at the Assault data set in particular


```r

# library(maps)
states_map <- map_data("state")
crime_map <- merge(states_map, crimes, by.x = "region", by.y = "state")
head(crime_map)
```

```
##    region   long   lat group order subregion Murder Assault UrbanPop Rape
## 1 alabama -87.46 30.39     1     1      <NA>   13.2     236       58 21.2
## 2 alabama -87.48 30.37     1     2      <NA>   13.2     236       58 21.2
## 3 alabama -87.95 30.25     1    13      <NA>   13.2     236       58 21.2
## 4 alabama -88.01 30.24     1    14      <NA>   13.2     236       58 21.2
## 5 alabama -88.02 30.25     1    15      <NA>   13.2     236       58 21.2
## 6 alabama -87.53 30.37     1     3      <NA>   13.2     236       58 21.2
```

```r
# Use this package for the arrange function().
crime_map <- arrange(crime_map, group, order)
head(crime_map)
```

```
##    region   long   lat group order subregion Murder Assault UrbanPop Rape
## 1 alabama -87.46 30.39     1     1      <NA>   13.2     236       58 21.2
## 2 alabama -87.48 30.37     1     2      <NA>   13.2     236       58 21.2
## 3 alabama -87.53 30.37     1     3      <NA>   13.2     236       58 21.2
## 4 alabama -87.53 30.33     1     4      <NA>   13.2     236       58 21.2
## 5 alabama -87.57 30.33     1     5      <NA>   13.2     236       58 21.2
## 6 alabama -87.59 30.33     1     6      <NA>   13.2     236       58 21.2
```


### Crime Data Set
Let's look at the Assault data set in particular


```r
dim(crime_map)
```

```
## [1] 15527    10
```

```r
summary(crime_map$Assault)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##      45     120     201     195     255     337
```

```r
unique(crime_map$Assault)
```

```
##  [1] 236 294 190 276 204 110 238 335 211 120 249 113  56 115 109  83 300
## [18] 149 255  72 259 178 102 252  57 159 285 254 337  45 151 106 174 279
## [35]  86 188 201  48 156 145  81  53 161
```

```r
# some states may have some value.
```






Choropleth Maps


```r
ggplot(crimes, aes(map_id = state, fill = Assault)) + geom_map(map = states_map, 
    colour = "black") + scale_fill_gradient2(low = "#559999", mid = "grey90", 
    high = "#BB650B", midpoint = median(crimes$Assault)) + expand_limits(x = states_map$long, 
    y = states_map$lat) + coord_map("polyconic")
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 


Choropleth Maps


```r
ggplot(crimes, aes(map_id = state, fill = Assault)) + geom_map(map = states_map, 
    colour = "black") + scale_fill_gradient2(low = "#559999", mid = "grey90", 
    high = "#BB650B", midpoint = median(crimes$Assault)) + expand_limits(x = states_map$long, 
    y = states_map$lat) + coord_map("polyconic")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

