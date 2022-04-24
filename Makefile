PROJECT_NAME=test

up: docker-up
down: docker-down
restart: down up
init: docker-down-clear docker-pull docker-build up composer-install
build: down docker-build
force-rebuild: down docker-force-rebuild up

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build

docker-force-rebuild:
	docker-compose build --no-cache --pull

build-prod:
	docker --log-level=debug build --pull --file=docker/prod/php-cli/Dockerfile --tag=${REGISTRY}/$(PROJECT_NAME)-php-cli:${IMAGE_TAG} ./
	docker --log-level=debug build --pull --file=docker/prod/php-fpm/Dockerfile --tag=${REGISTRY}/$(PROJECT_NAME)-php-fpm:${IMAGE_TAG} ./
	docker --log-level=debug build --pull --file=docker/prod/nginx/Dockerfile --tag=${REGISTRY}/$(PROJECT_NAME)-nginx:${IMAGE_TAG} ./

try-build:
	-docker rmi localhost/$(PROJECT_NAME)-php-cli:0 localhost/$(PROJECT_NAME)-php-fpm:0 localhost/$(PROJECT_NAME)-nginx:0
	REGISTRY=localhost IMAGE_TAG=0 make build-prod

composer-install:
	docker-compose run --rm php-cli composer install
