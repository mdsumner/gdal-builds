#!/bin/bash
set -e

. /etc/os-release printf '%s\n' "$VERSION_CODENAME"

## this from -----------------------------------------------------------------------------
## https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_R_ppa.sh
CRAN_LINUX_VERSION=${CRAN_LINUX_VERSION:-cran40}
LANG=${LANG:-en_US.UTF-8}
LC_ALL=${LC_ALL:-en_US.UTF-8}
DEBIAN_FRONTEND=noninteractive

# Set up and install R
R_HOME=${R_HOME:-/usr/lib/R}

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen en_US.utf8
/usr/sbin/update-locale LANG=${LANG}

#R_VERSION=${R_VERSION}

apt-get update

apt-get -y install --no-install-recommends \
      ca-certificates \
      less \
      locales \
      vim-tiny \
      wget \
      dirmngr \
      gpg \
      gpg-agent \
      git \
      libopenblas-dev \
      liblapack-dev

echo "deb http://cloud.r-project.org/bin/linux/ubuntu ${VERSION_CODENAME}-${CRAN_LINUX_VERSION}/" >> /etc/apt/sources.list

## needs review:
###  http://cloud.r-project.org/bin/linux/ubuntu/noble-cran40/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg),
### see the DEPRECATION section in apt-key(8) for details.
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add -


# Wildcard * at end of version will grab (latest) patch of requested version
apt-get update && apt-get -y install  r-base-dev=${R_VERSION}*

## -----------------------------------------------------------------------


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


