#!/bin/bash

# Ensure the script exits on error
set -e

# Find and render all .Rmd files in the specified directory
for file in "rmarkdown"/*.Rmd; do
    echo "Rendering: $file"
    Rscript -e "rmarkdown::render('$file')"
done

echo "Rendering complete!"
