FROM ghcr.io/mdsumner/gdal-builds:rocker-gdal-dev

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and rocker with all python goodies for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"


RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC


RUN echo "export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3/dist-packages" >> ~/.profile

# libgeos-dev geos-bin
RUN  apt-get update && apt-get  install python3-pip  -y && pip3 install --upgrade pip \
      &&  python3 -m pip install matplotlib   cftime  scipy zarr fsspec \
      &&  python3 -m pip install h5netcdf netCDF4  \
      && python3 -m pip install shapely --no-binary shapely \
      &&  wget  https://raw.githubusercontent.com/rasterio/rasterio/main/requirements.txt \
      &&  python3 -m pip install -r requirements.txt \
      && rm requirements.txt \
      &&  python3 -m pip install rasterio --no-binary rasterio --force-reinstall \
      &&  python3 -m pip install pyogrio --no-binary pyogrio --force-reinstall \
      &&  python3 -m pip install fiona --no-binary fiona \
      &&  python3 -m pip install  pytz tzdata pandas xarray \
      && python3 -m pip install geopandas --no-binary geopandas \
      &&  python3 -m pip install odc-geo  --no-binary ":all:" \
      &&  python3 -m pip install rioxarray  --no-binary ":all:" \
      && python3 -m pip install cloudpickle partd pyaml dask zipp importlib toolz \
      &&  python3 -m pip install stackstac  \
      && python3 -m pip install pystac-client

