# Bayesian spatio–temporal disaggregation modeling using a diffusion-SPDE approach: a case study of Aerosol Optical Depth in India

**Authors**: Fernando Rodríguez Avellaneda and Paula Moraga  

This repository implements the **Bayesian spatio–temporal disaggregation** framework using a **diffusion-based SPDE** (stochastic partial differential equation) model.  

The aim is to disaggregate coarse-resolution spatio-temporal data into finer spatial and temporal resolutions while preserving physically consistent diffusion-like dynamics.  

As a case study, the model is applied to **Aerosol Optical Depth (AOD)** at 550 nm over **India**, using reanalysis data from the ECMWF Atmospheric Composition Reanalysis 4 (EAC4) dataset.

---

## Repository Contents

```
- images/                                    # Figures of the simulation study
- aod-distribution-january-1-5-2024.gif      # Example GIF showing AOD temporal evolution in India
- generate_cont.R                            # Generates the continuous diffusion-SPDE latent field
- generate_dataset.R                         # Builds synthetic or coarse-resolution AOD datasets
- st_dis_model.R                             # Defines and fits the spatio–temporal disaggregation model
- plot_results.R                             # Produces maps, plots, and performance diagnostics
- run.R                                      # Main script to execute the full pipeline
```

---

## How to Run the Model

From an R console or terminal:

1. **Generate the latent diffusion field and datasets:**

   ```r
   source("generate_dataset.R")
   ```

2. **Fit the Bayesian spatio–temporal disaggregation model:**

   ```r
   source("st_dis_model.R")
   ```

3. **Visualize the results:**

   ```r
   source("plot_results.R")
   ```

Alternatively, run the full workflow end-to-end:

```r
source("run.R")
```

---

## Citation

If you use this repository, please cite:

> Rodríguez Avellaneda, F., & Moraga, P.  
> *Bayesian spatio–temporal disaggregation modeling using a diffusion-SPDE approach: a case study of Aerosol Optical Depth in India.*  
> Manuscript in preparation, 2025.

**BibTeX:**
```bibtex
@unpublished{rodriguez2025spatiotemporaldisaggregation,
  title   = {Bayesian spatio-temporal disaggregation modeling using a diffusion-SPDE approach: a case study of Aerosol Optical Depth in India},
  author  = {Fernando Rodriguez Avellaneda and Paula Moraga},
  year    = {2025},
  note    = {Manuscript in preparation}
}
```

---

## Contact

**Fernando Rodríguez Avellaneda**  
📧 fernando.rodriguezavellaneda@kaust.edu.sa
🌐 https://github.com/fravellaneda

**Paula Moraga**  
📧 paula.moraga@kaust.edu.sa
🌐 https://www.paulamoraga.com
