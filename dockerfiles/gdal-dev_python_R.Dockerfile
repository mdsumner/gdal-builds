FROM  ghcr.io/mdsumner/gdal-builds:gdal-dev_python

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/mdsumner/gdal-builds" \
      org.opencontainers.image.vendor="Hypertidy Project" \
      org.opencontainers.image.description="A build of GDAL and R latest for use on ubuntu" \
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

RUN export RETICULATE_PYTHON=/usr/bin/python3


RUN rm -rf gdal/

COPY dotfiles/.Rprofile /root/.Rprofile

RUN  curl -L https://rig.r-pkg.org/deb/rig.gpg -o /etc/apt/trusted.gpg.d/rig.gpg \
     && sh -c 'echo "deb http://rig.r-pkg.org/deb rig main" > /etc/apt/sources.list.d/rig.list' \
     && apt update \
     && apt install r-rig \
     && rig add release \
     && Rscript -e "pak::pak(c('devtools', 'reticulate'))" \
     && Rscript -e "xs <- c('rspatial/terra', 'paleolimbot/wk', 'paleolimbot/geos', 'hypertidy/PROJ', 'hypertidy/vapour', 'hypertidy/ximage', 'hypertidy/sds', 'hypertidy/dsn', 'hypertidy/whatarelief', 'hypertidy/vaster', 'hypertidy/grout', 'hypertidy/reproj', 'hypertidy/quad'); devtools::install_github(xs)"
