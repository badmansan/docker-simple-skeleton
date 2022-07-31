FROM php:7.4-cli

RUN apt-get update -y

# PHP intl extension
RUN apt-get install -y libicu-dev && \
    docker-php-ext-install intl

# PHP PostgreSQL extension
RUN apt-get install -y libpq-dev && \
    docker-php-ext-install pdo_pgsql pgsql

# unzip need by composer
RUN apt-get install unzip -y

RUN apt-get autoremove -y

# PHP_INI_DIR is set inside php image
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

COPY ./common/php/conf.d $PHP_INI_DIR/conf.d

ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet

WORKDIR /app
