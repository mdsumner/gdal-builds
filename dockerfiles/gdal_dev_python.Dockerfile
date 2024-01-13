FROM ghcr.io/mdsumner/gdal-builds:gdal_dev

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN rm -rf gdal/

## shapely:  I *think* rioxarray installs its own GEOS below, so we do this
## pyproj: allow to install its own PROJ (GDAL container is 8.2.1 but pyproj>3.4.1 requires 9.0.0)
## stackstac:  pulls in dask and  zipp, toolz, pyyaml, locket, cloudpickle, partd, importlib-metadata

RUN  apt-get update && apt-get  install python3-pip -y  \
      &&  python3 -m pip install matplotlib   cftime  scipy zarr fsspec \
      &&  python3 -m pip install netCDF4 --no-binary netCDF4 --force-reinstall \
      &&  python3 -m pip install h5netcdf --no-binary h5netcdf --force-reinstall \
      &&  wget  https://raw.githubusercontent.com/rasterio/rasterio/main/requirements-dev.txt \
      &&  wget  https://raw.githubusercontent.com/rasterio/rasterio/main/requirements.txt \
      &&  python3 -m pip install -r requirements-dev.txt \
      &&  python3 -m pip install rasterio --no-binary rasterio --force-reinstall \
      &&  python3 -m pip install shapely --no-binary shapely --force-reinstall \
      &&  python3 -m pip install pyproj \
      &&  python3 -m pip install  pytz tzdata pandas xarray \
      &&  python3 -m pip install odc-geo  rioxarray  --no-binary ":all:" \
      &&  python3 -m pip install stackstac
