FROM rocker/verse

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and rocker for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC

COPY scripts/install_gdal-dev.sh /rocker_scripts/install_gdal-dev.sh

RUN /rocker_scripts/install_gdal-dev.sh


