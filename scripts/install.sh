#!/bin/bash

set -e

test_env () {
  pip install -r illumidesk-jupyter/requirements-test.txt
}

install_aws_cli () {
  export PATH=$PATH:$HOME/.local/bin
  pip install awscli
}

main () {
  echo "Install test dependencies ..."
  test_env
  echo "Install aws cli ..."
  install_aws_cli
}

main
