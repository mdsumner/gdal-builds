#!/bin/bash
set -e

. /etc/os-release printf '%s\n' "$VERSION_CODENAME"

## this from -----------------------------------------------------------------------------
## https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_R_ppa.sh
CRAN_LINUX_VERSION=${CRAN_LINUX_VERSION:-cran40}
LANG=${LANG:-en_US.UTF-8}
LC_ALL=${LC_ALL:-en_US.UTF-8}
DEBIAN_FRONTEND=noninteractive

# Set up and install R
R_HOME=${R_HOME:-/usr/lib/R}
R_VERSION=${R_VERSION}

apt-get update

apt-get -y install --no-install-recommends \
      ca-certificates \
      less \
      locales \
      vim-tiny \
      wget \
      dirmngr \
      gpg \
      gpg-agent \
      git \
      libopenblas-dev \
      liblapack-dev

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen en_US.utf8
/usr/sbin/update-locale LANG=${LANG}

echo "deb http://cloud.r-project.org/bin/linux/ubuntu ${VERSION_CODENAME}-${CRAN_LINUX_VERSION}/" >> /etc/apt/sources.list

## needs review:
###  http://cloud.r-project.org/bin/linux/ubuntu/noble-cran40/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg),
### see the DEPRECATION section in apt-key(8) for details.
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add -


# Wildcard * at end of version will grab (latest) patch of requested version
apt-get update && apt-get -y install  r-base-dev=${R_VERSION}*



