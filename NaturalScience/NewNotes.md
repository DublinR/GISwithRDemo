http://ibis.geog.ubc.ca/~rdmoore/Rcode.htm

R code - Handy routines for hydrologists

### What is R?

R is an open source programming language and environment for data analysis. It has rich functionality for data processing, analysis and graphing. See the R home page for more information and to download the package. Be forewarned that R has a steep learning curve. However, once you gain proficiency in R, the time invested in learning R will be paid back many times over.


### R and hydrology

Data analysis is an integral part of hydrology. Hydrologists frequently use techniques, such as regression analysis, which are incorporated into conventional statistical packages and spreadsheet software. However, many hydrological analyses are not, including intensity-duration-frequency analysis and flood frequency analysis. These analyses are relatively simple to code in R.


### An R package to access HYDAT data -- Version 2.0

Dave Hutchinson of Environment Canada has developed a package for R to facilitate access to HYDAT, the archive for Canadian hydrometric data. You can access a zipped folder containing the package via the following link:

HYDAT 2.0 - zip file
Note: This is a new version, uploaded 2014 April 8.


#### R scripts for specific hydrologic analyses

What I have included here are bits of R code that hydrologists may find useful. If you have written some code that you would like to share, please send it along and I'll consider posting it here.

Intensity-duration-frequency graph paper
Flood frequency plotting on extreme value graph paper
Fitting a power-law relation between stream discharge and stage
Binomial filter for regularly sampled time series
Baseflow separation using a recursive low-pas filter (Nathan and McMahon, 1991, WRR)
Use of linear regression to fill in missing air temperature data, with separate regressions by month
Performs intensity-duration-frequency analysis for Nanaimo Airport, Vancouver Island
Function to generate Extreme Value I (Gumbel) plot; called by Nanaimo-idf.r
