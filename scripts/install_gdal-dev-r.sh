#!/bin/bash
set -e

## Install PROJ, GDAL, GEOS from source.
##
## 'latest' means installing the latest release version.

## build ARGs
NCPUS=${NCPUS:-"-1"}

CRAN_SOURCE=${CRAN_SOURCE:-"https://cloud.r-project.org"}
echo "options(repos = c(CRAN = '${CRAN}'))" >>"${R_HOME}/etc/Rprofile.site"

# cmake does not understand "-1" as "all cpus"
CMAKE_CORES=${NCPUS}
if [ "${CMAKE_CORES}" = "-1" ]; then
    CMAKE_CORES=$(nproc --all)
fi

# ;)
export MAKEFLAGS="-j$(nproc)"



apt-get update && apt-get -y install cargo

export RETICULATE_PYTHON=/usr/bin/python3


install2.r --error --skipmissing -n -1 -r "${CRAN_SOURCE}" \
     adbcdrivermanager \
     affinity \
     archive \
     assertthat \
     aws.signature \
     AzureStor \
     base64enc \
     biglm \
     brio \
     callr \
     carrier \
     cli \
     clisymbols \
     colourvalues \
     crayon \
     crew \
     crew.cluster \
     crul \
     curl \
     DBI \
     desc \
     digest \
     dotenv \
     duckdbfs \
     exactextractr \
     fasterize \
     fields \
     fst \
     furrr \
     future.batchtools \
     gdalcubes \
     gdalraster \
     geoarrow \
     geodata \
     geometries \
     geos \
     geosphere \
     gibble \
     glue \
     gmailr \
     graticule \
     hms \
     httptest2 \
     httr \
     jpeg \
     jsonlite \
     knitr \
     lwgeom \
     mapscanner \
     mapview \
     minioclient \
     mirai \
     mmand \
     multidplyr \
     osmdata \
     palr \
     paws.storage \
     pkgbuild \
     plainview \
     polyclip \
     prettyunits \
     processx \
     progress \
     purrr \
     PROJ \
     qs \
     quadmesh \
     R.utils \
     rbgm \
     rcmdcheck \
     rematch2 \
     remotes \
     reticulate \
     rgl \
     rjags \
     rlang \
     rsi \
     rslurm \
     RSQLite \
     rstac \
     RTriangle \
     sessioninfo \
     sf \
     sfheaders \
     silicate \
     sits \
     sooty \
     spex \
     stars \
     stringr \
     tarchetypes \
     targets \
     terra \
     terrainmeshr \
     tibble \
     tidync \
     trip \
     tripEstimation \
     urlchecker \
     vapour \
     whoami \
     withr \
     wk \
     xml2 \
     yaml



Rscript -e 'devtools::install_github(c("hypertidy/whatarelief", "hypertidy/grout", "hypertidy/ximage", "hypertidy/sds", "hypertidy/dsn", "hypertidy/controlledburn"))'

#"AustralianAntarcticDivision/Grym"
Rscript -e 'devtools::install_github(c("AustralianAntarcticDivision/raadfiles", "AustralianAntarcticDivision/raadtools", "AustralianAntarcticDivision/blueant",  "ropensci/bowerbird"))'

Rscript -e 'devtools::install_github(c("hypertidy/anglr", "keller-mark/pizzarr"))'

Rscript -e 'BiocManager::install("Rarr", update = FALSE, ask = FALSE)'

#Rscript -e 'remotes::install_github("DOI-USGS/rnz")'

Rscript -e 'devtools::install_github(c("mdsumner/bluelink", "mdsumner/pymdim", "mdsumner/ngdal"))'

Rscript -e 'devtools::install_github(c("r-lib/revdepcheck"))'

## use the SCAR r-universe package repository
Rscript -e 'op <- options(repos = c(SCAR = "https://scar.r-universe.dev", CRAN = "https://cloud.r-project.org")); install.packages("bowerbird", Ncpus = 4); options(op)'

strip /usr/local/lib/R/site-library/*/libs/*.so

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages
rm -rf /*.deb /build_thirdparty /build_local

apt-get autoclean -y
apt-get autoremove -y
##rm -rf /var/lib/{apt,dpkg,cache,log}


unset MAKEFLAGS

