#!/bin/bash
set -e

apt-get update

# system requirement for package xml2 which is a gdalraster dependency
apt-get -y install --no-install-recommends libxml2-dev

# libcurl is needed for some gdalraster suggested packages or their dependencies
apt-get -y install --no-install-recommends libcurl4-openssl-dev

rm -rf /var/lib/apt/lists/*

#export MAKEFLAGS=-j4
Rscript -e 'install.packages(c("Rcpp", "RcppInt64", "nanoarrow", "bit64", "wk", "xml2"), Ncpus = 6)'

# install gdalraster suggested packages
# This takes a while since these packages also need several of their own dependencies.
# The full set is optional. To run the test suite, we really just need testthat. In that case,
# tests that need gt would fail but that could be safely ignored in some testing scenarios
# since it is only for display.
Rscript -e 'install.packages(c("gt", "knitr", "rmarkdown", "scales", "testthat"))'

Rscript -e 'install.packages("gdalraster", repos = c("https://usdaforestservice.r-universe.dev", "https://cran.r-project.org"), INSTALL_opts = "--install-tests")'

## get the artefacts
mkdir dev-pkgs
cd dev-pkgs
git clone https://github.com/USDAForestService/gdalraster.git
cd ..

mkdir cran
Rscript -e 'download.packages("gdalraster", destdir = "cran")'
