# Data dictionary for `parameters.csv`

| Column | Data type | Description | Possible values |
| - | - | - | - |
| unit | str | Hospital unit | `asu`: Acute Stroke Unit<br>`rehab`: Rehabilitation Unit (post-acute recovery care) |
| parameter | str | Type of operational metric | `iat`: Inter-arrival time (time between patient admissions)<br>`los`: Length of stay (duration from admission to discharge)<br>`routing`: Transition probability between care pathways  |
| type | str | Patient classification or care transition path | **For `iat`/`los`:**<br>`stroke`: Stroke patients<br>`stroke_esd`: Stroke patients transferred to Early Supported Discharge<br>`stroke_no_esd`: Stroke patients not transferred to Early Supported Discharge<br>`tia`: Transient Ischemic Attack patients<br>`neuro`: Complex neurological patients<br>`other`: Other patient types<br><br>**For `routing`:**<br>`[diagnosis]_rehab`: Probability of transferring to rehabilitation unit<br>`[diagnosis]_esd`: Probability of Early Supported Discharge<br>`[diagnosis]_other`: Probability of other discharge pathways |
| mean | float | **For `iat`:** Mean days between admissions<br>**For `los`:** Mean days in unit<br>**For `routing`:** Probability (0-1 scale) | - |
| sd | float | Standard deviation of the mean | - |