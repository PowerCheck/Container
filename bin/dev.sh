#!/bin/sh

# Create the default settings.env if it does not exist
if [ ! -f conf/settings.env ]; then
  echo settings.env not found, using defaults.
  cp conf/settings.default.env conf/settings.env
fi

# Load container setup variables
for f in `cat conf/settings.env | grep -v "#"`; do export $f; done

# Define the image source
export IMAGE_SOURCE=${IMAGE_NAME}
[ ${PRIVATE_REGISTRY} ] && export IMAGE_SOURCE=${PRIVATE_REGISTRY}/${IMAGE_NAME}

docker run \
-it \
--rm \
-v ${CONTAINER_ROOT}/volumes/web:/opt/web \
-v ${CONTAINER_ROOT}/volumes/api:/opt/api \
-p 7080:80 \
-p 8080:8080 \
-p 8081:8081 \
--name ${CONTAINER_NAME}-dev \
${IMAGE_SOURCE}:${IMAGE_TAG} /bin/sh
