FROM ghcr.io/mdsumner/gdal-builds:rocker-gdal-dev

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and rocker with all python goodies for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"


RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC

#RUN echo "export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3/dist-packages" >> ~/.profile

## this is the full rasterio requirements (2024-01-25) sans shapely, numpy, matplotlib, fsspec, cython

#affine~=2.3.0 attrs>=19.2.0 boto3>=1.3.1 click~=8.0 click-plugins cligj>=0.5  snuggs~=1.4.0 setuptools>=20.0 pyparsing~=3.1  delocate  hypothesis mypy numpydoc packaging pytest pytest-cov>=2.2.0 pytest-randomly==3.10.1  sphinx sphinx-click sphinx-rtd-theme wheel

# ;)
RUN export MAKEFLAGS="-j$(nproc)"

RUN   apt-get update \
      &&  apt-get -y install software-properties-common \
      &&  add-apt-repository -y ppa:deadsnakes/ppa

RUN     apt-get update && apt-get install -y --no-install-recommends \
            python3.11 \
            python3.11-dev \
            python3.11-venv \
            python3-pip \
            g++


RUN python3.11 -m venv workenv \
    && . workenv/bin/activate \
    && python3.11 -m pip install --upgrade pip \
    && python3.11 -m pip install pytest-cov pytest-randomly affine attrs boto3 click cligj snuggs setuptools pyparsing \
    && python3.11 -m pip install matplotlib  cftime  scipy zarr aiohttp requests fsspec h5netcdf netCDF4  click-plugins \
      && python3.11 -m pip install setuptools wheel cython \
      && python3.11 -m pip install delocate  hypothesis mypy numpydoc packaging pytest pytest-cov pytest-randomly  sphinx sphinx-click sphinx-rtd-theme  \
      &&  python3.11 -m pip install rasterio fiona pyogrio pyproj geopandas  --no-binary rasterio,fiona,pyogrio,shapely,pyproj,geopandas \
      &&  python3.11 -m pip install  pytz tzdata pandas xarray \
      &&  python3.11 -m pip install odc-geo  --no-binary odc-geo \
      &&  python3.11 -m pip install rioxarray  --no-binary rioxarray \
      && python3.11 -m pip install cloudpickle partd pyaml dask zipp importlib toolz \
      &&  python3.11 -m pip install stackstac  \
      && python3.11 -m pip install pystac-client cartopy pooch \
      && python3.11 -m pip install geoarrow-pyarrow geoarrow-pandas rpy2 rpy2-arrow kerchunk \
      && python3.11 -m pip install s3fs planetary.computer dask-expr jupyter xstac xpystac tifffile VirtualiZarr pygmt rechunker \
      && python3.11 -m pip install stac-geoparquet pyarrow deltalake arraylake lonboard  access-nri-intake


RUN unset MAKEFLAGS
