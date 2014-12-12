## Emacs, make this -*- mode: sh; -*-
### r-coverage based on R-3.0.2
# inspired a lot by https://github.com/rocker-org

FROM debian:7.6
MAINTAINER "Karl Forner" karl.forner@quartzbio.com

## Remain current
RUN apt-get update -qq \
&& apt-get dist-upgrade -y

RUN apt-get install -y --no-install-recommends \
    bash-completion \
    bison \
    debhelper \
    default-jdk \
    g++ \
    gcc \
    gfortran \
    groff-base \
    libblas-dev \
    libbz2-dev \
    libcairo2-dev \
    libjpeg-dev \
    liblapack-dev \
    liblzma-dev \
    libncurses5-dev \
    libpango1.0-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    libx11-dev \
    libxt-dev \
    mpack \
    subversion \
    tcl8.5-dev \
    texinfo \
    texlive-base \
    texlive-extra-utils \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-latex-recommended \
    tk8.5-dev \
    x11proto-core-dev \
    xauth \
    xdg-utils \
    xfonts-base \
    xvfb \
    zlib1g-dev 

RUN apt-get install -y \
    ed \
    less \
    littler \
    locales \
    r-base-dev \
    vim-tiny \
    wget \
 && ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
 && ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
 && ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
 && ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
 && install.r docopt \
 && rm -rf /tmp/downloaded_packages/

## Configure default locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen en_US.utf8 \
 && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# download and install R-3.0.2
WORKDIR /tmp
ENV RVERSION 3.0.2
COPY r-3.0.2_cov-patch.txt /tmp/
RUN wget -q http://cran.r-project.org/src/base/R-3/R-$RVERSION.tar.gz && \
    tar zxf R-$RVERSION.tar.gz && \
    patch -p0 < r-3.0.2_cov-patch.txt && \
    cd  R-$RVERSION && \
    echo 'patched' && \
    ./configure --enable-R-shlib --enable-memory-profiling --with-readline && \
    echo 'configured' && \
    make -j 4 && \
    make install

## Set a CRAN repo
RUN echo 'options(repos = list(CRAN = "http://stat.ethz.ch/CRAN/"))' >> /usr/local/lib/R/etc/Rprofile.site

# update all the packages that need to be reinstalled.
RUN Rscript -e 'update.packages(checkBuilt = TRUE, ask = FALSE)'

## install essential packages
RUN apt-get install -y --no-install-recommends curl libcurl4-openssl-dev libxml2-dev nano sudo 
RUN Rscript -e 'install.packages("devtools")'

## Set a default user. Available via runtime flag `--user docker` 
RUN useradd -g staff -m docker
WORKDIR /home/docker
COPY bashrc .bashrc
COPY test.R /home/docker/
COPY test2.R /home/docker/
ENV PATH /usr/local/bin:$PATH

# for testing
ENV PKGTESTTHAT testthat_0.7.1.tar.gz
RUN wget http://cran.r-project.org/src/contrib/Archive/testthat/$PKGTESTTHAT && \
    R CMD INSTALL $PKGTESTTHAT && \
    tar zxf $PKGTESTTHAT && \
    rm $PKGTESTTHAT


USER docker
CMD R
