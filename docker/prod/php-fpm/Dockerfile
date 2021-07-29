FROM php:7.2-fpm

RUN apt-get update -y \
    && apt-get install unzip -y \
    && apt-get upgrade -y --with-new-pkgs \
    && apt-get autoremove -y

RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

COPY ./docker/common/php/conf.d /usr/local/etc/php/conf.d

ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet

WORKDIR /app

COPY ./app ./

RUN composer install --no-dev --prefer-dist --no-progress --optimize-autoloader \
    && rm -rf /root/.composer/cache
