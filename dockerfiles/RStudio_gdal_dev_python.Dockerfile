FROM  ghcr.io/mdsumner/gdal-builds:R_gdal_dev_python

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"


RUN apt-get install gdebi-core -y \
     && wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.12.0-369-amd64.deb \
     && gdebi rstudio-server-2023.12.0-369-amd64.deb

