FROM ghcr.io/mdsumner/gdal-builds:gdal_dev

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN apt update \
   && apt install python3-pip
   #&& python3 -m pip install matplotlib  netCDF4 cftime h5netcdf scipy zarr fsspec    \
   #&& python3 -m pip install stackstac xarray odc-geo pyproj rasterio rioxarray --no-binary ":all:"
