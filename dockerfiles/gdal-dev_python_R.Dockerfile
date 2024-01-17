FROM  ghcr.io/mdsumner/gdal-builds:gdal-dev_python

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN export RETICULATE_PYTHON=/usr/bin/python3
RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

COPY dotfiles/.Rprofile /root/.Rprofile

RUN apt update -qq \
     && apt-get install -y --no-install-recommends software-properties-common dirmngr \
     &&    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
     && add-apt-repository  -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
     &&  apt-get install -y --no-install-recommends r-base libcurl4-openssl-dev \
     && Rscript -e "install.packages('pak'); pak::pak(c('devtools', 'reticulate', 'remotes'))" \
     && apt-get install -y  libudunits2-dev \
     && Rscript -e "pak::pak(c('devtools', 'reticulate', 'units', 's2'))" \
     && Rscript -e "xs <- c('terra', 'wk', 'geos', 'hypertidy/PROJ', 'hypertidy/vapour', 'hypertidy/ximage', 'hypertidy/sds', 'hypertidy/dsn', 'hypertidy/whatarelief', 'hypertidy/vaster', 'hypertidy/grout', 'hypertidy/reproj', 'hypertidy/quad',  'geodata', 'geosphere'); devtools::install_github(xs)"


