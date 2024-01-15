#!/bin/bash
set -e


# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

# a function to remove apt packages only if they are installed
function apt_remove() {
    if dpkg -s "$@" >/dev/null 2>&1; then
        apt-get remove -y "$@"
    fi
}

apt_remove proj-bin gdal-bin libgdal-dev libgeos-dev libproj-dev \
    && apt-get autoremove -y
