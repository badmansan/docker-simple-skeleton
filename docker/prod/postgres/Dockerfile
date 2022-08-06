FROM postgres:13

RUN apt-get update -y && \
    apt-get upgrade -y --with-new-pkgs && \
    apt-get autoremove -y

COPY ./docker/common/postgres/init-user-db.sh /docker-entrypoint-initdb.d/init-user-db.sh
