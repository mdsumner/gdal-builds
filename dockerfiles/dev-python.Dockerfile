FROM rocker/verse

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of ubuntu with R mirai async for icechunk and virtualizarr for use on HPC" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"


RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC

RUN   apt-get update && apt-get-upgrade \
      &&  apt-get install -y software-properties-common

RUN apt-get install -y -V ca-certificates lsb-release wget
RUN wget https://packages.apache.org/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt-get  install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt-get update && apt-get install -y -V libarrow-dev libparquet-dev libarrow-dataset-dev

RUN Rscript -e "install.packages(c('mirai', 'carrier', 'purrr', 'dplyr', 'arrow'))

RUN     apt-get install -y --no-install-recommends \
            python3-dev \
            python3-venv \
            python3-pip \
            python3-full

RUN cd / && python3 -m venv /workenv \
   && . /workenv/bin/activate \
    && python -m pip install uv \
    && uv pip install icechunk virtualizarr dask h5py

