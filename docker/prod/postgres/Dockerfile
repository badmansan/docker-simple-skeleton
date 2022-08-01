FROM postgres:13-alpine

RUN apk update && \
    apk upgrade --no-cache

COPY ./docker/common/postgres/init-user-db.sh /docker-entrypoint-initdb.d/init-user-db.sh
