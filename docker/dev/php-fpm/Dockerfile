FROM php:7.4-fpm

RUN apt-get update -y

# PHP intl extension
RUN apt-get install -y libicu-dev && \
    docker-php-ext-install intl

# PHP PostgreSQL extension
RUN apt-get install -y libpq-dev && \
    docker-php-ext-install pdo_pgsql pgsql

# xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# PHP_INI_DIR is set inside php image
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

COPY ./common/php/conf.d $PHP_INI_DIR/conf.d

WORKDIR /app
