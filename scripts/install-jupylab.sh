#!/bin/bash
set -e

apt-get update

# system requirement for package xml2 which is a gdalraster dependency
#apt-get -y install --no-install-recommends libxml2-dev
# libcurl is needed for some gdalraster suggested packages or their dependencies
#apt-get -y install --no-install-recommends libcurl4-openssl-dev

rm -rf /var/lib/apt/lists/*

echo "export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.12/dist-packages" >> ~/.profile


RUN export MAKEFLAGS="-j$(nproc)"

  apt-get update \
      &&  apt-get -y install software-properties-common \
      &&  add-apt-repository -y ppa:deadsnakes/ppa

apt-get update && apt-get install -y --no-install-recommends \
            python3.12 \
            python3.12-dev \
            python3.12-venv \
            python3-pip \
            g++

 python3.12 -m venv workenv \
    && . workenv/bin/activate \
    && python -m pip install uv \
      && uv pip install jupyter-rsession-proxy notebook jupyterlab jupyterhub

cd
git clone https://github.com/osgeo/gdal.git
cd gdal
python3 -m pip install -r ../doc/requirements.txt
python3 -m pip install -r ../autotest/requirements.txt
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr  -DCMAKE_UNITY_BUILD=ON  -DCMAKE_BUILD_TYPE=Release
cmake --build . --parallel 4 --target install
ldconfig
cd


ENV PATH="/workenv/bin:$PATH"

RUN unset MAKEFLAGS
