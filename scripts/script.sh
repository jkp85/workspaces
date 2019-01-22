#!/bin/bash

set -e

test () {
    pytest illumidesk-jupyter/tests
}

# no need to build and tag images for pull requests.
build_and_push () {
  if [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    # check if the merge is branch set with env var
    if [ "${TRAVIS_BRANCH}" == "${GITHUB_DEV_BRANCH}" ]; then
      # first build and tag docker images
      docker build --no-cache -t $DOCKER_JUPYTER_IMAGE_NAME .
      docker tag $DOCKER_JUPYTER_IMAGE_NAME $DOCKER_ORG/$DOCKER_JUPYTER_IMAGE_NAME:$GITHUB_DEV_BRANCH-$TRAVIS_BUILD_NUMBER;
      docker push $DOCKER_ORG/$DOCKER_JUPYTER_IMAGE_NAME:$GITHUB_DEV_BRANCH-$TRAVIS_BUILD_NUMBER;
      docker tag $DOCKER_JUPYTER_IMAGE_NAME $DOCKER_ORG/$DOCKER_JUPYTER_IMAGE_NAME:$GITHUB_DEV_BRANCH-latest;
      docker push $DOCKER_ORG/$DOCKER_JUPYTER_IMAGE_NAME:$GITHUB_DEV_BRANCH-latest;
    # check if the merge is branch set with env var
    elif [ "${TRAVIS_BRANCH}" == "${GITHUB_PROD_BRANCH}" ]; then
      # first build and tag docker images
      docker build --no-cache -t $DOCKER_JUPYTER_IMAGE_NAME .
      docker tag $DOCKER_JUPYTER_IMAGE_NAME $DOCKER_ORG/$DOCKER_JUPYTER_IMAGE_NAME:$GITHUB_PROD_BRANCH-$TRAVIS_BUILD_NUMBER;
      docker push $DOCKER_ORG/$DOCKER_JUPYTER_IMAGE_NAME:$GITHUB_PROD_BRANCH-$TRAVIS_BUILD_NUMBER;
      docker tag $DOCKER_JUPYTER_IMAGE_NAME $DOCKER_ORG/$DOCKER_JUPYTER_IMAGE_NAME:$GITHUB_PROD_BRANCH-latest;
      docker push $DOCKER_ORG/$DOCKER_JUPYTER_IMAGE_NAME:$GITHUB_PROD_BRANCH-latest;
    fi
  fi
}

main () {
  # linting errors shouldn't make travis fail
  set +e
  echo "Smoke test images"
  test
  echo "Build and push images..."
  build_and_push
}

main
