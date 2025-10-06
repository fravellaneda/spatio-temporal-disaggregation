##  Generate continous spatio-temporal surface

print("Generating spatio-temporal continous surface")
rxy <- c(1, 1) ## size of spatial domain


## ---------------- Setup rectangle for spatial domain ------------------------
bb <- rbind(
  x = c(0, rxy[1]),
  y = c(0, rxy[2]))
domain <- cbind(
  x = bb[c(1, 3, 3, 1, 1)],
  y = bb[c(2, 2, 4, 4, 2)])
boundary <- st_as_sf(as.polygonal(square(1)))

## ------------------- Generating the spatial mesh ---------------------------
smesh <- inla.mesh.2d(
  loc.domain = domain,
  max.edge = c(0.06))
nv <- smesh$n

## ------------------- Spatial Locations -------------------------------------
x <- seq(0+(1/(2*dim)),1-(1/(2*dim)), 1/dim)
dp_pre <- as.matrix(expand.grid(x, x))

## number locations in space
ns <- nrow(dp_pre) 

## data spacetime locations
df <- data.frame(
  time = rep(1:nt, each = ns),
  x = rep(dp_pre[,1],nt),
  y = rep(dp_pre[,2],nt))

## ------------------- Generating the temporal mesh ---------------------------
tmesh <- inla.mesh.1d(
  loc = seq(from=1,to=nt,by =1))

## ------------------- Preicision matrix and sample ---------------------------
qq <- stModel.precision(smesh = smesh,
                        tmesh = tmesh,
                        model = modelstn,
                        theta = log(params[c(2,3,4)]))
xx <- inla.qsample(n = 1, Q = qq)

## project the sample to spacetime data locations
A.d <- inla.spde.make.A(
  mesh = smesh,
  loc = cbind(df$x, df$y),
  group = df$time,
  group.mesh = tmesh)
df$z1 <- alpha.a + drop(A.d %*% xx)