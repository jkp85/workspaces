#!/bin/bash

set -e

docker_login () {
    docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
}

# no need to build and tag images for pull requests.
tag_and_push () {
  if [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    if [ "${TRAVIS_BRANCH}" == "${GITHUB_DEV_BRANCH}" ]; then
      export TAG="${GITHUB_DEV_BRANCH}"-"${TRAVIS_BUILD_NUMBER}"
      make push-all;
    elif [ "${TRAVIS_BRANCH}" == "${GITHUB_PROD_BRANCH}" ]; then
      export TAG="${GITHUB_PROD_BRANCH}"-"${TRAVIS_BUILD_NUMBER}"
      make push-all;
    fi
  fi
}

main () {
  # linting errors shouldn't make travis fail
  set +e
  echo "Log into DockerHub..."
  docker_login
  echo "Build and push images..."
  tag_and_push
}

main
