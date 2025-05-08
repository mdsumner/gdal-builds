FROM ghcr.io/osgeo/gdal:ubuntu-full-latest

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build with R on the GDAL full image" \
      org.opencontainers.image.authors="Chris Toney, Michael Sumner <mdsumner@gmail.com>"

RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC

COPY scripts/install_gdal-dev.sh /rocker_scripts/install-r-gdal-full.sh

RUN /rocker_scripts/install-r-gdal-full.sh


