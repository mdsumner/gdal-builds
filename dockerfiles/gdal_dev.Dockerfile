FROM ghcr.io/osgeo/gdal-deps:ubuntu22.04-master

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

## zap the old copy (find out why in https://github.com/mdsumner/gdal-builds/issues/1)
RUN find /usr -mtime +15 -name "libgdal*" -exec  rm -f {} +

RUN apt-get update && apt-get -y upgrade

ENV PROJ_VERSION=9.3.1

COPY scripts/install_cmake_version_proj.sh /scripts/install_cmake_version_proj.sh

RUN /scripts/install_cmake_version_proj.sh


RUN git clone https://github.com/osgeo/gdal.git \
    && cd gdal \
    && mkdir build \
    && cd build \
    &&  cmake .. -DCMAKE_INSTALL_PREFIX=/usr  -DCMAKE_UNITY_BUILD=ON  -DCMAKE_BUILD_TYPE=Debug -DENABLE_TESTS=NO \
    && make -j$(nproc) \
    && make install \
    && cd ../.. \
    && ldconfig \
    && find ./gdal/build/ -name "*.o" -exec rm -rf {} \; \
    && find ./gdal/build/ -name "*.so" -exec rm -rf {} \; \
    && find ./gdal/build/ -name "*libgdal.so*" -exec rm -rf {} \;

