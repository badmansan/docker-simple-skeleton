PROJECT_NAME=test

up: docker-up
down: docker-down
restart: down up
init: docker-down docker-pull docker-build docker-up composer-install

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build

build-prod:
	docker --log-level=debug build --pull --file=docker/prod/php-cli/Dockerfile --tag=${REGISTRY}/$(PROJECT_NAME)-php-cli:${IMAGE_TAG} ./
	docker --log-level=debug build --pull --file=docker/prod/php-fpm/Dockerfile --tag=${REGISTRY}/$(PROJECT_NAME)-php-fpm:${IMAGE_TAG} ./
	docker --log-level=debug build --pull --file=docker/prod/nginx/Dockerfile --tag=${REGISTRY}/$(PROJECT_NAME)-nginx:${IMAGE_TAG} ./

try-build:
	-docker rmi localhost/$(PROJECT_NAME)-php-cli:0 localhost/$(PROJECT_NAME)-php-fpm:0 localhost/$(PROJECT_NAME)-nginx:0
	REGISTRY=localhost IMAGE_TAG=0 make build-prod

composer-install:
	docker-compose run --rm php-cli composer install
