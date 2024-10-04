#!/bin/bash
set -e

## Install PROJ, GDAL, GEOS from source.
##
## 'latest' means installing the latest release version.

## build ARGs
NCPUS=${NCPUS:-"-1"}

#GDAL_VERSION=${GDAL_VERSION:-"devel"}
GDAL_REPO=${GDAL_REPO:-"https://github.com/osgeo/gdal.git"}
GDAL_TAG=${GDAL_TAG:-""}  ## means latest commit, otherwise v3.8.2 or an actual commit sha
PROJ_VERSION=${PROJ_VERSION:-"latest"}
GEOS_VERSION=${GEOS_VERSION:-"latest"}

CRAN_SOURCE=${CRAN_SOURCE:-"https://cloud.r-project.org"}
echo "options(repos = c(CRAN = '${CRAN}'))" >>"${R_HOME}/etc/Rprofile.site"

# cmake does not understand "-1" as "all cpus"
CMAKE_CORES=${NCPUS}
if [ "${CMAKE_CORES}" = "-1" ]; then
    CMAKE_CORES=$(nproc --all)
fi

# ;)
export MAKEFLAGS="-j$(nproc)"

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

# a function to remove apt packages only if they are installed
function apt_remove() {
    if dpkg -s "$@" >/dev/null 2>&1; then
        apt-get remove -y "$@"
    fi
}

function url_latest_gh_released_asset() {
    wget -qO- "https://api.github.com/repos/$1/releases/latest" | grep -oP "(?<=\"browser_download_url\":\s\")https.*\.tar.gz(?=\")" | head -n 1
}

export DEBIAN_FRONTEND=noninteractive

apt_remove gdal-bin libgdal-dev libgeos-dev libproj-dev &&
    apt-get autoremove -y

## Derived from osgeo/gdal
apt-get update
apt-get install -y --fix-missing --no-install-recommends \
    ant \
    autoconf \
    automake \
    bash-completion \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    devscripts \
    emacs \
    git \
    htop \
    less \
    libarchive-dev \
    libarmadillo-dev \
    libblosc-dev \
    libboost-dev \
    libbz2-dev \
    libcairo2-dev \
    libclc-15-dev \
    libcfitsio-dev \
    libcrypto++-dev \
    libcurl4-openssl-dev \
    libdeflate-dev \
    libexpat-dev \
    libfreexl-dev \
    libfyba-dev \
    libgif-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libheif-dev \
    libhdf4-alt-dev \
    libhdf5-serial-dev \
    libjpeg-dev \
    libkml-dev \
    liblcms2-2 \
    liblerc-dev \
    liblz4-dev \
    liblzma-dev \
    libmysqlclient-dev \
    libnetcdf-dev \
    libogdi-dev \
    libopenexr-dev \
    libopenjp2-7-dev \
    libpcre3-dev \
    libpng-dev \
    libpq-dev \
    libpoppler-cpp-dev \
    libpoppler-dev \
    libpoppler-private-dev \
    libqhull-dev \
    libsqlite3-dev \
    libssl-dev \
    libtiff5-dev \
    libudunits2-dev \
    libwebp-dev \
    libxerces-c-dev \
    libxml2-dev \
    lsb-release \
    make \
    mdbtools-dev \
    nano \
    netcdf-bin \
    nco \
    pkg-config \
    python3-dev \
    python3-setuptools \
    qpdf \
    r-cran-rjags \
    r-cran-snowfall \
    rsync \
    sqlite3 \
    swig \
    unixodbc-dev \
    wget \
    zlib1g-dev \
    gmt gmt-dcw gmt-gshhg

# python3-numpy \
apt-get install -y --fix-missing --no-install-recommends python3-pip   && pip3 install --upgrade pip
ldconfig
python3 -m pip install numpy>=2.0


## geoparquet support
wget https://apache.jfrog.io/artifactory/arrow/"$(lsb_release --id --short | tr '[:upper:]' '[:lower:]')"/apache-arrow-apt-source-latest-"$(lsb_release --codename --short)".deb
apt_install -y -V ./apache-arrow-apt-source-latest-"$(lsb_release --codename --short)".deb
apt-get update && apt-get install -y -V libarrow-dev libparquet-dev libarrow-dataset-dev

rm -rf /build_local
mkdir /build_local && cd /build_local

## tiledb
GCC_ARCH="$(uname -m)"
export TILEDB_VERSION=2.16.3
apt-get update -y &&
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libspdlog-dev &&
    mkdir tiledb &&
    wget -q https://github.com/TileDB-Inc/TileDB/archive/${TILEDB_VERSION}.tar.gz -O - |
    tar xz -C tiledb --strip-components=1 &&
    cd tiledb &&
    mkdir build_cmake &&
    cd build_cmake &&
    ../bootstrap --prefix=/usr --disable-werror &&
    make "-j$(nproc)" &&
    make install-tiledb DESTDIR="/build_thirdparty" &&
    make install-tiledb &&
    cd ../.. &&
    rm -rf tiledb &&
    for i in /build_thirdparty/usr/lib/"${GCC_ARCH}"-linux-gnu/*; do strip -s "$i" 2>/dev/null || /bin/true; done &&
    for i in /build_thirdparty/usr/bin/*; do strip -s "$i" 2>/dev/null || /bin/true; done

LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# install geos
# https://libgeos.org/usage/download/
if [ "$GEOS_VERSION" = "latest" ]; then
    ## avoid rc/beta/alpha
    #GEOS_VERSION=$(wget -qO- "https://api.github.com/repos/libgeos/geos/git/refs/tags" | grep -oP "(?<=\"ref\":\s\"refs/tags/)\d+\.\d+\.\d+" | tail -n -1)
    GEOS_VERSION=$(wget -qO- "https://api.github.com/repos/libgeos/geos/git/refs/tags" | grep -oP "(?<=\"ref\":\s\"refs/tags/)\d+\.\d+\.\d+.*" | grep -v "beta" | grep -v "rc" | grep -v alpha | sed 's/,*$//g' | sed 's/"*$//g' | tail -n 1)
fi

## purge existing directories to permit re-run of script with updated versions
rm -rf geos* proj* gdal*

wget https://download.osgeo.org/geos/geos-"${GEOS_VERSION}".tar.bz2
bzip2 -d geos-*bz2
tar xf geos*tar
rm geos*tar
cd geos*
mkdir build
cd build
cmake ..
cmake --build . --parallel "$CMAKE_CORES" --target install
ldconfig
cd /build_local

# install proj
# https://download.osgeo.org/proj/
if [ "$PROJ_VERSION" = "latest" ]; then
    PROJ_DL_URL=$(url_latest_gh_released_asset "OSGeo/PROJ")
else
    PROJ_DL_URL="https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz"
fi

wget "$PROJ_DL_URL" -O proj.tar.gz
tar zxvf proj.tar.gz
rm proj.tar.gz
cd proj-*
mkdir build
cd build
cmake ..
cmake --build . --parallel "$CMAKE_CORES" --target install
ldconfig
cd /build_local


git clone ${GDAL_REPO}
cd gdal
if [[ -n "$GDAL_TAG" ]]; then
  git checkout ${GDAL_TAG}
fi
apt-get update && apt-get  install python3-pip  -y && pip3 install --upgrade pip
python3 -m pip install -r ./doc/requirements.txt
python3 -m pip install -r ./autotest/requirements.txt
mkdir build
cd ./build
# cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr   -DBUILD_JAVA_BINDINGS:BOOL=OFF -DBUILD_CSHARP_BINDINGS:BOOL=OFF
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --parallel "$CMAKE_CORES" --target install
ldconfig
cd /build_local

apt-get update && apt-get -y install cargo

export RETICULATE_PYTHON=/usr/bin/python3


install2.r --error --skipmissing -n "$NCPUS" -r "${CRAN_SOURCE}" \
       adbcdrivermanager \
       affinity \
       AzureStor \
       biglm \
       colourvalues \
       crew \
       crew.cluster \
       dotenv \
       duckdbfs \
       exactextractr \
       fasterize \
       fields \
       furrr \
       future.batchtools \
       gdalcubes \
       geodata \
       geometries \
       geos \
       geosphere \
       graticule \
       gibble \
       httptest2 \
       jpeg \
       knitr \
       lwgeom \
       mapscanner \
       mapview \
       mirai \
       mmand \
       multidplyr \
       osmdata \
       polyclip \
       quadmesh \
       rbgm \
       rgl \
       reticulate \
       rjags \
       rsi \
       rslurm \
       rstac \
       RTriangle \
       sf \
       sfheaders \
       silicate \
       sits \
       spex \
       stars \
       tarchetypes \
       targets \
       terra \
       terrainmeshr \
       tidync \
       trip \
       tripEstimation \
       urlchecker \
       wk



Rscript -e 'devtools::install_github(c("hypertidy/whatarelief", "hypertidy/vapour","hypertidy/grout", "hypertidy/PROJ", "hypertidy/ximage", "hypertidy/sds", "hypertidy/dsn", "hypertidy/controlledburn"), Ncpus = 4)'

Rscript -e 'devtools::install_github(c("AustralianAntarcticDivision/palr", "AustralianAntarcticDivision/raadfiles", "AustralianAntarcticDivision/raadtools", "AustralianAntarcticDivision/blueant", "AustralianAntarcticDivision/Grym", "ropensci/bowerbird"), Ncpus = 4)'

Rscript -e 'devtools::install_github("eliocamp/rcmip6")'

#Rscript -e 'devtools::install_github("hypertidy/anglr")'

Rscript -e 'devtools::install_github("geoarrow/geoarrow-r")'

Rscript -e 'devtools::install_github(c("USDAForestService/gdalraster", "paleolimbot/geoarrow", "r-lib/revdepcheck"))'

## use the SCAR r-universe package repository
Rscript -e 'op <- options(repos = c(SCAR = "https://scar.r-universe.dev", CRAN = "https://cloud.r-project.org")); install.packages("bowerbird", Ncpus = 4); options(op)'


# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages
rm -rf /*.deb /build_thirdparty /build_local

apt-get autoclean
apt-get autoremove
##rm -rf /var/lib/{apt,dpkg,cache,log}


unset MAKEFLAGS

