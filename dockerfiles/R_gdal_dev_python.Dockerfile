FROM  ghcr.io/mdsumner/gdal-builds:gdal_dev_python

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN export RETICULATE_PYTHON=/usr/bin/python3


RUN  curl -L https://rig.r-pkg.org/deb/rig.gpg -o /etc/apt/trusted.gpg.d/rig.gpg

RUN  sh -c 'echo "deb http://rig.r-pkg.org/deb rig main" > /etc/apt/sources.list.d/rig.list'

RUN  apt update
RUN  apt install r-rig

RUN rig add release

RUN Rscript -e "pak::pak(c('devtools', 'reticulate'))"

RUN Rscript -e "xs <- c('rspatial/terra', 'paleolimbot/wk', 'paleolimbot/geos', 'hypertidy/PROJ', 'hypertidy/vapour'); devtools::install_github(xs)"

