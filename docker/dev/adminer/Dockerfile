FROM adminer:latest

USER root
RUN apk add mc
COPY ./dev/adminer/php.ini $PHP_INI_DIR/conf.d/999-owerrided-php-settings.ini

USER adminer
WORKDIR /var/www/html

COPY ./dev/adminer/adminer.css ./

COPY ./dev/adminer/plugins ./plugins
COPY ./dev/adminer/plugins-enabled ./plugins-enabled
