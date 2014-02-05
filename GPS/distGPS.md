distGPS Compute physical distance between point using GPS coordinates
=====================================================================
Description: The function read a data frame with the colomn "nom","lat" and "lon" (respectively, the name of the
sample, the longitude in degree.decimal and lattitude in degree.decimal) and compute the distance
between point in kilometers.

Usage: `distGPS(input)`

Arguments:
`input ` : A data frame with the colomn "nom","lat" and "lon" (respectively, the name of
the sample, the longitude in degree.decimal and lattitude in degree.decimal)

Details: Require the SoDA package.

Value: The output is a distance matrix with row and colomn names corresponding to the "nom" colomns
of the input data frame.

Author(s): Pierre Lefeuvre

Examples: 
<pre><code>
input <- data.frame(nom=c("a","b","c"),lat=c(-21,18,12),lon=c(32,16,-5))
distGPS(input)
</code></pre>
