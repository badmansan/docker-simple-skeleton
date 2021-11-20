# make /vendor folder by composer
FROM php:7.2-cli AS vendor-builder

RUN apt-get update -y && apt-get install unzip -y

ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet

WORKDIR /app

COPY ./app/composer.json ./app/composer.lock ./

RUN composer install --no-dev --prefer-dist --no-progress --optimize-autoloader

# build result container
FROM php:7.2-fpm

RUN apt-get update -y

# PHP intl extension
RUN apt-get install -y libicu-dev && \
    docker-php-ext-install intl

# PHP PostgreSQL extension
RUN apt-get install -y libpq-dev && \
    docker-php-ext-install pdo_pgsql pgsql

# PHP opcache
RUN docker-php-ext-install opcache

RUN apt-get autoremove -y

# PHP_INI_DIR is set inside php image
RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

COPY ./docker/common/php/conf.d /usr/local/etc/php/conf.d
COPY ./docker/prod/php/conf.d /usr/local/etc/php/conf.d

WORKDIR /app

COPY --from=vendor-builder ./app ./
COPY ./app ./

