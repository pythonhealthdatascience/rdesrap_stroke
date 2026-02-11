# Contributing

Thank you for your interest in contributing! 🤗

This file covers:

* 🐞 Workflow for bug reports, feature requests and documentation improvements
* 🚀 Workflow for code contributions (bug fixes, enhancements)
* 🛠️ Development and testing
* 📦 Updating the package
* 🤝 Code of conduct

<br>

## 🐞 Workflow for bug reports, feature requests and documentation improvements

Before opening an issue, please search [existing issues](https://github.com/pythonhealthdatascience/rdesrap_stroke/issues) to avoid duplicates. If an issue exists, you can add a comment with additional details and/or upvote (👍) the issue. If there is not an existing issue, please open one and provide as much detail as possible.

* **For feature requests or documentation improvements**, please describe your suggestion clearly.
* **For bugs**, include:
    * Steps to reproduce.
    * Expected and actual behaviour.
    * Environment details (operating system, R version, dependencies).
    * Relevant files (e.g. problematic `.qmd` files).

### Handling bug reports (for maintainers):

* Confirm reproducibility by following the reported steps.
* Label the issue appropriately (e.g. `bug`).
* Request additional information if necessary.
* Link related issues or pull requests.
* Once resolved, close the issue with a brief summary of the fix.

<br>

## 🚀 Workflow for code contributions (bug fixes, enhancements)

1. Fork the repository and clone your fork.

2. Create a new branch for your feature or fix:

```{.bash}
git checkout -b my-feature
```

3. Make your changes and commit them with clear, descriptive messages using the [conventional commits standard](https://www.conventionalcommits.org/en/v1.0.0/).

4. Push your branch to your fork:

```{.bash}
git push origin my-feature
```

5. Open a pull request against the main branch. Describe your changes and reference any related issues.

<br>

## 🛠️ Development and testing

### Dependencies

Set up the R environment using `renv` (recommended):

```{.r}
renv::init()
renv::restore()
```

If you encounter issues restoring the exact environment, you can install dependencies from `DESCRIPTION` and generate your own lock file:

```{.r}
renv::init()
renv::install()
renv::snapshot()
```

Some packages (e.g. `igraph`) may require system libraries. For example, for Ubuntu:

```{.bash}
sudo apt install build-essential gfortran
sudo apt install libglpk-dev libxml2-dev
```

<br>

### Tests

Run tests:

```{.r}
devtools::test()
```

Compute test coverage:

```{.r}
devtools::test_coverage()
```

<br>

### Linting

```{.r}
lintr::lint_dir()
```

<br>

## 📦 Updating the package

If you are a maintainer and need to publish a new release:

1. Update `NEWS.md`.

2. Update the version number in `DESCRIPTION` and `CITATION.cff`, and update the date in `CITATION.cff`.

3. Create a release on GitHub, which will automatically archive to Zenodo.

<br>

## 🤝 Code of conduct

Please be respectful and considerate. See the [code of conduct](https://github.com/pythonhealthdatascience/rdesrap_stroke/blob/main/CODE_OF_CONDUCT.md) for details.