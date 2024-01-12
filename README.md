
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gdal-builds

<!-- badges: start -->
<!-- badges: end -->

The goal of gdal-builds is to just me learning to use docker. I build

- gdal_dev, this is latest commit on osgeo/gdal ready to go (built from
  their gdal_deps)
- R_gdal_dev, adds R release and installs some packages from CRAN and
  github (a mix of pak and devtools because I don’t get why pak tries to
  blat my source build of gdal)
- gdal_dev_python, this is me trying to figure out how to get that list
  of python packages installed from source and using my build (and I
  might update netcdf, hdf5, etc as well)

You can do this to get into an interactive session

    docker run --rm -ti ghcr.io/mdsumner/gdal-builds:gdal_dev bash 

See the other containers here:
<https://github.com/mdsumner/gdal-builds/pkgs/container/gdal-builds>

All very much WIP, I can’t otherwise get rocker to do what I want yet
(it’s kind of built in the other direction, first they layer up R base
and get to rstudio, but I just want the libs, then R, and python, then I
can add rstudio and publishing and packages etc.). Python quirks with it
installing binary libs - wheels - and cli tools with a package are a
total obstacle for how I want to work, so I’m starting fresh with what I
understand.
