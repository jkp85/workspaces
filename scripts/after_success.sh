#!/bin/bash

set -e

# no need to build and tag images for pull requests.
tag_and_push () {
  docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD ;
  if [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    if [ "${TRAVIS_BRANCH}" == "${GITHUB_DEV_BRANCH}" ]; then
      export TAG="${GITHUB_DEV_BRANCH}"-latest
      make push-all;
    # check if the merge is branch set with env var
    elif [ "${TRAVIS_BRANCH}" == "${GITHUB_PROD_BRANCH}" ]; then
      export TAG="${GITHUB_PROD_BRANCH}"-latest
      # first build and tag docker images
      make push-all;
    fi
  fi
}

main () {
  # linting errors shouldn't make travis fail
  set +e
  echo "Build and push images..."
  tag_and_push
}

main
