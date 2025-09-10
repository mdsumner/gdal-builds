FROM pangeo/pangeo-notebook:latest

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of pangeo with icechunk and virtualizarr for use on HPC" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"


RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC



RUN     apt-get update \
    && python -m pip install uv \
    && uv pip install --upgrade pip \
    && uv pip install icechunk virtualizarr

