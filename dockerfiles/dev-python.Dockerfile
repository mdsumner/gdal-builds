FROM ubuntu:latest

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of ubuntu with icechunk and virtualizarr for use on HPC" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"


RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC

RUN   apt-get update \
      &&  apt-get -y install software-properties-common

RUN     apt-get install -y --no-install-recommends \
            python3-dev \
            python3-venv \
            python3-pip \
            python3-full

RUN cd / && python3 -m venv /workenv \
   && . /workenv/bin/activate \
    && python -m pip install uv \
    && uv pip install icechunk virtualizarr dask h5py

