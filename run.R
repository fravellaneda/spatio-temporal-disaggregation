### run disagreggation spatio-temporal

library(INLA)
library(INLAspacetime)
library(inlabru)
library(fmesher)
library(knitr)
library(MASS)

library(sf)
library(ggplot2)
library(spatstat)
library(patchwork)
library(dplyr)

list2env(list(r0=1, nt=24, dim=24), envir = .GlobalEnv)

# Kind of model, 1 non-separable, 0 separablee
modelst <- 1

if (modelst == 1){
  modelstn <- "102"
} 

if (modelst == 0){
  modelstn <- "121"
}

# Spatial aggregation factor
nsf <- 3

# Temporal aggregation factor
ntf <- 3

# Configuration: 1, weak autocorrelation, 2 moderate autocorrelation
#                3, strong autocorrelation.
config <- 3

# Plots per page
plotspp <- 6


load_params <- function(config) {
  # Load parameters for the simulation
  alpha.a <- 0.1
  
  # Spatial range mapping
  rt <- switch(
    as.character(config),
    "1" = 1*(modelst+1),  # Weak
    "2" = 3*(modelst+1),  # Moderate
    "3" = 12*(modelst+1)  # Strong
  )
  
  # variance random process
  sigma.u <-  0.25
  
  # spatial range
  rs <- 0.2
  
  # Unstructured error
  e.sd <- 0.15
  
  # Putting all together
  params <- c(e.sd = e.sd, rs = rs, rt = rt, sigma.u = sigma.u)
  
  # Export into caller
  list2env(list(params = params, alpha.a = alpha.a),
           envir = parent.frame())
}

load_params(config)

tini <-Sys.time()
print("Temporal factor")
print(ntf)
print("Spatial factor")
print(nsf)

hyperparams <- list()

print("Generate dataset")
source("generate_dataset.R")

print("Modeling")
source("st_dis_model.R")

print("Ploting")
source("plot_results.R")

tfini <-Sys.time()
print("Time Total")
print(tfini-tini)
