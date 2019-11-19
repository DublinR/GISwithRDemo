%- http://lavaan.ugent.be/tutorial/growth.html


Another important type of latent variable models are latent growth curve models. Growth modeling is often used to analyze longitudinal or developmental data. In this type of data, an outcome measure is measured on several occasions, and we want to study the change over time. In many cases, the trajectory over time can be modeled as a simple linear or quadratic curve. 

Random effects are used to capture individual differences. The random effects are conveniently represented by (continuous) latent variables, often called growth factors. 

In the example below, we use an artifical dataset called Demo.growth where a score (say, a standardized score on a reading ability scale) is measured on 4 time points. To fit a linear growth model for these four time points, we need to specify a model with two latent variables: a random intercept, and a random slope:
