# Plots of the spatio-temporal modeling

# List with all plots
pplots <- list()

# Boundaries for the colors
minz <- min(dpdf$pred.l1,dpdf$z1,part.df$l1)
maxz <- max(dpdf$pred.l1,dpdf$z1,part.df$l1)

# For loop to plot the true data
for (i in 1:6){
  pplots[[i]] <- ggplot() +
    geom_tile(data=df[df$idt==i,], aes(x = x, y = y, fill = z1)) +
    coord_equal() +
    ggtitle(paste0("Time: ",i)) +
    scale_fill_viridis_c(option = "plasma",
                         limits = c(minz,maxz)) + 
    xlab("") + ylab("") +
    theme_minimal() +
    theme(legend.position = "none",axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),plot.title.position = "plot",
          plot.title = element_text(hjust = 0.52, vjust = -1))
}

# For loop to plot aggregated data
for (j in 1:2){
  i <- i+1
  if (j==1) {
    timen <- paste0("1-",ntf)
  } else{
    timen <- paste0((ntf+1),"-",(2*ntf))
  }
  pplots[[i]] <- ggplot() +
    geom_tile(data=part.df[part.df$idt==j,], aes(x = x, y = y, fill = z1)) +
    coord_equal() +
    ggtitle(paste0("Times: ",timen)) +
    scale_fill_viridis_c(option = "plasma",
                         limits = c(minz,maxz)) + 
    xlab("") + ylab("") +
    theme_minimal() +
    theme(legend.position = "none",axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),plot.title.position = "plot",
          plot.title = element_text(hjust = 0.6, vjust = -42))
}

# For loop to plot predictions
for (j in 1:6){
  i <- i+1
  pplots[[i]] <- ggplot() +
    geom_tile(data=dpdf[dpdf$time==j,], aes(x = x, y = y, fill = pred.l1)) +
    coord_equal() +
    ggtitle(paste0("Time: ",j)) +
    scale_fill_viridis_c(option = "plasma",
                         limits = c(minz,maxz)) + 
    xlab("") + ylab("") +
    theme_minimal() +
    theme(legend.position = "none",axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),plot.title.position = "plot",
          plot.title = element_text(hjust = 0.52, vjust = -1))
}

# header for the columns
header_plot <- function(label) {
  ggplot() + 
    annotate("text", x = 0.5, y = 0.5, label = label, size = 5) +
    theme_void()
}

H_true <- header_plot("True data")
H_agg  <- header_plot("Aggregated")
H_dis  <- header_plot("Disaggregation model")

# Designs for the whole image
design <- c(
  # headers (row 1)
  area(t = 1, l = 1, b = 1, r = 1),  # H_true
  area(t = 1, l = 2, b = 1, r = 2),  # H_agg
  area(t = 1, l = 3, b = 1, r = 3),  # H_dis
  
  # below headers (rows 2–7)
  area(t = 2, l = 1, b = 2, r = 1),  # A (true 1)
  area(t = 2, l = 2, b = 4, r = 2),  # B (agg top)
  area(t = 2, l = 3, b = 2, r = 3),  # C (dis 1)
  
  area(t = 3, l = 1, b = 3, r = 1),  # D
  area(t = 3, l = 3, b = 3, r = 3),  # E
  area(t = 4, l = 1, b = 4, r = 1),  # F
  area(t = 4, l = 3, b = 4, r = 3),  # G
  
  area(t = 5, l = 1, b = 5, r = 1),  # H
  area(t = 5, l = 2, b = 7, r = 2),  # I (agg bottom)
  area(t = 5, l = 3, b = 5, r = 3),  # J
  area(t = 6, l = 1, b = 6, r = 1),  # K
  area(t = 6, l = 3, b = 6, r = 3),  # L
  area(t = 7, l = 1, b = 7, r = 1),  # M
  area(t = 7, l = 3, b = 7, r = 3)   # N
)

# Plotlist with all plots 
plotlist <- list(
  H_true, H_agg, H_dis,           # headers
  pplots[[1]], pplots[[7]], pplots[[9]],
  pplots[[2]], pplots[[10]], pplots[[3]], pplots[[11]],
  pplots[[4]], pplots[[8]], pplots[[12]],
  pplots[[5]], pplots[[13]],
  pplots[[6]], pplots[[14]]
)

# Final plot
final_plot <- wrap_plots(plotlist = plotlist) +
  plot_layout(design = design, widths = c(1, 0.4, 1), heights = c(0.15, rep(1, 6)))

final_plot

if (modelst ==1){
  modelstn <- "nonsep"
} else{
  modelstn <- "sep"
}

#ssave the plot
ggsave(paste("./images/sim_",modelstn,"_sf_",nsf,"_ntf_",ntf,".pdf"),
       final_plot, width = 30, height = 30, units = "cm")
