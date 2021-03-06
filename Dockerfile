
## start with the Docker 'R-base' Debian-based image
FROM rocker/hadleyverse:latest

## maintainer of this script
MAINTAINER Ian Munoz <ian.org@gmail.com>

## Add binaries for more CRAN packages, deb-src repositories in case we need `apt-get build-dep`
#RUN echo 'deb http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
#  && gpg --keyserver keyserver.ubuntu.com --recv-keys AE05705B842492A68F75D64E01BF7284B26DD379 \
#  && gpg --export AE05705B842492A68F75D64E01BF7284B26DD379  | apt-key add - \
#  && echo 'deb-src http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
#  && echo 'deb-src http://http.debian.net/debian testing main' >> /etc/apt/sources.list

## Remain current
RUN apt-get update -qq \
  && apt-get dist-upgrade -y

## additional build dependencies for R spatial packages
RUN apt-get install -y --no-install-recommends -t unstable \
	bwidget \
	ca-certificates \
	curl \
	gdal-bin \
	git \
  libgsl2 \
	gsl-bin \
	libcurl4-openssl-dev \
	libgdal-dev \
	libgeos-dev \
	libgeos++-dev \
	libproj-dev \
	libspatialite-dev \
	libv8-dev \
	libxml2-dev \
	netcdf-bin \
	pandoc pandoc-citeproc \
	qpdf \
	r-cran-rgl \
	r-cran-tkrplot \
	xauth \
	xfonts-base \
	xvfb \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/apt/lists

## install devtools
RUN install2.r devtools

## install R spatial packages && cleanup
RUN xvfb-run -a install.r \
    geoR \
    ggmap \
    ggvis \
    gstat \
    mapdata \
    maps \
    maptools \
    plotKML \
    RandomFields \
    rgdal \
    rgeos \
    shapefiles \
    sp \
    spatstat \
    raster \
    rasterVis \
    rts \
  && installGithub.r s-u/fastshp \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
