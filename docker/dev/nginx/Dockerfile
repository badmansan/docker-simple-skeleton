FROM nginx:1.19

RUN apt-get update -y && apt-get autoremove -y

COPY ./common/nginx/conf.d /etc/nginx/conf.d

WORKDIR /app
