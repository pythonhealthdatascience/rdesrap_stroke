# Quality Assurance (QA)

## Roles and responsibilities

**Analyst:** Amy Heather (developed the model and implemented the analysis).

**Assurer/Approver:** Tom Monks (provided independent review proportionate to a small teaching example).

## QA when scoping the project

Scoping was agreed verbally between analyst and assurer: replicate the stroke capacity model from [Monks et al. 2016](https://doi.org/10.1186/s12913-016-1789-4) using simmer. No formal written scoping document was produced, which would be expected for larger or higher‑risk work, but was judged unnecessary here.

No explicit QA plan (who, what, how much) was written at the outset; this document provides a retrospective QA summary and lessons learned for future projects.

## QA when designing the analysis

The analytical approach was simply to replicate the model as described, without introducing any new structural design choices for the model itself. Any decisions were limited to code organisation, which was intentionally implemented as a modular package.

Verification and validation strategy was not agreed in advance but was developed iteratively during the analysis as issues and checks were identified.

Design decisions were not recorded in a separate design document; for future models, capturing key decisions in a short design or analysis‑plan file would be preferable.

## QA when performing the analysis

Verification and validation activities were carried out during development, and checked in a [summary GitHub issue](https://github.com/pythonhealthdatascience/rdesrap_stroke/issues/18) (serving as part of the QA log). Checks were proportionate to purpose of the model (replication, and as an example for training materials).

Assurance of code and workflows was ensured by following the [STARS Reproducibility Recommendations](https://doi.org/10.1080/17477778.2025.2552177) and the [NHS Levels of RAP Framework](https://nhsdigital.github.io/rap-community-of-practice/introduction_to_RAP/levels_of_RAP/).

Code is documented with docstrings and comments to aid understanding and reuse. User and technical documentation are currently provided via the [DES RAP Book](https://github.com/pythonhealthdatascience/des_rap_book). To avoid duplication of this material, the repository does not have it's own standalone user instructions or detailed technical description of the model structure, which would be expected for a model in practice.

GitHub issues act as an informal QA plan and log; for future projects, a more explicit QA project board and short summary of decisions and changes would strengthen the audit trail.