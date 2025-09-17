FROM ghcr.io/mdsumner/gdal-builds:rocker-gdal-dev-r

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and rocker with all python goodies for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"


RUN export DEBIAN_FRONTEND=noninteractive
RUN export TZ=Etc/UTC

RUN echo "export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.12/dist-packages" >> ~/.profile

## this is the full rasterio requirements (2024-01-25) sans shapely, numpy, matplotlib, fsspec, cython

#affine~=2.3.0 attrs>=19.2.0 boto3>=1.3.1 click~=8.0 click-plugins cligj>=0.5  snuggs~=1.4.0 setuptools>=20.0 pyparsing~=3.1  delocate  hypothesis mypy numpydoc packaging pytest pytest-cov>=2.2.0 pytest-randomly==3.10.1  sphinx sphinx-click sphinx-rtd-theme wheel

# ;)
RUN export MAKEFLAGS="-j$(nproc)"

RUN   apt-get update \
      &&  apt-get -y install software-properties-common \
      &&  add-apt-repository -y ppa:deadsnakes/ppa

RUN     apt-get update && apt-get install -y --no-install-recommends \
            python3.12 \
            python3.12-dev \
            python3.12-venv \
            python3-pip \
            g++


## uv installs, except when need
## no-binary (and others) else triggers downgrade of numpy to 1.26.4
RUN cd / && python3.12 -m venv /workenv \
   && . /workenv/bin/activate \
    && python -m pip install uv \
    && uv pip install --upgrade pip \
    && uv pip install "numpy>2" pytest-cov pytest-randomly affine attrs boto3 click cligj snuggs setuptools pyparsing  \
    && uv pip install matplotlib  cftime  scipy zarr aiohttp requests fsspec h5netcdf netCDF4  click-plugins \
      && uv pip install setuptools wheel cython \
      && uv pip install delocate  hypothesis mypy numpydoc packaging pytest pytest-cov pytest-randomly  sphinx sphinx-click sphinx-rtd-theme  \
      &&  uv pip install rasterio --no-binary rasterio \
      && uv pip install fiona --no-binary fiona \
      && uv pip install pyogrio --no-binary pyogrio \
      && uv pip install shapely --no-binary shapely \
      && uv pip install pyproj --no-binary pyproj \
      && uv pip install geopandas --no-binary geopandas \
      &&  uv pip install  pytz tzdata pandas xarray \
      &&  uv pip install odc-geo  --no-binary odc-geo \
      &&  uv  pip install rioxarray  --no-binary rioxarray \
      && uv pip install cloudpickle dill partd pyaml dask zipp importlib toolz \
      &&  uv pip install stackstac rio-stac  \
      && uv pip install pystac-client cartopy pooch earthaccess \
      && uv pip install geoarrow-pyarrow geoarrow-pandas rpy2 rpy2-arrow kerchunk coiled \
      && uv pip install s3fs planetary.computer dask-expr xstac xpystac tifffile  pygmt rechunker \
      && uv pip install arraylake[icechunk]  icechunk polars obstore \
      && uv pip install fastparquet  --no-binary fastparquet \
      && uv pip install  stac-geoparquet pyarrow  lonboard  ipytree deltalake  access-nri-intake \
      && uv pip install stacrs odc-stac h5pyd async-tiff imagecodecs virtualizarr \
      && uv pip install jupyter-rsession-proxy notebook jupyterlab jupyterhub ibis-framework[duckdb,examples]

#&& uv pip install git+https://github.com/zarr-developers/VirtualiZarr@main \




ENV PATH="/workenv/bin:$PATH"

RUN unset MAKEFLAGS
