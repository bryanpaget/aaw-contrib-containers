FROM ubuntu:20.04
MAINTAINER Bryan Paget <bryanpaget@pm.me>

ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true
ARG NB_USER=jovyan
ARG NB_UID=1000
ARG NB_GID=100

ENV USER_HOME=/home/$NB_USER \
    PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 \
    PATH=$PATH:/home/$NB_USER/.local/bin \
    SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    TZ=America/New_York

RUN apt-get update \
    && apt-get -y install --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    davix-dev \
    dcap-dev \
    file \
    fonts-freefont-ttf \
    g++ \
    gcc \
    gfal2 \
    gfortran \
    git \
    glpk-doc \
    glpk-utils \
    libafterimage-dev \
    libavahi-compat-libdnssd-dev \
    libblas-dev \
    libcfitsio-dev \
    libfftw3-dev \
    libfreetype6-dev \
    libftgl-dev \
    libgfal2-dev \
    libgfortran-10-dev \
    libgif-dev \
    libgl2ps-dev \
    libglew-dev \
    libglpk-dev \
    libglu-dev \
    libgraphviz-dev \
    libgsl-dev \
    libjemalloc-dev \
    libjpeg-dev \
    libkrb5-dev \
    liblapack-dev \
    libldap2-dev \
    liblz4-dev \
    liblzma-dev \
    libmetis-dev \
    libmysqlclient-dev \
    libnauty2-dev \
    libpcre++-dev \
    libpng-dev \
    libpq-dev \
    libpythia8-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtbb-dev \
    libtiff-dev \
    libx11-dev \
    libxext-dev \
    libxft-dev \
    libxml2-dev \
    libxpm-dev \
    libz-dev \
    libzmq3-dev \
    locales \
    lsb-release \
    make \
    openjdk-11-jdk \
    parallel \
    patch \
    pkg-config \
    python3 \
    python3-dev \
    python3-markdown \
    python3-pip \
    python3-requests \
    python3-tk \
    python3-yaml \
    r-base \
    r-cran-rcpp \
    r-cran-rinside \
    rsync \
    srm-ifce-dev \
    subversion \
    unixodbc-dev \
    unzip \
    vim \
    wget \
    && apt-get clean

RUN git clone https://github.com/coin-or/coinbrew /var/coin-or \
    && git clone https://github.com/jckantor/ND-Pyomo-Cookbook /home/pyomo/ND-Pyomo-Cookbook \
    && git clone https://github.com/Pyomo/PyomoGallery /home/pyomo/Pyomo-Gallery

WORKDIR /var/coin-or

RUN ./coinbrew fetch COIN-OR-OptimizationSuite@1.9 --skip="ThirdParty/Blas ThirdParty/Lapack ThirdParty/Metis" --no-prompt \
    && ./coinbrew build  COIN-OR-OptimizationSuite --skip="ThirdParty/Blas ThirdParty/Lapack ThirdParty/Metis" --no-prompt --prefix=/usr

# Copy a script that we will use to correct permissions after running certain commands
COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions \
    && groupadd -g $NB_UID $NB_USER \
    && useradd -m -r -u $NB_UID -g $NB_USER $NB_USER \
    && chmod g+w /etc/passwd \
    && fix-permissions $USER_HOME \
    && chown -R $NB_USER:$NB_USER $USER_HOME

USER $NB_USER

WORKDIR $USER_HOME

RUN python3 -m pip --no-cache-dir install --user --upgrade \
    pip \
    wheel \
    setuptools \
    pybind11

# We need pybind11 to install spdlog, hence a new layer
RUN python3 -m pip --no-cache-dir install --user --upgrade \
    spdlog \
    cbor \
    h5py \
    matplotlib \
    numpy \
    pandas \
    Pillow \
    scipy \
    sklearn \
    glpk \
    pyomo \
    PuLP \
    simpy \
    jupyterlab

EXPOSE 8888

ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0"]
