FROM php:7.2-fpm

RUN apt-get update -y && apt-get autoremove -y

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

COPY ./common/php/conf.d /usr/local/etc/php/conf.d

WORKDIR /app
