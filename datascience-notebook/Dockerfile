FROM node:alpine AS canvas

RUN apk update \
 && apk add --no-cache \
    ca-certificates \
    wget \
    unzip
    
WORKDIR /
RUN wget https://github.com/IllumiDesk/jupyter-lti/archive/master.zip -O jupyter-lti.zip
RUN unzip jupyter-lti.zip
WORKDIR /jupyter-lti-master
RUN npm install
RUN npm run build

FROM ubuntu:16.04

LABEL IllumiDesk <hello@illumidesk.com>

# Set when building on Travis so that certain long-running build steps can
# be skipped to shorten build time.
ARG TEST_ONLY_BUILD
ARG ENCODING=UTF-8
# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LC_ALL=en_US.$ENCODING \
    LANG=en_US.$ENCODING \
    LANGUAGE=en_US.$ENCODING
ENV PATH=$CONDA_DIR/bin:$PATH
ENV MINICONDA_VERSION=4.5.11
ENV HOME=/home/

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    build-essential \
    bzip2 \
    cmake \
    curl \
    emacs \
    ffmpeg \
    fonts-liberation \
    git \
    graphviz \
    inkscape \
    jed \
    libffi-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libgtk2.0-dev \
    libjasper-dev \
    libpng12-dev \
    libpq-dev \
    libmysqlclient-dev \
    libopencv-dev \
    libssl-dev \
    libtiff5-dev \
    libsm6 \
    libswscale-dev \
    libtbb2 \
    libxft-dev \
    libxrender1 \
    libavcodec-dev \
    libavformat-dev \
    libblas-dev \
    libdc1394-22-dev \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    locales \
    nano \
    netcat \
    nginx \
    nodejs \
    npm \
    pandoc \
    python-dev \
    python \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Configure Conda
RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "e1045ee415162f944b6aebfe560b8fee *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda install --quiet --yes conda="${MINICONDA_VERSION%.*}.*" && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    conda clean -tipsy && \
    rm -rf $HOME/.cache/yarn

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

RUN echo "${LANGUAGE} ${ENCODING}" > /etc/locale.gen && \
    locale-gen

# Install Python 3 packages
# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
# use notebook-friendly backends in these images
RUN conda install --quiet --yes \
    'conda-forge::blas=*=openblas' \
    'ipywidgets=7.4*' \
    'pandas=0.23*' \
    'numexpr=2.6*' \
    'matplotlib=2.2*' \
    'scipy=1.1*' \
    'seaborn=0.9*' \
    'scikit-learn=0.20*' \
    'scikit-image=0.14*' \
    'sympy=1.1*' \
    'cython=0.28*' \
    'patsy=0.5*' \
    'statsmodels=0.9*' \
    'cloudpickle=0.5*' \
    'dill=0.2*' \
    'numba=0.38*' \
    'bokeh=0.13*' \
    'sqlalchemy=1.2*' \
    'hdf5=1.10*' \
    'h5py=2.7*' \
    'vincent=0.4.*' \
    'beautifulsoup4=4.6.*' \
    'protobuf=3.*' \
    's3contents=0.1.12' \
    'xlrd' && \
    conda remove --quiet --yes --force qt pyqt && \
    conda clean -tipsy

# R packages including IRKernel which gets installed globally.
RUN conda install --quiet --yes \
    'rpy2=2.9*' \
    'r-base=3.5.1' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-tidyverse=1.2*' \
    'r-shiny=1.2*' \
    'r-rmarkdown=1.11*' \
    'r-forecast=8.2*' \
    'r-rsqlite=2.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=1.0*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    'r-htmltools=0.3*' \
    'r-sparklyr=0.9*' \
    'r-htmlwidgets=1.2*' \
    'r-hexbin=1.27*' && \
    conda clean -tipsy

# Install facets which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets

# Import matplotlib the first time to build the font cache.
RUN mkdir $HOME/.cache
ENV XDG_CACHE_HOME $HOME/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

# Install Tini
RUN conda install --quiet --yes 'tini=0.18.0' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean -tipsy

# Install Jupyter Notebook, Lab
# Generate a notebook server config
# Cleanup temporary files
RUN conda install --quiet --yes \
    'notebook=5.7.2' \
    'jupyterlab=0.31.12' && \
    conda clean -tipsy && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging

RUN wget -O- https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs

COPY --from=canvas jupyter-lti-master /jupyter-lti
RUN jupyter labextension install /jupyter-lti

# Configure container startup as root
EXPOSE 8080
WORKDIR /home/work
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

# Configure ipython kernel to use matplotlib inline backend by default
COPY jupyter_notebook_config.py $HOME/.jupyter/jupyter_notebook_config.py
COPY start-notebook.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/start-notebook.sh
