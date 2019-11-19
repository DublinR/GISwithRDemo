# Implementing Spatial Data Analysis Software Tools in R
# Roger Bivand
# UseR! 2013 Workshop - Albacete - July 2013

#############################################################################

data (nc.sids)
new30 <- dnearneigh(as.matrix(nc.sids[, c(‘‘east’’, ‘‘north’’)]),d1 = 0, d2 = 30, row.names = nc.sids$CNTY.ID)

plot(ncpolys, border =‘‘grey’’)
plot(ncCC89.nb, as.matrix(nc.sids[, c(‘‘lon’’, ‘‘lat’’)]), add = TRUE)
plot(diffnb(ncCC89.nb, new30, verbose = FALSE), as.matrix(nc.sids[,
c(‘‘lon’’, ‘‘lat’’)]), points = FALSE, add = TRUE, lwd = 3)

###############################################################################

# Spatial Autocorrelation 
# Roger Bivand
