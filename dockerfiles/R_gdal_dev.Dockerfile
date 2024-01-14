FROM  ghcr.io/mdsumner/gdal-builds:gdal_dev

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN rm -rf gdal/

COPY dotfiles/.Rprofile /root/.Rprofile

RUN apt update -qq \
  && apt-get install -y --no-install-recommends software-properties-common dirmngr \
  &&    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
 && add-apt-repository  -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
 &&  apt-get install -y --no-install-recommends r-base

 RUN Rscript -e "install.packages('pak'); pak::pak(c('devtools', 'reticulate', 'remotes'))" \
 && Rscript -e "xs <- c('rspatial/terra', 'paleolimbot/wk', 'paleolimbot/geos', 'hypertidy/PROJ', 'hypertidy/vapour', 'hypertidy/ximage', 'hypertidy/sds', 'hypertidy/dsn', 'hypertidy/whatarelief', 'hypertidy/vaster', 'hypertidy/grout', 'hypertidy/reproj', 'hypertidy/quad'); devtools::install_github(xs)"


