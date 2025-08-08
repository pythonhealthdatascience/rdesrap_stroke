# Data Dictionary: `parameters` JSON

## Top-level key: `simulation_parameters`

Type: `object`

Description:  Maps parameter names (str) to a specification describing how to sample from a statistical distribution for this metric in the simulation.

## Structure summary

Each item under `simulation_parameters` is itself an object with:

* `class_name`: The name of the distribution class to use.
* `params`: An object containing parameters required by that distribution.

## Parameter specification table

| Field | Data type | Description | Example/Allowed values |
| - | - | - | - |
| Parameter name | str (object key) | Description name for the parameter: `<unit>_<metric>_<type>` | `asu_arrival_stroke`, `rehab_los_other`, `asu_routing_tia` |
| `class_name` | str | Statistical distribution for the parameter | `Exponential`, `Lognormal`, `DiscreteEmpricial` |
| `params ` | Object | Dictionary of parameters required to instantiate the distribution | See subsequent rows per distribution type |

## Distribution-specific `params` field

| `class_name` | Parameter key(s) | Data type | Description | Example values |
| - | - | - | - | - |
| `exponential` | mean | float | Mean of exponential distribution | `1.2`, `9.3` |
| `lognormal` | mean, sd OR meanlog, sdlog | float | Mean and standard deviation of lognormal distribution, or the transformed versions. | `mean: 7.4`, `sd: 8.61` |
| `discrete` | values, prob | list (str/float) | Possible discrete values; corresponding probabilities or frequencies | `values: ["rehab", "esd", "other"]`, `prob: [0.24, 0.13, 0.63]` |

## Glossary

### Unit

* `asu`: Acute Stroke Unit
* `rehab`: Rehabilitation Unit

### Metric

* `arrival`: Interarrival time (days between admissions)
* `los`: Length of stay (days in unit)
* `routing`: Probabilities of routing/discharge

### Type

For `iat`/`los`:

* `stroke`: Stroke patients
* `tia`: Transient ischaemic attack patients
* `neuro`: Complex neurological patients
* `other`: Other patient types
* `stroke_noesd`, `stroke_esd`: Stroke patients split by whether they were transferred to early supported discharge (ESD).

For `routing`:

* `[diagnosis]_rehab`: Probability of transferring to rehabilitation unit
* `[diagnosis]_esd`: Probability of early supported discharge (ESD).
* `[diagnosis]_other`: Probability of other discharge pathways
