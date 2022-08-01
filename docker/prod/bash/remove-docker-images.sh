#!/usr/bin/env sh

eval "$(cat .env)"

docker image rm "${REGISTRY}"/"${COMPOSE_PROJECT_NAME}":php-cli-"${IMAGE_VERSION}"
docker image rm "${REGISTRY}"/"${COMPOSE_PROJECT_NAME}":php-fpm-"${IMAGE_VERSION}"
docker image rm "${REGISTRY}"/"${COMPOSE_PROJECT_NAME}":nginx-"${IMAGE_VERSION}"
docker image rm "${REGISTRY}"/"${COMPOSE_PROJECT_NAME}":postgres-"${IMAGE_VERSION}"
