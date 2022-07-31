include .env
export $(shell sed 's/=.*//' .env)

GIT_BRANCH = `git branch --no-color --show-current`
GIT_TAG = `git describe --tags`
IMAGE_VERSION = ${GIT_BRANCH}-${GIT_TAG}

up: docker-up
down: docker-down
restart: down up
init: docker-down-clear docker-pull docker-build up composer-install
build: down docker-build
force-rebuild: down docker-force-rebuild up

current-image-version:
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

build-prod:
	docker build --no-cache --pull --file=docker/prod/php-cli/Dockerfile --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-cli-${IMAGE_VERSION} ./
	docker build --no-cache --pull --file=docker/prod/php-fpm/Dockerfile --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-fpm-${IMAGE_VERSION} ./
	docker build --no-cache --pull --file=docker/prod/nginx/Dockerfile --tag=${REGISTRY}/${COMPOSE_PROJECT_NAME}:nginx-${IMAGE_VERSION} ./

registry-push:
	docker push ${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-cli-${IMAGE_VERSION}
	docker push ${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-fpm-${IMAGE_VERSION}
	docker push ${REGISTRY}/${COMPOSE_PROJECT_NAME}:nginx-${IMAGE_VERSION}
	docker image rm ${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-cli-${IMAGE_VERSION}
	docker image rm ${REGISTRY}/${COMPOSE_PROJECT_NAME}:php-fpm-${IMAGE_VERSION}
	docker image rm ${REGISTRY}/${COMPOSE_PROJECT_NAME}:nginx-${IMAGE_VERSION}

composer-install:
	docker compose run --rm php-cli composer install
