# multi-laravel-docker

Multiple versions of PHP and Node for Laravel development

## Disclaimer

I am just learning Docker, this is a personal test implementation and is used in my daily workflow

The idea is to have a Docker container where I can connect and run any version of Laravel (3 - 11) (I have a lot of projects since ~10 years), without need to install all on my PC
I just jump to the folder switch PHP or Node version and work on it (sudo update-alternatives --config php) (nvm use $NODE_VERSION)

## Default values

- ARG OS_PACKAGES="sudo curl unzip openssh-server git ca-certificates lsb-release libxml2-dev libpng-dev libpng-dev libz-dev libmemcached-dev telnet libpq-dev"
- ARG DEV_USER=dev
- ARG PHP_VERSIONS="5.6 7.2 7.4 8.0 8.1 8.2 8.3"
- ARG PHP_LIBRARIES="pdo mysql mbstring xmlrpc soap gd xml cli zip fpm opcache curl"

## Build with args and replace the values you need

`docker build --build-arg DEV_USER=user1 --build-args PHP_VERSIONS="7.3 8.1" -t [docker-register][/id]/devserver .`

## Run or register

`docker run --rm --name devserver -v "[code-folder]:/code/apps" -it [docker-register][/id]/devserver`
