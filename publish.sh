#!/bin/sh

PRODUCT_NAME=wincognito/caddy-reverse-proxy
PRODUCT_REGISTRY=docker.io
PRODUCT_VERSION=$(cat version)


#DOCKER_TOKEN_OR_PASSWORD=
DOCKER_USERNAME=wincognito

test -z $DOCKER_TOKEN_OR_PASSWORD && echo "Please define DOCKER_TOKEN_OR_PASSWORD." && exit 1




# Exit after error
set -e

# Expand variables, show commands
set -x


pwd
git checkout main

GIT_HASH=$(git log -1 --pretty=format:"%h")
GIT_DATE=$(git log -1 --pretty='%cd' --date=format:'%Y-%m-%d')
MAJOR=$(echo "$PRODUCT_VERSION"|awk -F '.'  '{print $1}')
MINOR=$(echo "$PRODUCT_VERSION"|awk -F '.'  '{print $2}')
PATCH=$(echo "$PRODUCT_VERSION"|awk -F '.'  '{print $3}')



buildah bud \
-f Dockerfile \
-t $PRODUCT_REGISTRY/$PRODUCT_NAME:latest \
-t $PRODUCT_REGISTRY/$PRODUCT_NAME:$MAJOR.$MINOR.$PATCH \
-t $PRODUCT_REGISTRY/$PRODUCT_NAME:$MAJOR.$MINOR \
-t $PRODUCT_REGISTRY/$PRODUCT_NAME:$MAJOR \
-t $PRODUCT_REGISTRY/$PRODUCT_NAME:$GIT_HASH \
.


podman login \
-p $DOCKER_TOKEN_OR_PASSWORD \
-u $DOCKER_USERNAME



podman push $PRODUCT_REGISTRY/$PRODUCT_NAME:latest
podman push $PRODUCT_REGISTRY/$PRODUCT_NAME:$MAJOR.$MINOR.$PATCH
podman push $PRODUCT_REGISTRY/$PRODUCT_NAME:$MAJOR.$MINOR
podman push $PRODUCT_REGISTRY/$PRODUCT_NAME:$MAJOR
podman push $PRODUCT_REGISTRY/$PRODUCT_NAME:$GIT_HASH



podman logout $PRODUCT_REGISTRY