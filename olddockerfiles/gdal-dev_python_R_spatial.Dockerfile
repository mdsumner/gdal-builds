FROM  ghcr.io/mdsumner/gdal-builds:gdal-dev_python_R

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN export RETICULATE_PYTHON=/usr/bin/python3

RUN apt-get install -y libudunits2-dev

COPY dotfiles/.Rprofile /root/.Rprofile

