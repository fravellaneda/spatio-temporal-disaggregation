## Spatio-temporal disaggregation model 

in_between <- function(x, lower, upper) {
  as.integer(x > lower & x < upper)
}


## ------------------- Formula of the model ----------------------------------
form <- y ~ 0  + intercept1 + f(st1, model = stmodel) 

## ------------------------ Stack --------------------------------------------
stack1 <- inla.stack(
  data = list(y = as.vector(y)),
  A = list(A.st), 
  effects = list(list(intercept1 = 1, 
                      st1 = 1:(nt*nv)))) 

# Stack for predicting y1
stkpre1 <- inla.stack(tag = "pre1",
                      data = list(y = rep(NA, nrow(dpdf))),
                      A = list(A.pr.st),
                      effects = list(
                        list(intercept1 = rep(1, (nv*nt)),
                             st1 = 1:(nv*nt))
                      ))

stack <- inla.stack(stack1,stkpre1)

# ----------------------- Modeling ------------------------------------------
t1 <-Sys.time()
result_inla <- inla(form, 'gaussian',
                    data = inla.stack.data(stack),
                    control.predictor = list(A = inla.stack.A(stack),
                                             compute = TRUE,link=1),
                    control.inla = list(int.strategy = 'eb'),
                    verbose = TRUE
)
t2 <-Sys.time()
print("Time Modeling")
print(t2-t1)


# ---------------------- Prediction -------------------------------------
idx.y1 <- inla.stack.index(stack, 'pre1')$data
dpdf$pred.l1 <- result_inla$summary.linear.predictor[idx.y1, "mean"]


# ---------------------- CI for parameters ----------------------------

cove <- cbind(true = c((1 / ((params[[1]])^2)), log(params[c(2,3,4)])),
              result_inla$summary.hyper[, c(1, 2,3,4,5)])
cove["alpha",1] <- alpha.a
cove["alpha",2:6] <- result_inla$summary.fixed[, c(1, 2,3,4,5)]

cove$inside <- in_between(
  x     = cove$true,
  lower = cove$`0.025quant`,
  upper = cove$`0.975quant`
)
