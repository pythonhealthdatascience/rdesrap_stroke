# Reproducibility recommendations from Heather et al. 2025

As part of the project STARS (Sharing Tools and Artefacts for Reproducible Simulations), a series of computational reproducibility assessments were conducted by Heather et al. 2025 (**TODO: add DOI of pre-print**). From these, several recommendations were shared to support reproducibility of healthcare discrete-event simulation (DES) models. These are copied below. Those marked with a star (⭐) were identified as having the greatest impact in Heather et al. 2025.

## Recommendations to support reproduction

| Recommendation | Completion | Further details |
| - | - | - |
| **Set-up** |
| Share code with an open licence (⭐) | ✅ | `LICENSE` and `LICENSE.md` |
| Link publication to a specific version of the code | ✅ | - |
| List dependencies and versions | ✅ | `renv.lock` and `DESCRIPTION` |
| **Running the model** |
| Provide code for all scenarios and sensitivity analyses (⭐) | ✅ | `analysis.Rmd` |
| Ensure model parameters are correct (⭐) | ✅ | - |
| Control randomness | ✅ | - |
| **Outputs** |
| Include code to calculate all required model outputs (⭐) | ✅ | - |
| Include code to generate the tables, figures, and other reported results (⭐) | ✅ | `analysis.Rmd` |

## Recommendations to support troubleshooting and reuse

| Recommendation | Completion | Further details |
| - | - | - |
| **Design** |
| Separate model code from applications | ✅ | - |
| Avoid hard-coded parameters | ✅ | - |
| Minimise code duplication | ✅ | - |
| **Clarity** |
| Comment sufficiently | ✅ | - |
| Ensure clarity and consistency in the model results tables | ✅ | - |
| Include run instructions | ✅ | - |
| State run times and machine specifications | ✅ | In `README.md` and `.Rmd` files. |
| **Functionality** |
| Optimise model run time | ✅ | Provides option for parallel processing. |
| Save outputs to a file | ✅ | - |
| Avoid excessive output files | ✅ | - |
| Address large file sizes | N/A | - |