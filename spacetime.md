Space-Time Data Modelling
========================================================


```r
### R code from vignette source 'spacetime_data.Rnw' Encoding: ISO8859-1

################################################### code chunk number 1: spacetime_data.Rnw:176-188
s = 1:3
t = c(1, 1.5, 3, 4.5)
g = data.frame(rep(t, each = 3), rep(s, 4))
plot(g, xaxt = "n", yaxt = "n", xlab = "Time points", ylab = "Space locations", 
    xlim = c(0.5, 5), ylim = c(0.5, 3.5))
abline(h = s, col = grey(0.8))
abline(v = t, col = grey(0.8))
points(g)
axis(1, at = t, labels = c("1st", "2nd", "3rd", "4th"))
axis(2, at = s, labels = c("1st", "2nd", "3rd"))
text(g, labels = 1:12, pos = 4)
title("STFDF (Space-time full data.frame) layout")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-11.png) 

```r


################################################### code chunk number 2: spacetime_data.Rnw:198-211
s = 1:3
t = c(1, 2.2, 3, 4.5)
g = data.frame(rep(t, each = 3), rep(s, 4))
sel = c(1, 2, 3, 5, 6, 7, 11)
plot(g[sel, ], xaxt = "n", yaxt = "n", xlab = "Time points", ylab = "Space locations", 
    xlim = c(0.5, 5), ylim = c(0.5, 3.5))
abline(h = s, col = grey(0.8))
abline(v = t, col = grey(0.8))
points(g[sel, ])
axis(1, at = t, labels = c("1st", "2nd", "3rd", "4th"))
axis(2, at = s, labels = c("1st", "2nd", "3rd"))
text(g[sel, ], labels = paste(1:length(sel), "[", c(1, 2, 3, 2, 3, 1, 2), ",", 
    c(1, 1, 1, 2, 2, 3, 4), "]", sep = ""), pos = 4)
title("STSDF (Space-time sparse data.frame) layout")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-12.png) 

```r


################################################### code chunk number 3: spacetime_data.Rnw:219-233
s = c(1, 2, 3, 1, 4)
t = c(1, 2.2, 2.5, 4, 4.5)
g = data.frame(t, s)
plot(g, xaxt = "n", yaxt = "n", xlab = "Time points", ylab = "Space locations", 
    xlim = c(0.5, 5), ylim = c(0.5, 4.5))
# abline(h=s, col = grey(.8)) abline(v=t, col = grey(.8))
arrows(t, s, 0.5, s, 0.1, col = "red")
arrows(t, s, t, 0.5, 0.1, col = "red")
points(g)
axis(1, at = sort(unique(t)), labels = c("1st", "2nd", "3rd", "4th", "5th"))
axis(2, at = sort(unique(s)), labels = c("1st,4th", "2nd", "3rd", "5th"))
text(g, labels = 1:5, pos = 4)
title("STIDF (Space-time irregular data.frame) layout")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-13.png) 

```r

```


