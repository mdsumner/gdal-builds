
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gdal-builds

<!-- badges: start -->
<!-- badges: end -->

The goal of gdal-builds is to create a single image with all geospatial
libs up to date and with R and Python packages using them in alignment.

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

All very much WIP, I can’t otherwise get rocker to do what I want yet
(it’s kind of built in the other direction, first they layer up R base
and get to rstudio, but I just want the libs, then R, and python, then I
can add rstudio and publishing and packages etc.). Python quirks with it
installing binary libs - wheels - and cli tools with a package are a
total obstacle for how I want to work, so I’m starting fresh with what I
understand.

We might unpick to multiple builds again, I guess to separate R and
Python but this is all together is what I want for now.

Note it’s a very large image, like 6-7Gb and that’s bigger than it could
be, we’ll clean up.

See the versions of libs GEOS, PROJ, GDAL - these reports are as at
2024-01-22.

     terra::gdal()
    [1] "3.9.0dev-468125c1ce"
     terra::gdal(lib = "PROJ")
    [1] "9.3.1"
    > terra::gdal(lib = "GEOS")
    [1] "3.12.1"

    library(reticulate)
    import("geopandas")$show_versions()

    SYSTEM INFO
    -----------
    python     : 3.10.12 (main, Nov 20 2023, 15:14:05) [GCC 11.4.0]
    executable : /usr/bin/python3
    machine    : Linux-5.15.0-91-generic-x86_64-with-glibc2.35

    GEOS, GDAL, PROJ INFO
    ---------------------
    GEOS       : 3.12.1
    GEOS lib   : None
    GDAL       : 3.9.0dev-468125c1ce
    GDAL data dir: None
    PROJ       : 9.3.0
    PROJ data dir: /usr/local/lib/python3.10/dist-packages/pyproj/proj_dir/share/proj

    PYTHON DEPENDENCIES
    -------------------
    geopandas  : 0.14.2
    numpy      : 1.26.3
    pandas     : 2.2.0
    pyproj     : 3.6.1
    shapely    : 2.0.2
    fiona      : 1.9.5
    geoalchemy2: None
    geopy      : None
    matplotlib : 3.8.2
    mapclassify: None
    pygeos     : None
    pyogrio    : 0.7.2
    psycopg2   : None
    pyarrow    : None
    rtree      : None


    import("rioxarray")$show_versions()
    rioxarray (0.15.0) deps:
      rasterio: 1.3.9
        xarray: 2024.1.0
          GDAL: 3.9.0dev-468125c1ce
          GEOS: 3.12.1
          PROJ: 9.3.1
     PROJ DATA: /root/.local/share/proj:/usr/local/share/proj:/usr/local/share/proj
     GDAL DATA: /usr/local/lib/R/site-library/terra//gdal

    Other python deps:
         scipy: 1.12.0
        pyproj: 3.6.1

    System:
        python: 3.10.12 (main, Nov 20 2023, 15:14:05) [GCC 11.4.0]
    executable: /usr/bin/python3
       machine: Linux-5.15.0-91-generic-x86_64-with-glibc2.35

    import("shapely")$geos_version_string
    #[1] "3.12.1"

Available Python packages as at 2024-01-22:

    Package                       Version
    ----------------------------- ------------
    affine                        2.4.0
    alabaster                     0.7.16
    asciitree                     0.3.3
    attrs                         23.2.0
    Babel                         2.14.0
    boto3                         1.34.23
    botocore                      1.34.23
    cachetools                    5.3.2
    certifi                       2023.11.17
    cftime                        1.6.3
    charset-normalizer            3.3.2
    click                         8.1.7
    click-plugins                 1.1.1
    cligj                         0.7.2
    cloudpickle                   3.0.0
    contourpy                     1.2.0
    coverage                      7.4.0
    cycler                        0.12.1
    Cython                        3.0.8
    dask                          2024.1.0
    delocate                      0.10.7
    docutils                      0.20.1
    exceptiongroup                1.2.0
    fasteners                     0.19
    fiona                         1.9.5
    fonttools                     4.47.2
    fsspec                        2023.12.2
    geopandas                     0.14.2
    h5netcdf                      1.3.0
    h5py                          3.10.0
    hypothesis                    6.96.2
    idna                          3.6
    imagesize                     1.4.1
    importlib                     1.0.4
    importlib-metadata            7.0.1
    iniconfig                     2.0.0
    Jinja2                        3.1.3
    jmespath                      1.0.1
    jsonschema                    4.21.1
    jsonschema-specifications     2023.12.1
    kiwisolver                    1.4.5
    locket                        1.0.0
    MarkupSafe                    2.1.4
    matplotlib                    3.8.2
    mypy                          1.8.0
    mypy-extensions               1.0.0
    netCDF4                       1.6.5
    numcodecs                     0.12.1
    numpy                         1.26.3
    numpydoc                      1.6.0
    odc-geo                       0.4.1
    packaging                     23.2
    pandas                        2.2.0
    partd                         1.4.1
    pillow                        10.2.0
    pip                           23.3.2
    pluggy                        1.3.0
    pyaml                         23.12.0
    Pygments                      2.17.2
    pyogrio                       0.7.2
    pyparsing                     3.1.1
    pyproj                        3.6.1
    pystac                        1.9.0
    pystac-client                 0.7.5
    pytest                        7.4.4
    pytest-cov                    4.1.0
    pytest-randomly               3.10.1
    python-dateutil               2.8.2
    pytz                          2023.3.post1
    PyYAML                        6.0.1
    rasterio                      1.3.9
    referencing                   0.32.1
    requests                      2.31.0
    rioxarray                     0.15.0
    rpds-py                       0.17.1
    s3transfer                    0.10.0
    scipy                         1.12.0
    setuptools                    69.0.3
    shapely                       2.0.2
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
    toolz                         0.12.0
    typing_extensions             4.9.0
    tzdata                        2023.4
    urllib3                       2.0.7
    wheel                         0.37.1
    xarray                        2024.1.0
    zarr                          2.16.1
    zipp                          3.17.0

Available R packages:

    abind        1.4.5
    arrow        14.0.0.2
    askpass        1.2.0
    assertthat        0.2.1
    backports        1.4.1
    base64enc        0.1.3
    BH        1.84.0.0
    BiocManager        1.30.22
    bit        4.0.5
    bit64        4.0.5
    blob        1.2.4
    blogdown        1.18
    bookdown        0.37
    brew        1.0.10
    brio        1.1.4
    broom        1.0.5
    bslib        0.6.1
    cachem        1.0.8
    callr        3.7.3
    cellranger        1.1.0
    classInt        0.4.10
    cli        3.6.2
    clipr        0.8.0
    colorspace        2.1.0
    commonmark        1.9.0
    conflicted        1.2.0
    countrycode        1.5.0
    covr        3.6.4
    cpp11        0.4.7
    crayon        1.5.2
    credentials        2.0.1
    curl        5.2.0
    data.table        1.14.10
    DBI        1.1.3
    dbplyr        2.4.0
    desc        1.4.3
    devtools        2.4.5
    DiagrammeR        1.0.10
    diffobj        0.3.5
    digest        0.6.33
    distill        1.6
    docopt        0.7.1
    downlit        0.4.3
    downloader        0.4
    dplyr        1.1.4
    dsn        0.0.1.9011
    dtplyr        1.3.1
    duckdb        0.9.2.1
    e1071        1.7.14
    ellipsis        0.3.2
    evaluate        0.23
    fansi        1.0.6
    farver        2.1.1
    fastmap        1.1.1
    fontawesome        0.5.2
    forcats        1.0.0
    fs        1.6.3
    fst        0.9.8
    fstcore        0.9.18
    gargle        1.5.2
    gdalcubes        0.6.4
    generics        0.1.3
    geodata        0.5.9
    geometries        0.2.4
    geosphere        1.5.18
    gert        2.0.1
    ggplot2        3.4.4
    gh        1.4.0
    gitcreds        0.1.2
    glue        1.7.0
    googledrive        2.1.1
    googlesheets4        1.1.1
    gridExtra        2.3
    gtable        0.3.4
    haven        2.5.4
    here        1.0.1
    highr        0.10
    hms        1.1.3
    htmltools        0.5.7
    htmlwidgets        1.6.4
    httpuv        1.6.13
    httr        1.4.7
    httr2        1.0.0
    ids        1.0.1
    igraph        1.6.0
    ini        0.3.1
    isoband        0.2.7
    jquerylib        0.1.4
    jsonlite        1.8.8
    knitr        1.45
    labeling        0.4.3
    Lahman        11.0.0
    later        1.3.2
    lazyeval        0.2.2
    lifecycle        1.0.4
    littler        0.3.19
    lubridate        1.9.3
    lwgeom        0.2.13
    magrittr        2.0.3
    memoise        2.0.1
    mime        0.12
    miniUI        0.1.1.1
    modelr        0.1.11
    munsell        0.5.0
    nanoarrow        0.3.0.1
    ncdf4        1.22
    nycflights13        1.0.2
    openssl        2.1.1
    packrat        0.9.2
    pillar        1.9.0
    pkgbuild        1.4.3
    pkgconfig        2.0.3
    pkgdown        2.0.7
    pkgload        1.3.3
    plogr        0.2.0
    png        0.1.8
    praise        1.0.0
    prettyunits        1.2.0
    processx        3.8.3
    profvis        0.3.8
    progress        1.2.3
    PROJ        0.4.5.9002
    promises        1.2.1
    proxy        0.4.27
    ps        1.7.5
    purrr        1.0.2
    r2d3        0.2.6
    R6        2.5.1
    ragg        1.2.7
    rappdirs        0.3.3
    rcmdcheck        1.4.0
    RColorBrewer        1.1.3
    Rcpp        1.0.12
    RcppTOML        0.2.2
    readr        2.1.4
    readxl        1.4.3
    redland        1.0.17.17
    rematch        2.0.0
    rematch2        2.1.2
    remotes        2.4.2.1
    renv        1.0.3
    reprex        2.0.2
    reticulate        1.34.0
    rex        1.2.1
    rJava        1.0.10
    rlang        1.1.3
    RMariaDB        1.3.1
    rmarkdown        2.25
    roxygen2        7.2.3
    RPostgres        1.4.6
    rprojroot        2.0.4
    rsconnect        1.2.0
    RSQLite        2.3.4
    rstudioapi        0.15.0
    rticles        0.25
    rversions        2.1.2
    rvest        1.0.3
    s2        1.1.6
    sass        0.4.8
    scales        1.3.0
    sds        0.0.1.9003
    selectr        0.4.2
    servr        0.28
    sessioninfo        1.2.2
    sf        1.0.15
    sfheaders        0.4.4
    shiny        1.8.0
    sourcetools        0.1.7.1
    sp        2.1.2
    stars        0.6.4
    stringi        1.8.3
    stringr        1.5.1
    sys        3.4.2
    systemfonts        1.0.5
    terra        1.7.65
    testit        0.13
    testthat        3.2.1
    textshaping        0.3.7
    tibble        3.2.1
    tidyr        1.3.0
    tidyselect        1.2.0
    tidyverse        2.0.0
    timechange        0.2.0
    tinytex        0.49
    tufte        0.13
    tzdb        0.4.0
    units        0.8.5
    urlchecker        1.0.1
    usethis        2.2.2
    utf8        1.2.4
    uuid        1.1.1
    vapour        0.9.5.9008
    vctrs        0.6.5
    viridis        0.6.4
    viridisLite        0.4.2
    visNetwork        2.1.2
    vroom        1.6.5
    waldo        0.5.2
    webshot        0.5.5
    whisker        0.4.1
    whoami        1.3.0
    withr        2.5.2
    wk        0.9.1
    xaringan        0.28
    xfun        0.41
    ximage        0.0.0.9007
    xml2        1.3.6
    xopen        1.0.0
    xtable        1.8.4
    yaml        2.3.8
    zip        2.3.0
