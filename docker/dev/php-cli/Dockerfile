FROM php:7.2-cli

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
RUN apt-get update -y \
#    && apt upgrade -y \ # production only
    && apt-get install unzip -y

COPY ./common/php/conf.d /usr/local/etc/php/conf.d

ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet

WORKDIR /app
