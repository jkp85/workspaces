# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Copyright (c) IllumiDesk.
# Distributed under the terms of the Modified BSD License.

# set up base image arg
ARG BASE_IMAGE=jupyter/datascience-notebook
FROM $BASE_IMAGE

LABEL maintainer="IllumiDesk <hello@illumidesk.com>"

USER root

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# base image should have $NB_UID already set, but set it
# explicitly just in case
USER $NB_UID

# Install Tensorflow
RUN conda install --quiet --yes \
    'tensorflow=1.12*' \
    'keras=2.2*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# install nodejs kernel
RUN conda install -c conda-forge nodejs
RUN npm install -g ijavascript
RUN ijsinstall

# Xeus Cling
RUN conda install -c conda-forge xeus-cling && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# install jupyter-lti extension
RUN jupyter labextension install @illumidesk/jupyter-lti

# copy/install as root, then fix permissions for $NB_USER
USER root

RUN jupyter labextension install @illumidesk/jupyter-lti
COPY jupyter_notebook_config.py /etc/jupyter/
COPY env_test.ipynb $HOME/
RUN fix-permissions /etc/jupyter/

# set container to run with $NB_USER by default
USER $NB_UID
