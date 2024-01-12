FROM docker pull ghcr.io/mdsumner/gdal-builds:gdal_trunk

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN  curl -L https://rig.r-pkg.org/deb/rig.gpg -o /etc/apt/trusted.gpg.d/rig.gpg

RUN  sh -c 'echo "deb http://rig.r-pkg.org/deb rig main" > /etc/apt/sources.list.d/rig.list'

RUN  apt update
RUN  apt install r-rig


RUN rig add release

RUN Rscript -e "pak::pak('devtools')"

RUN Rscript -e "devtools::install_github(c('rspatial/terra', 'paleolimbot/wk', 'hypertidy/PROJ', 'hypertidy/vapour'))"
