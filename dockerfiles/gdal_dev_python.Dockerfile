FROM ghcr.io/mdsumner/gdal-builds:gdal_dev

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN  apt-get update && apt-get  install python3-pip -y
#RUN python3 -m pip install --upgrade setuptools
#RUN python3 -m pip install   setuptools-scm

RUN python3 -m pip install matplotlib   cftime  scipy zarr fsspec
RUN python3 -m pip install netCDF4 --no-binary netCDF4 --force-reinstall
RUN python3 -m pip install netCDF4 --no-binary h5netcdf --force-reinstall

RUN wget  https://raw.githubusercontent.com/rasterio/rasterio/main/requirements-dev.txt
RUN wget  https://raw.githubusercontent.com/rasterio/rasterio/main/requirements.txt

RUN python3 -m pip install -r requirements-dev.txt

RUN python3 -m pip install rasterio --no-binary rasterio --force-reinstall


## get dev-requirements for rasterio and install deps from there first
#   && python3 -m pip install  xarray odc-geo pyproj rasterio rioxarray --no-binary ":all:" \
#   && python3 -m pip install  stackstac --no-binary ":all:"

