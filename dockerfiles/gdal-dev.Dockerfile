FROM ghcr.io/osgeo/gdal-deps:ubuntu22.04-master

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"



# a function to remove apt packages only if they are installed

COPY scripts/apt_helpers.sh /scripts/apt_helpers.sh
RUN source /scripts/apt_helpers.sh
RUN apt_remove proj-bin gdal-bin libgdal-dev libgeos-dev libproj-dev \
    && apt-get autoremove -y


## will need to do this all properly
## zap the old copy (find out why in https://github.com/mdsumner/gdal-builds/issues/1)
RUN find /usr -mtime +15 -name "libgdal*" -exec  rm -f {} +
#RUN find /usr -mtime +15 -name "libgeos*" -exec  rm -f {} +  ## leave geos, we add PROJ and GDAL
RUN find /usr -mtime +15 -name "libproj*" -exec  rm -f {} +

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
    && ldconfig #\
   # &&          find ./gdal/build/ -name "*.o" -exec rm -rf {} \; \
   # &&         find ./gdal/build/ -name "*.so" -exec rm -rf {} \; \
   # && find ./gdal/build/ -name "*libgdal.so*" -exec rm -rf {} \;

