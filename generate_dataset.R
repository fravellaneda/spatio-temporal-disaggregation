## Generate aggregated dataset from the continous spatio-temporal dataset

source("generate_cont.R")

## --------------- Generating prediction locations ---------------------------

x <- seq(0+(1/(2*dim)),1-(1/(2*dim)), 1/dim)
dp_pre <- as.matrix(expand.grid(x, x))

dp <- as.data.frame(dp_pre)
dpdf <- dp[rep(1:nrow(dp), times = nt), ]
names(dpdf) <- c("x","y")
dpdf$time <- rep(1:nt, each = nrow(dp))
rownames(dpdf) <- 1:nrow(dpdf)

dpdf$z1 <- df$z1

## -------------- Generating the aggregated map ------------------------------

# Box in the spatial setting
box <- st_bbox(c(xmin = 0, ymin = 0,
                 xmax = 1, ymax = 1), crs = st_crs(4326))

# Map based in the new aggregated dimensions
map <- st_sf(id = 1:((dim/nsf)*(dim/nsf)),
             geometry=st_make_grid(box, n = c(dim/nsf,dim/nsf)),
             crs = st_crs(4326))
n.ar <- nrow(map) # Number of regions

# sf object of the prediction locations
df_sf <- st_as_sf(df,
                     coords = c("x","y"), crs = "EPSG:4326")

# Defining a spatial id
inters <- as.list(st_contains(map[,c()],df_sf))

for (i in 1:n.ar){
  df[inters[[i]],"ids"] <- i
}

# Temporal id
df$idt <- (floor((df$time-1)/ntf))+1

# Aggregated dataset based in the spatial and temporal id
part.df <- aggregate(cbind(x,y,z1) ~ 
                       ids + idt , data = df,FUN = mean)

# Aggregated the standard error in the aggregated setting.
part.df[,paste0("e",1)] <- rnorm(nrow(part.df), 0, params[[1]])
part.df[,paste0("l",1)] <- part.df[,paste0("z",1)] + part.df[,paste0("e",1)] 

# variable of interest
y <- part.df$l1

## --------------------- Projection Matrix -----------------------------------

# Create spatial mesh
smesh <- inla.mesh.2d(
  loc.domain = domain,
  max.edge = c(0.06))
nv <- smesh$n

# spatial mesh in a sf object
mesh_sf <- st_as_sf(data.frame(x=smesh$loc[,1],y=smesh$loc[,2]),
                    coords = c("x","y"), crs = "EPSG:4326")

# Projection Matrix in space

A.m <- matrix(0, n.ar, nv)
inter <- as.list(st_contains(map[,c()],mesh_sf))

for (i in 1:n.ar){
  idx <- inter[[i]]
  A.m[i,idx] <- 1/length(idx)
}

A.m <- as(A.m, "dgCMatrix")

# Projection matrix in time 
generate_a_t <- function() {
  A.t <- matrix(0, nrow = nt / ntf, ncol = nt)
  
  f <- 1
  
  for (j in 1:(nt/ntf)){
    for (i in 1:ntf){
      A.t[j,f] <- 1/ntf
      f <- f+1
    }
  }
  
  return(A.t)
}

A.t <- generate_a_t()
A.t.pred <- diag(1, nt)

# Spatio-temporal projection matrix for observations

A.st <- as(kronecker(A.t, A.m), "dgCMatrix")

# Projection matrix for prediction locaitons

coo <- cbind(dpdf[dpdf$time==1,]$x,dpdf[dpdf$time==1,]$y)
A.pr <- inla.spde.make.A(mesh = smesh, loc = coo)
A.pr.st <- as(kronecker(A.t.pred, A.pr), "dgCMatrix")

## ------------------- Spatio-temporal model ---------------------------------

stmodel <- stModel.define(
  smesh = smesh,
  tmesh = tmesh,
  model = modelstn,
  control.priors = list(
    prs = c(params[[2]]*(1/4), 0.05),
    prt = c(params[[3]]*(1/4), 0.05),
    psigma = c((3*params[[4]]), 0.05)))