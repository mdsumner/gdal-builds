FROM ghcr.io/osgeo/gdal-deps:ubuntu24.04-master

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="GDAL deps + jupyter" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC

COPY scripts/install-jupylab.sh /rocker_scripts/install-jupylab.sh

RUN /rocker_scripts/install-jupylab.sh


