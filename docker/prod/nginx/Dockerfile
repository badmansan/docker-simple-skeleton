FROM nginx:1.19

RUN apt-get update -y \
    && apt-get upgrade -y --with-new-pkgs \
    && apt-get autoremove -y

COPY ./docker/common/nginx/conf.d /etc/nginx/conf.d

WORKDIR /app/public

COPY ./app/public ./
