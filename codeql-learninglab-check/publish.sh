#! /bin/bash

set -e
set -x

echo ${GITHUB_TOKEN} | docker login docker.pkg.github.com -u github-actions --password-stdin

PREV_IMAGE_VERSION=v1.0.0
IMAGE_VERSION=v1.1.0
IMAGE_PATH=docker.pkg.github.com/github/codeql-learninglab-actions/codeql-learninglab-check
IMAGE_TAG=${IMAGE_PATH}:${IMAGE_VERSION}

# Pull the previous image to optimise build and skip uneccesary steps and share
# more of the image with previous versions
docker pull ${IMAGE_PATH}:${PREV_IMAGE_VERSION}

if docker pull $IMAGE_TAG; then
  echo "image tag already exist, skipping..."
else
  echo "image has not yet been published. building and publishing..."

  docker build -t $IMAGE_TAG .

  docker push $IMAGE_TAG
fi
