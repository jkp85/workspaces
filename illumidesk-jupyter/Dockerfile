# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Copyright (c) IllumiDesk.
# Distributed under the terms of the Modified BSD License.

# set up base image arg
ARG BASE_IMAGE=jupyter/datascience-notebook
FROM $BASE_IMAGE

LABEL maintainer="IllumiDesk <hello@illumidesk.com>"

# base image should have $NB_UID already set, but set it
# explicitly just in case
USER $NB_UID

# install nodejs kernel
RUN conda install -c conda-forge nodejs
RUN npm install -g ijavascript

# Xeus Cling
RUN conda install --quiet --yes \
  -c QuantStack \
  -c conda-forge \
  xeus-cling && \
  conda clean -tipsy

# install jupyter-lti extension
RUN jupyter labextension install @illumidesknow/jupyter-lti

# copy/install as root, then fix permissions for $NB_USER
USER root

COPY --from=canvas jupyter-lti-master /jupyter-lti
RUN jupyter labextension install /jupyter-lti
COPY jupyter_notebook_config.py /etc/jupyter/

RUN fix-permissions /etc/jupyter/
RUN fix-permissions /jupyter-lti

# set container to run with $NB_USER by default
USER $NB_UID