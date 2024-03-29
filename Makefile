include .env
export $(shell sed 's/=.*//' .env)

GIT_BRANCH = $(shell git branch --no-color --show-current | sed 's/\//./g')
GIT_TAG = $(shell git describe --tags)
IMAGE_VERSION = ${GIT_BRANCH}-${GIT_TAG}

up: docker-up
down: docker-down
restart: down up
init: docker-down-clear docker-pull docker-build up composer-install
build: down docker-build
force-rebuild: down docker-force-rebuild up
production-update: production-build production-registry-push production-deploy
production-update-alpine: production-build-alpine production-registry-push production-deploy

show-current-image-version:
	echo ${IMAGE_VERSION}

docker-up:
	docker compose up -d

docker-down:
	docker compose down --remove-orphans

docker-down-clear:
	docker compose down -v --remove-orphans

docker-pull:
	docker compose pull

docker-build:
	docker compose build

docker-force-rebuild:
	docker compose build --no-cache --pull

production-build:
	docker build --no-cache --pull --file=docker/prod/nginx/Dockerfile --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:nginx-${IMAGE_VERSION} ./
	docker build --no-cache --pull --file=docker/prod/postgres/Dockerfile --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:postgres-${IMAGE_VERSION} ./
	docker build --no-cache --pull --file=docker/prod/php-cli/Dockerfile --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-cli-${IMAGE_VERSION} ./
	docker build --no-cache --pull --file=docker/prod/php-fpm/Dockerfile --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-fpm-${IMAGE_VERSION} ./

production-build-alpine:
	docker build --no-cache --pull --file=docker/prod/nginx/Dockerfile-alpine --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:nginx-${IMAGE_VERSION} ./
	docker build --no-cache --pull --file=docker/prod/postgres/Dockerfile-alpine --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:postgres-${IMAGE_VERSION} ./
	docker build --no-cache --pull --file=docker/prod/php-cli/Dockerfile-alpine --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-cli-${IMAGE_VERSION} ./
	docker build --no-cache --pull --file=docker/prod/php-fpm/Dockerfile-alpine --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-fpm-${IMAGE_VERSION} ./

production-registry-push:
	docker push ${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-cli-${IMAGE_VERSION}
	docker push ${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-fpm-${IMAGE_VERSION}
	docker push ${REGISTRY}/${COMPOSE_PROJECT_NAME}:nginx-${IMAGE_VERSION}
	docker push ${REGISTRY}/${COMPOSE_PROJECT_NAME}:postgres-${IMAGE_VERSION}
	docker image rm ${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-cli-${IMAGE_VERSION}
	docker image rm ${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-fpm-${IMAGE_VERSION}
	docker image rm ${REGISTRY}/${COMPOSE_PROJECT_NAME}:nginx-${IMAGE_VERSION}
	docker image rm ${REGISTRY}/${COMPOSE_PROJECT_NAME}:postgres-${IMAGE_VERSION}

production-deploy:
	ssh ${HOST} 'rm -rf ${COMPOSE_PROJECT_NAME}-${IMAGE_VERSION}'
	ssh ${HOST} 'mkdir ${COMPOSE_PROJECT_NAME}-${IMAGE_VERSION}'
	scp docker-compose-production.yml ${HOST}:${COMPOSE_PROJECT_NAME}-${IMAGE_VERSION}/docker-compose.yml
	scp docker/prod/bash/remove-docker-images.sh ${HOST}:${COMPOSE_PROJECT_NAME}-${IMAGE_VERSION}
	scp .env.production ${HOST}:${COMPOSE_PROJECT_NAME}-${IMAGE_VERSION}/.env
	ssh ${HOST} 'cd ${COMPOSE_PROJECT_NAME}-${IMAGE_VERSION} && printf "\nIMAGE_VERSION=${IMAGE_VERSION}\n" >> .env'
	ssh ${HOST} 'cd ${COMPOSE_PROJECT_NAME}-${IMAGE_VERSION} && docker compose pull'
	ssh ${HOST} 'cd ${COMPOSE_PROJECT_NAME}-${IMAGE_VERSION} && docker compose up --build --remove-orphans -d'
	ssh ${HOST} 'rm -f ${COMPOSE_PROJECT_NAME}-latest'
	ssh ${HOST} 'ln -sr ${COMPOSE_PROJECT_NAME}-${IMAGE_VERSION} ${COMPOSE_PROJECT_NAME}-latest'

composer-install:
	docker compose run --rm php-cli composer install
