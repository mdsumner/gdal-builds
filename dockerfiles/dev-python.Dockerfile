FROM pangeo/pangeo-notebook:latest

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of pangeo with icechunk and virtualizarr for use on HPC" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"


RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC

RUN export MAKEFLAGS="-j$(nproc)"

#RUN   apt-get update \
#      &&  apt-get -y install software-properties-common

RUN     apt-get update && apt-get install -y --no-install-recommends python3-pip
RUN cd / && python -m venv /workenv \
   && . /workenv/bin/activate \
    && python -m pip install uv \
    && uv pip install --upgrade pip \
    && uv pip install icechunk virtualizarr

RUN unset MAKEFLAGS
