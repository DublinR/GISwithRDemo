*http://abouthydrology.blogspot.ie/2012/08/r-resources-for-hydrologists.html*

* HydroGOF and HydroTSM by Mauricio Zambrano-Bigiarini.  The first provides functions implementing both statistical and graphical goodnes-of-fit measures between observed and simulated values, mainly oriented to be used during the calibration, validation, and application of hydrological models. The second provides functions for management, analysis, interpolation and plotting of time series used in hydrology and related environmental sciences.  Mauricio also had a poster at EGU 2010 general assembly on the topic.
* RMWAGEN by Emanuele Cordano which is a weather generator, a package that contains functions for spatial multi-site stochastic generation of daily timeseries of temperature and precipitation. A presentation can be found here.
Other stochastic generators of precipitation can be found here. Do not forget to explore the links in that page, and particularly the presentations given at the Roscoff's Workshop on stochastic generators, where many examples are in R
* The Rwiki Hydrological data Analysis which includes TOPMODEL and tools for DEM analysis (this last type of tools however are also available through the work by R. Bivand, E.J. Pebesma and V. Gomez-Rubio ) and many other tools for plotting and managing time series. These are promoted by Wouter Buytaert and Dominik Reusser who also gave a nice tutorial at EGU.
By the same authors also R-Hydro: Hydrological models and tools to represent and analyze hydrological data. 

* Hydromad: It provides a modelling framework for environmental hydrology: water balance accounting and flow routing in spatially aggregated catchments. It supports simulation, estimation, assessment and visualisation of flow response to time series of rainfall and other drivers
* TUWmodel  is a lumped conceptual rainfall-runoff model, following the structure of the HBV model. The model runs on a daily time step and consists of a snow routine, a soil moisture routine and a flow routing routine. See Parajka, J., R. Merz, G. Bloeschl (2007) Uncertainty and multiple objective calibration in regional water balance modelling: case study in 320 Austrian catchments, Hydrological Processes, 21, 435-446.
* RCode: Handy routines for Hydrologists by Dan Moore and others.
* Hydrosanity: It provides a graphical user interface for exploring hydrological time series. It is designed to work with catchment surface hydrology data (mainly rainfall and streamflow time series at a set of locations). There are functions to import from a database or files; summarise and visualise the dataset in various ways; estimate areal rainfall; fill gaps in rainfall data; and estimate the rainfall-runoff relationship. Probably the most useful features are the interactive graphical displays of a spatial set of time series. (This project seems actually being abandoned). 
aqp: Algorithms for quantitative pedology. A collection of algorithms related to modeling of soil resources, soil classification, soil profile aggregation, and visualization by Dylan Beaudette and Pierre Roudier. A paper talking about it is given here. And a presentation is not missing.
A package for plotting soil water retention curves and hydraulic conductivity by Emanuele Cordano, Fabio Zottele and Daniele Andreis is soilwater.
soilDB, of the same authors of aqp, is useful to access some soil databases.
soiltexture: Functions for soil texture plot, classification and transformation by Jules Moeys

* Hydrome: This package estimates the parameters in infiltration and water retention models by curve-fitting method.
hydropso: This package implements a state-of-the-art version of the Particle Swarm Optimisation (PSO) algorithm, with a special focus on the calibration of environmental models.
EcoHydRology developed by DR. Fuka, MT Walter, JA Archibald,  TS Steenhuis, and ZM Easton which presents a community modeling foundation for Eco-Hydrology. 

* nsRFA:  this is collection of statistical tools for objective (non-supervised) applications of the Regional Frequency Analysis methods in hydrology made by Alberto Viglione. The package refers to the index-value method and, more precisely, helps the hydrologist to: (1) regionalize the index-value; (2) form homogeneous regions with similar growth curves; (3) fit distribution functions to the empirical regional growth curves. 
http://cran.r-project.org/web/packages/nsRFA/nsRFA.pdf
* Wasim: Helpful tools for data processing and visualisation of results of the hydrological model WASIM-ETH.
Geotopbricks by Emanuele Cordano, analyses raster maps and other information as input/output files from the Hydrological Distributed Model GEOtop
Lmoments and Lmomco are two packages for the estimation of the L-moments of a distribution.

* The SPEI R Package by Santiago Begueria which includes a set of functions for computing potential evapotranspiration and several widely used drought indices including the Standardized Precipitation-Evapotranspiration Index (SPEI). 
* The USGS-R packages at github
* Alessio Pugliese and Attilio Castellarin - pREC: a package for the regionalisation of some hydrological variables.


