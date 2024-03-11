
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gdal-builds

<!-- badges: start -->
<!-- badges: end -->

The goal of gdal-builds is to create a single image with all geospatial
libs up to date and with R and Python packages using them in alignment.

The builds are here:

<https://github.com/mdsumner/gdal-builds/pkgs/container/gdal-builds>

We also push to docker hub for Singularity but that’s not named sensibly
yet so I’m not including it here.

This builds:

- `rocker-gdal-dev`, this starts with
  [rocker/verse](https://rocker-project.org/images/) and adds GDAL from
  latest commit, and latest release PROJ and GEOS, with a number of R
  packages that all use these versions
- `rocker-gdal-dev-python`, this adds a large number of python packages
  also aligned to the GDAL, PROJ, and GEOS versions.

You can do this to get into an interactive session, you’ll see bleeding
edge GDAL and very recent PROJ and geos installs.

    docker run --rm -ti ghcr.io/mdsumner/gdal-builds:rocker-gdal-dev-python  bash

RStudio server is included which is why we start with bash explicitly
rather than spin up the server.

In there you can start R, and you can immediately do

``` r
library(reticulate)
gdal <- import("osgeo.gdal")
rioxarray <- import("rioxarray")
geopandas <- import("geopandas")
```

and see that `show_versions()` of them all are in alignment (hurrah!).

IF you want `/vsicurl` to work then you must run with this, for example:

    docker run --rm -ti --security-opt seccomp=unconfined ghcr.io/mdsumner/gdal-builds:rocker-gdal-dev 

## NOTES

I have an odd mix of pip installs that reflects me getting them to not
install static binaries (I haven’t succeed in aligning versions of HDF
and NetCDF yet).

All very much WIP, I started by removing the rstudio and tidyverse
stuff, but I’ve gone back to “verse” as the starting point because I can
now host the image as an rstudio or jupyter server from HPC (story to be
told in future).

We might unpick to multiple builds again, to reduce the size and to
separate R and Python but this is all together is what I want for now.

Note it’s a very large image, like 6-7Gb and that’s bigger than it could
be.

See the versions of libs GEOS, PROJ, GDAL - these reports are as at
2024-01-22.

``` r
terra::gdal()
terra::gdal(lib = "PROJ")
terra::gdal(lib = "GEOS")

library(reticulate)
import("geopandas")$show_versions()


import("rioxarray")$show_versions()
import("shapely")$geos_version_string
```

    [1] "3.9.0dev-0b6e5ab467"
    [1] "9.4.0"
    [1] "3.12.1"

    SYSTEM INFO
    -----------
    python     : 3.10.12 (main, Nov 20 2023, 15:14:05) [GCC 11.4.0]
    executable : /usr/bin/python3
    machine    : Linux-5.15.0-94-generic-x86_64-with-glibc2.35

    GEOS, GDAL, PROJ INFO
    ---------------------
    GEOS       : 3.12.1
    GEOS lib   : None
    GDAL       : 3.9.0dev-0b6e5ab467
    GDAL data dir: None
    PROJ       : 9.4.0
    PROJ data dir: /usr/local/share/proj

    PYTHON DEPENDENCIES
    -------------------
    geopandas  : 0.14.3
    numpy      : 1.26.4
    pandas     : 2.2.1
    pyproj     : 3.6.1
    shapely    : 2.0.3
    fiona      : 1.9.6
    geoalchemy2: None
    geopy      : None
    matplotlib : 3.8.3
    mapclassify: None
    pygeos     : None
    pyogrio    : 0.7.2
    psycopg2   : None
    pyarrow    : 15.0.1
    rtree      : None
    rioxarray (0.15.1) deps:
      rasterio: 1.3.9
        xarray: 2024.2.0
          GDAL: 3.9.0dev-0b6e5ab467
          GEOS: 3.12.1
          PROJ: 9.4.0
     PROJ DATA: /root/.local/share/proj:/usr/local/share/proj:/usr/local/share/proj
     GDAL DATA: /usr/local/lib/R/site-library/terra//gdal

    Other python deps:
         scipy: 1.12.0
        pyproj: 3.6.1

    System:
        python: 3.10.12 (main, Nov 20 2023, 15:14:05) [GCC 11.4.0]
    executable: /usr/bin/python3
       machine: Linux-5.15.0-94-generic-x86_64-with-glibc2.35
    [1] "3.12.1"

Available Python packages as at 2024-03-11:

``` r
system("python3 -m pip list")


Package                       Version
----------------------------- -------------
affine                        2.3.1
alabaster                     0.7.16
asciitree                     0.3.3
attrs                         23.2.0
Babel                         2.14.0
boto3                         1.34.59
botocore                      1.34.59
cachetools                    5.3.3
Cartopy                       0.22.0
certifi                       2024.2.2
cffi                          1.16.0
cftime                        1.6.3
charset-normalizer            3.3.2
click                         8.1.7
click-plugins                 1.1.1
cligj                         0.7.2
cloudpickle                   3.0.0
contourpy                     1.2.0
coverage                      7.4.3
cycler                        0.12.1
Cython                        3.0.9
dask                          2024.2.1
delocate                      0.10.7
devscripts                    2.22.1ubuntu1
docutils                      0.20.1
exceptiongroup                1.2.0
fasteners                     0.19
fiona                         1.9.6
fonttools                     4.49.0
fsspec                        2024.2.0
geoarrow-c                    0.1.2
geoarrow-pandas               0.1.1
geoarrow-pyarrow              0.1.2
geopandas                     0.14.3
h5netcdf                      1.3.0
h5py                          3.10.0
hypothesis                    6.99.2
idna                          3.6
imagesize                     1.4.1
importlib                     1.0.4
importlib_metadata            7.0.2
iniconfig                     2.0.0
Jinja2                        3.1.3
jmespath                      1.0.1
jsonschema                    4.21.1
jsonschema-specifications     2023.12.1
kiwisolver                    1.4.5
locket                        1.0.0
MarkupSafe                    2.1.5
matplotlib                    3.8.3
mypy                          1.9.0
mypy-extensions               1.0.0
netCDF4                       1.6.5
numcodecs                     0.12.1
numpy                         1.26.4
numpydoc                      1.6.0
odc-geo                       0.4.3
packaging                     24.0
pandas                        2.2.1
partd                         1.4.1
pillow                        10.2.0
pip                           24.0
platformdirs                  4.2.0
pluggy                        1.4.0
pooch                         1.8.1
pyaml                         23.12.0
pyarrow                       15.0.1
pyarrow-hotfix                0.6
pycparser                     2.21
Pygments                      2.17.2
pyogrio                       0.7.2
pyparsing                     3.1.2
pyproj                        3.6.1
pyshp                         2.3.1
pystac                        1.9.0
pystac-client                 0.7.6
pytest                        8.1.1
pytest-cov                    4.1.0
pytest-randomly               3.10.1
python-dateutil               2.9.0.post0
pytz                          2024.1
PyYAML                        6.0.1
rasterio                      1.3.9
referencing                   0.33.0
requests                      2.31.0
rioxarray                     0.15.1
rpds-py                       0.18.0
rpy2                          3.5.15
rpy2-arrow                    0.1.1
s3transfer                    0.10.0
scipy                         1.12.0
setuptools                    59.6.0
shapely                       2.0.3
six                           1.16.0
snowballstemmer               2.2.0
snuggs                        1.4.7
sortedcontainers              2.4.0
Sphinx                        7.2.6
sphinx-click                  5.1.0
sphinx-rtd-theme              2.0.0
sphinxcontrib-applehelp       1.0.8
sphinxcontrib-devhelp         1.0.6
sphinxcontrib-htmlhelp        2.0.5
sphinxcontrib-jquery          4.1
sphinxcontrib-jsmath          1.0.1
sphinxcontrib-qthelp          1.0.7
sphinxcontrib-serializinghtml 1.1.10
stackstac                     0.5.0
tabulate                      0.9.0
tomli                         2.0.1
toolz                         0.12.1
typing_extensions             4.10.0
tzdata                        2024.1
tzlocal                       5.2
urllib3                       2.0.7
wheel                         0.37.1
xarray                        2024.2.0
zarr                          2.17.1
zipp                          3.17.0
```

Available R packages:

``` r
sessioninfo::package_info("installed")


 package           * version    date (UTC) lib source
 abind               1.4-5      2016-07-21 [1] CRAN (R 4.3.2)
 archive             1.1.7      2023-12-11 [1] RSPM (R 4.3.0)
 arrow               14.0.2.1   2024-02-23 [1] RSPM (R 4.3.0)
 askpass             1.2.0      2023-09-03 [1] RSPM (R 4.3.0)
 assertthat          0.2.1      2019-03-21 [1] RSPM (R 4.3.0)
 aws.s3              0.3.21     2020-04-07 [1] RSPM (R 4.3.0)
 aws.signature       0.6.0      2020-06-01 [1] RSPM (R 4.3.0)
 backports           1.4.1      2021-12-13 [1] RSPM (R 4.3.0)
 base64enc           0.1-3      2015-07-28 [1] RSPM (R 4.3.0)
 base64url           1.4        2018-05-14 [1] CRAN (R 4.3.2)
 batchtools          0.9.17     2023-04-20 [1] CRAN (R 4.3.2)
 BH                  1.84.0-0   2024-01-10 [1] CRAN (R 4.3.2)
 BiocManager         1.30.22    2023-08-08 [1] RSPM (R 4.3.0)
 bit                 4.0.5      2022-11-15 [1] RSPM (R 4.3.0)
 bit64               4.0.5      2020-08-30 [1] RSPM (R 4.3.0)
 blob                1.2.4      2023-03-17 [1] RSPM (R 4.3.0)
 blogdown            1.19       2024-02-01 [1] RSPM (R 4.3.0)
 blueant             0.12.0     2024-03-11 [1] Github (AustralianAntarcticDivision/blueant@3f6561b)
 bookdown            0.37       2023-12-01 [1] RSPM (R 4.3.0)
 boot                1.3-28.1   2022-11-22 [2] CRAN (R 4.3.2)
 bowerbird           0.15.0     2024-03-11 [1] https://scar.r-universe.dev (R 4.3.2)
 brew                1.0-10     2023-12-16 [1] RSPM (R 4.3.0)
 brio                1.1.4      2023-12-10 [1] RSPM (R 4.3.0)
 broom               1.0.5      2023-06-09 [1] RSPM (R 4.3.0)
 bslib               0.6.1      2023-11-28 [1] RSPM (R 4.3.0)
 cachem              1.0.8      2023-05-01 [1] RSPM (R 4.3.0)
 callr               3.7.5      2024-02-19 [1] RSPM (R 4.3.0)
 cellranger          1.1.0      2016-07-27 [1] RSPM (R 4.3.0)
 checkmate           2.3.1      2023-12-04 [1] CRAN (R 4.3.2)
 class               7.3-22     2023-05-03 [2] CRAN (R 4.3.2)
 classInt            0.4-10     2023-09-05 [1] CRAN (R 4.3.2)
 cli                 3.6.2      2023-12-11 [1] RSPM (R 4.3.0)
 clipr               0.8.0      2022-02-22 [1] RSPM (R 4.3.0)
 cluster             2.1.4      2022-08-22 [2] CRAN (R 4.3.2)
 codetools           0.2-19     2023-02-01 [2] CRAN (R 4.3.2)
 colorspace          2.1-0      2023-01-23 [1] RSPM (R 4.3.0)
 commonmark          1.9.1      2024-01-30 [1] RSPM (R 4.3.0)
 conflicted          1.2.0      2023-02-01 [1] RSPM (R 4.3.0)
 CopernicusMarine    0.2.3      2024-01-25 [1] RSPM (R 4.3.0)
 countrycode         1.5.0      2023-05-30 [1] RSPM (R 4.3.0)
 covr                3.6.4      2023-11-09 [1] RSPM (R 4.3.0)
 cpp11               0.4.7      2023-12-02 [1] RSPM (R 4.3.0)
 crayon              1.5.2      2022-09-29 [1] RSPM (R 4.3.0)
 credentials         2.0.1      2023-09-06 [1] RSPM (R 4.3.0)
 crew                0.9.0      2024-02-08 [1] CRAN (R 4.3.2)
 crew.cluster        0.3.0      2024-02-08 [1] CRAN (R 4.3.2)
 crosstalk           1.2.1      2023-11-23 [1] RSPM (R 4.3.0)
 crsmeta             0.3.0      2020-03-29 [1] RSPM (R 4.3.0)
 curl                5.2.0      2023-12-08 [1] RSPM (R 4.3.0)
 data.table          1.15.0     2024-01-30 [1] RSPM (R 4.3.0)
 DBI                 1.2.2      2024-02-16 [1] RSPM (R 4.3.0)
 dbplyr              2.4.0      2023-10-26 [1] RSPM (R 4.3.0)
 desc                1.4.3      2023-12-10 [1] RSPM (R 4.3.0)
 devtools            2.4.5      2022-10-11 [1] RSPM (R 4.3.0)
 DiagrammeR          1.0.11     2024-02-02 [1] RSPM (R 4.3.0)
 diffobj             0.3.5      2021-10-05 [1] RSPM (R 4.3.0)
 digest              0.6.34     2024-01-11 [1] RSPM (R 4.3.0)
 distill             1.6        2023-10-06 [1] RSPM (R 4.3.0)
 docopt              0.7.1      2020-06-24 [1] RSPM (R 4.3.2)
 dotCall64           1.1-1      2023-11-28 [1] CRAN (R 4.3.2)
 downlit             0.4.3      2023-06-29 [1] RSPM (R 4.3.0)
 dplyr               1.1.4      2023-11-17 [1] RSPM (R 4.3.0)
 dsn                 0.0.1.9011 2024-03-11 [1] Github (hypertidy/dsn@15743da)
 dtplyr              1.3.1      2023-03-22 [1] RSPM (R 4.3.0)
 duckdb              0.9.2-1    2023-11-28 [1] RSPM (R 4.3.0)
 e1071               1.7-14     2023-12-06 [1] CRAN (R 4.3.2)
 ellipsis            0.3.2      2021-04-29 [1] RSPM (R 4.3.0)
 evaluate            0.23       2023-11-01 [1] RSPM (R 4.3.0)
 fansi               1.0.6      2023-12-08 [1] RSPM (R 4.3.0)
 farver              2.1.1      2022-07-06 [1] RSPM (R 4.3.0)
 fastmap             1.1.1      2023-02-24 [1] RSPM (R 4.3.0)
 fields              15.2       2023-08-17 [1] CRAN (R 4.3.2)
 fontawesome         0.5.2      2023-08-19 [1] RSPM (R 4.3.0)
 forcats             1.0.0      2023-01-29 [1] RSPM (R 4.3.0)
 foreign             0.8-85     2023-09-09 [2] CRAN (R 4.3.2)
 fs                  1.6.3      2023-07-20 [1] RSPM (R 4.3.0)
 fst                 0.9.8      2022-02-08 [1] RSPM (R 4.3.0)
 fstcore             0.9.18     2023-12-02 [1] RSPM (R 4.3.0)
 furrr               0.3.1      2022-08-15 [1] CRAN (R 4.3.2)
 future              1.33.1     2023-12-22 [1] CRAN (R 4.3.2)
 future.batchtools   0.12.1     2023-12-20 [1] CRAN (R 4.3.2)
 gargle              1.5.2      2023-07-20 [1] RSPM (R 4.3.0)
 gdalcubes           0.7.0      2024-03-07 [1] CRAN (R 4.3.2)
 generics            0.1.3      2022-07-05 [1] RSPM (R 4.3.0)
 geodata             0.5-9      2023-10-13 [1] CRAN (R 4.3.2)
 geometries          0.2.4      2024-01-15 [1] CRAN (R 4.3.2)
 geosphere           1.5-18     2022-11-15 [1] CRAN (R 4.3.2)
 gert                2.0.1      2023-12-04 [1] RSPM (R 4.3.0)
 getip               0.1-4      2023-12-10 [1] CRAN (R 4.3.2)
 ggplot2             3.5.0      2024-02-23 [1] RSPM (R 4.3.0)
 gh                  1.4.0      2023-02-22 [1] RSPM (R 4.3.0)
 gitcreds            0.1.2      2022-09-08 [1] RSPM (R 4.3.0)
 globals             0.16.3     2024-03-08 [1] CRAN (R 4.3.2)
 glue                1.7.0      2024-01-09 [1] RSPM (R 4.3.0)
 googledrive         2.1.1      2023-06-11 [1] RSPM (R 4.3.0)
 googlesheets4       1.1.1      2023-06-11 [1] RSPM (R 4.3.0)
 gridExtra           2.3        2017-09-09 [1] RSPM (R 4.3.0)
 gtable              0.3.4      2023-08-21 [1] RSPM (R 4.3.0)
 haven               2.5.4      2023-11-30 [1] RSPM (R 4.3.0)
 here                1.0.1      2020-12-13 [1] CRAN (R 4.3.2)
 highr               0.10       2022-12-22 [1] RSPM (R 4.3.0)
 hms                 1.1.3      2023-03-21 [1] RSPM (R 4.3.0)
 htmltools           0.5.7      2023-11-03 [1] RSPM (R 4.3.0)
 htmlwidgets         1.6.4      2023-12-06 [1] RSPM (R 4.3.0)
 httpuv              1.6.14     2024-01-26 [1] RSPM (R 4.3.0)
 httr                1.4.7      2023-08-15 [1] RSPM (R 4.3.0)
 httr2               1.0.0      2023-11-14 [1] RSPM (R 4.3.0)
 ids                 1.0.1      2017-05-31 [1] RSPM (R 4.3.0)
 igraph              2.0.2      2024-02-17 [1] RSPM (R 4.3.0)
 ini                 0.3.1      2018-05-20 [1] RSPM (R 4.3.0)
 isoband             0.2.7      2022-12-20 [1] RSPM (R 4.3.0)
 jquerylib           0.1.4      2021-04-26 [1] RSPM (R 4.3.0)
 jsonlite            1.8.8      2023-12-04 [1] RSPM (R 4.3.0)
 KernSmooth          2.23-22    2023-07-10 [2] CRAN (R 4.3.2)
 knitr               1.45       2023-10-30 [1] RSPM (R 4.3.0)
 labeling            0.4.3      2023-08-29 [1] RSPM (R 4.3.0)
 Lahman              11.0-0     2023-05-04 [1] RSPM (R 4.3.0)
 later               1.3.2      2023-12-06 [1] RSPM (R 4.3.0)
 lattice             0.21-9     2023-10-01 [2] CRAN (R 4.3.2)
 lazyeval            0.2.2      2019-03-15 [1] RSPM (R 4.3.0)
 leaflet             2.2.1      2023-11-13 [1] RSPM (R 4.3.0)
 leaflet.providers   2.0.0      2023-10-17 [1] RSPM (R 4.3.0)
 lifecycle           1.0.4      2023-11-07 [1] RSPM (R 4.3.0)
 listenv             0.9.1      2024-01-29 [1] CRAN (R 4.3.2)
 littler             0.3.19     2023-12-17 [1] RSPM (R 4.3.2)
 lubridate           1.9.3      2023-09-27 [1] RSPM (R 4.3.0)
 lwgeom              0.2-14     2024-02-21 [1] CRAN (R 4.3.2)
 magrittr            2.0.3      2022-03-30 [1] RSPM (R 4.3.0)
 maps                3.4.2      2023-12-15 [1] CRAN (R 4.3.2)
 MASS                7.3-60     2023-05-04 [2] CRAN (R 4.3.2)
 Matrix              1.6-1.1    2023-09-18 [2] CRAN (R 4.3.2)
 memoise             2.0.1      2021-11-26 [1] RSPM (R 4.3.0)
 mgcv                1.9-0      2023-07-11 [2] CRAN (R 4.3.2)
 mime                0.12       2021-09-28 [1] RSPM (R 4.3.0)
 miniUI              0.1.1.1    2018-05-18 [1] RSPM (R 4.3.0)
 mirai               0.12.1     2024-02-02 [1] CRAN (R 4.3.2)
 modelr              0.1.11     2023-03-22 [1] RSPM (R 4.3.0)
 munsell             0.5.0      2018-06-12 [1] RSPM (R 4.3.0)
 nanoarrow           0.4.0.1    2024-02-23 [1] RSPM (R 4.3.0)
 nanonext            0.13.2     2024-03-01 [1] CRAN (R 4.3.2)
 ncdf4               1.22       2023-11-28 [1] CRAN (R 4.3.2)
 ncmeta              0.3.6      2023-11-01 [1] RSPM (R 4.3.0)
 nlme                3.1-163    2023-08-09 [2] CRAN (R 4.3.2)
 nnet                7.3-19     2023-05-03 [2] CRAN (R 4.3.2)
 nycflights13        1.0.2      2021-04-12 [1] RSPM (R 4.3.0)
 openssl             2.1.1      2023-09-25 [1] RSPM (R 4.3.0)
 packrat             0.9.2      2023-09-05 [1] RSPM (R 4.3.0)
 palr                0.4.0      2024-03-11 [1] Github (AustralianAntarcticDivision/palr@4a68082)
 parallelly          1.37.1     2024-02-29 [1] CRAN (R 4.3.2)
 pillar              1.9.0      2023-03-22 [1] RSPM (R 4.3.0)
 pkgbuild            1.4.3      2023-12-10 [1] RSPM (R 4.3.0)
 pkgconfig           2.0.3      2019-09-22 [1] RSPM (R 4.3.0)
 pkgdown             2.0.7      2022-12-14 [1] RSPM (R 4.3.0)
 pkgload             1.3.4      2024-01-16 [1] RSPM (R 4.3.0)
 plogr               0.2.0      2018-03-25 [1] RSPM (R 4.3.0)
 png                 0.1-8      2022-11-29 [1] RSPM (R 4.3.0)
 praise              1.0.0      2015-08-11 [1] RSPM (R 4.3.0)
 prettyunits         1.2.0      2023-09-24 [1] RSPM (R 4.3.0)
 processx            3.8.3      2023-12-10 [1] RSPM (R 4.3.0)
 profvis             0.3.8      2023-05-02 [1] RSPM (R 4.3.0)
 progress            1.2.3      2023-12-06 [1] RSPM (R 4.3.0)
 PROJ                0.4.5.9003 2024-03-11 [1] Github (hypertidy/PROJ@37836a8)
 proj4               1.0-14     2024-01-14 [1] RSPM (R 4.3.0)
 promises            1.2.1      2023-08-10 [1] RSPM (R 4.3.0)
 proxy               0.4-27     2022-06-09 [1] CRAN (R 4.3.2)
 ps                  1.7.6      2024-01-18 [1] RSPM (R 4.3.0)
 purrr               1.0.2      2023-08-10 [1] RSPM (R 4.3.0)
 R.methodsS3         1.8.2      2022-06-13 [1] RSPM (R 4.3.0)
 R.oo                1.26.0     2024-01-24 [1] RSPM (R 4.3.0)
 R.utils             2.12.3     2023-11-18 [1] RSPM (R 4.3.0)
 r2d3                0.2.6      2022-02-28 [1] RSPM (R 4.3.0)
 R6                  2.5.1      2021-08-19 [1] RSPM (R 4.3.0)
 raadfiles           0.1.4.9003 2024-03-11 [1] Github (AustralianAntarcticDivision/raadfiles@9793954)
 raadtools           0.6.0.9035 2024-03-11 [1] Github (AustralianAntarcticDivision/raadtools@e5ced96)
 ragg                1.2.7      2023-12-11 [1] RSPM (R 4.3.0)
 rappdirs            0.3.3      2021-01-31 [1] RSPM (R 4.3.0)
 raster              3.6-26     2023-10-14 [1] RSPM (R 4.3.0)
 rcmdcheck           1.4.0      2021-09-27 [1] RSPM (R 4.3.0)
 rcmip6              0.0.2.9000 2024-03-11 [1] Github (eliocamp/rcmip6@0a417ed)
 RColorBrewer        1.1-3      2022-04-03 [1] RSPM (R 4.3.0)
 Rcpp                1.0.12     2024-01-09 [1] RSPM (R 4.3.0)
 RcppTOML            0.2.2      2023-01-29 [1] CRAN (R 4.3.2)
 readr               2.1.5      2024-01-10 [1] RSPM (R 4.3.0)
 readxl              1.4.3      2023-07-06 [1] RSPM (R 4.3.0)
 redland             1.0.17-18  2024-02-24 [1] RSPM (R 4.3.0)
 rematch             2.0.0      2023-08-30 [1] RSPM (R 4.3.0)
 rematch2            2.1.2      2020-05-01 [1] RSPM (R 4.3.0)
 remotes             2.4.2.1    2023-07-18 [1] RSPM (R 4.3.0)
 renv                1.0.4      2024-02-21 [1] RSPM (R 4.3.0)
 reprex              2.1.0      2024-01-11 [1] RSPM (R 4.3.0)
 reproj              0.4.3      2022-10-28 [1] RSPM (R 4.3.0)
 reticulate        * 1.35.0     2024-01-31 [1] CRAN (R 4.3.2)
 rex                 1.2.1      2021-11-26 [1] RSPM (R 4.3.0)
 rJava               1.0-11     2024-01-26 [1] RSPM (R 4.3.0)
 rlang               1.1.3      2024-01-10 [1] RSPM (R 4.3.0)
 RMariaDB            1.3.1      2023-10-26 [1] RSPM (R 4.3.0)
 rmarkdown           2.25       2023-09-18 [1] RSPM (R 4.3.0)
 RNetCDF             2.9-1      2024-01-09 [1] RSPM (R 4.3.0)
 roxygen2            7.3.1      2024-01-22 [1] RSPM (R 4.3.0)
 rpart               4.1.21     2023-10-09 [2] CRAN (R 4.3.2)
 RPostgres           1.4.6      2023-10-22 [1] RSPM (R 4.3.0)
 rprojroot           2.0.4      2023-11-05 [1] RSPM (R 4.3.0)
 rsconnect           1.2.1      2024-01-31 [1] RSPM (R 4.3.0)
 rslurm              0.6.2      2023-02-24 [1] CRAN (R 4.3.2)
 RSQLite             2.3.5      2024-01-21 [1] RSPM (R 4.3.0)
 rstudioapi          0.15.0     2023-07-07 [1] RSPM (R 4.3.0)
 rticles             0.26       2023-12-20 [1] RSPM (R 4.3.0)
 rversions           2.1.2      2022-08-31 [1] RSPM (R 4.3.0)
 rvest               1.0.4      2024-02-12 [1] RSPM (R 4.3.0)
 s2                  1.1.6      2023-12-19 [1] CRAN (R 4.3.2)
 sass                0.4.8      2023-12-06 [1] RSPM (R 4.3.0)
 scales              1.3.0      2023-11-28 [1] RSPM (R 4.3.0)
 sds                 0.0.1.9004 2024-03-11 [1] Github (hypertidy/sds@87c5694)
 selectr             0.4-2      2019-11-20 [1] RSPM (R 4.3.0)
 servr               0.29       2024-02-09 [1] RSPM (R 4.3.0)
 sessioninfo         1.2.2      2021-12-06 [1] RSPM (R 4.3.0)
 sf                  1.0-15     2023-12-18 [1] CRAN (R 4.3.2)
 sfheaders           0.4.4      2024-01-17 [1] CRAN (R 4.3.2)
 shiny               1.8.0      2023-11-17 [1] RSPM (R 4.3.0)
 sourcetools         0.1.7-1    2023-02-01 [1] RSPM (R 4.3.0)
 sp                  2.1-3      2024-01-30 [1] CRAN (R 4.3.2)
 spam                2.10-0     2023-10-23 [1] CRAN (R 4.3.2)
 spatial             7.3-17     2023-07-20 [2] CRAN (R 4.3.2)
 stars               0.6-4      2023-09-11 [1] CRAN (R 4.3.2)
 stringi             1.8.3      2023-12-11 [1] RSPM (R 4.3.0)
 stringr             1.5.1      2023-11-14 [1] RSPM (R 4.3.0)
 survival            3.5-7      2023-08-14 [2] CRAN (R 4.3.2)
 sys                 3.4.2      2023-05-23 [1] RSPM (R 4.3.0)
 systemfonts         1.0.5      2023-10-09 [1] RSPM (R 4.3.0)
 terra               1.7-71     2024-01-31 [1] CRAN (R 4.3.2)
 testit              0.13       2021-04-14 [1] RSPM (R 4.3.0)
 testthat            3.2.1      2023-12-02 [1] RSPM (R 4.3.0)
 textshaping         0.3.7      2023-10-09 [1] RSPM (R 4.3.0)
 tibble              3.2.1      2023-03-20 [1] RSPM (R 4.3.0)
 tidyr               1.3.1      2024-01-24 [1] RSPM (R 4.3.0)
 tidyselect          1.2.0      2022-10-10 [1] RSPM (R 4.3.0)
 tidyverse           2.0.0      2023-02-22 [1] RSPM (R 4.3.0)
 timechange          0.3.0      2024-01-18 [1] RSPM (R 4.3.0)
 tinytex             0.49       2023-11-22 [1] RSPM (R 4.3.0)
 tufte               0.13       2023-06-22 [1] RSPM (R 4.3.0)
 tzdb                0.4.0      2023-05-12 [1] RSPM (R 4.3.0)
 units               0.8-5      2023-11-28 [1] CRAN (R 4.3.2)
 urlchecker          1.0.1      2021-11-30 [1] CRAN (R 4.3.2)
 usethis             2.2.3      2024-02-19 [1] RSPM (R 4.3.0)
 utf8                1.2.4      2023-10-22 [1] RSPM (R 4.3.0)
 uuid                1.2-0      2024-01-14 [1] RSPM (R 4.3.0)
 vapour              0.9.5.9010 2024-03-11 [1] Github (hypertidy/vapour@5e67be7)
 vctrs               0.6.5      2023-12-01 [1] RSPM (R 4.3.0)
 viridis             0.6.5      2024-01-29 [1] RSPM (R 4.3.0)
 viridisLite         0.4.2      2023-05-02 [1] RSPM (R 4.3.0)
 visNetwork          2.1.2      2022-09-29 [1] RSPM (R 4.3.0)
 vroom               1.6.5      2023-12-05 [1] RSPM (R 4.3.0)
 waldo               0.5.2      2023-11-02 [1] RSPM (R 4.3.0)
 webshot             0.5.5      2023-06-26 [1] RSPM (R 4.3.0)
 whatarelief         0.0.1.9012 2024-03-11 [1] Github (hypertidy/whatarelief@4520ba7)
 whisker             0.4.1      2022-12-05 [1] RSPM (R 4.3.0)
 whoami              1.3.0      2019-03-19 [1] RSPM (R 4.3.0)
 withr               3.0.0      2024-01-16 [1] RSPM (R 4.3.0)
 wk                  0.9.1      2023-11-29 [1] CRAN (R 4.3.2)
 xaringan            0.29       2024-02-09 [1] RSPM (R 4.3.0)
 xfun                0.42       2024-02-08 [1] RSPM (R 4.3.0)
 ximage              0.0.0.9011 2024-03-11 [1] Github (hypertidy/ximage@4d8e7ab)
 xml2                1.3.6      2023-12-04 [1] RSPM (R 4.3.0)
 xopen               1.0.0      2018-09-17 [1] RSPM (R 4.3.0)
 xtable              1.8-4      2019-04-21 [1] RSPM (R 4.3.0)
 yaml                2.3.8      2023-12-11 [1] RSPM (R 4.3.0)
 zip                 2.3.1      2024-01-27 [1] RSPM (R 4.3.0)

```
