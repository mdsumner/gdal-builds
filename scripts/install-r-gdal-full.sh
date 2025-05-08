#!/bin/bash
set -e

# install R
# *** check latest instructions from: https://cloud.r-project.org/bin/linux/ubuntu/ ***
# latest CRAN instructions for R 4.5.0 are copied here:
###############################################################################
# update indices
apt update -qq
# install two helper packages we need
apt install --no-install-recommends software-properties-common dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the repo from CRAN -- lsb_release adjusts to 'noble' or 'jammy' or ... as needed
add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
# install R itself
apt install --no-install-recommends r-base
###############################################################################

# add dev
apt install --no-install-recommends r-base-dev

# system requirement for package xml2 which is a gdalraster dependency
apt install libxml2-dev

# libcurl is needed for some gdalraster suggested packages or their dependencies
apt install libcurl4-openssl-dev

Rscript -e 'install.packages(c("Rcpp", "RcppInt64", "nanoarrow", "bit64", "wk", "xml2"))'

# install gdalraster suggested packages
# This takes a while since these packages also need several of their own dependencies.
# The full set is optional. To run the test suite, we really just need testthat. In that case,
# tests that need gt would fail but that could be safely ignored in some testing scenarios
# since it is only for display.
Rscript -e 'install.packages(c("gt", "knitr", "rmarkdown", "scales", "testthat"))'

Rscript -e 'install.packages("gdalraster", repos = c("https://usdaforestservice.r-universe.dev", "https://cran.r-project.org"), INSTALL_opts = "--install-tests")'

## get the artefacts
mkdir dev
cd dev
git clone https://github.com/USDAForestService.git
cd ..

mkdir cran
Rscript -e 'download.packages("gdalraster", destdir = "cran")'


