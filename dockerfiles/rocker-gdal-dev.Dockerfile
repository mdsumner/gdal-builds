FROM rocker/verse:4.3.2

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and rocker for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"


RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC


#ENV PROJ_VERSION=9.3.1
#ENV GDAL_VERSION=3.8.3
#ENV GEOS_VERSION=3.12.1

COPY scripts/install_tidyverse.sh /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_tidyverse.sh


COPY scripts/install_gdal-dev.sh /rocker_scripts/install_gdal-dev.sh

RUN /rocker_scripts/install_gdal-dev.sh


