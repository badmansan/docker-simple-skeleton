## Set development settings for local work

### docker-compose.yml

Set available local IP & port for nginx. The last number, `80`,
is an internal nginx port. Usually you don't need to change it.

```yaml
services:
    nginx:
        ports:
            - "local-ip:local-port:80"
```

### composer.json

Don't forget to specify the minimum PHP version

```json
"require": {
    "php": ">=8.0"
}
```

### docker/dev/*/Dockerfile: nginx, php-cli, php-fpm
### docker/prod/*/Dockerfile: nginx, php-cli, php-fpm

Specify docker images. Feel free to use `-alpine` to reduce result images
size: `nginx:1.19-alpine` etc.
In this case you need use `apk` instead `apt-get` in `RUN` commands. See
[apk wiki](https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management)
for detailed info.

### Try to test

Execute `make init` in console. You shouldn't see any errors.

Try to go on `http://you-IP:you-port` in the browser. You should see a
working website.

In the future you can run composer from `php-cli` image via
`docker-compose run --rm php-cli composer ...` command.

Go on `http://you-IP:you-adminer-port`. Select your db engine, enter 
server name, user & password (default engine is PostgreSql, server `db`,
user `postgres` & password `postgres`). See additional info in
[docker hub](https://hub.docker.com) site.
