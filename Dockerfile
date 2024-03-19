# Author: Alex Vergara
# Description: This file contains the Dockerfile for the PHP image
# Version: 1.0


# Use the official image as a parent image // TODO: Check for a smaller image?
FROM ubuntu:22.04

# Set default parameters
ARG OS_PACKAGES="sudo curl unzip openssh-server git ca-certificates lsb-release libxml2-dev libpng-dev libpng-dev libz-dev libmemcached-dev telnet libpq-dev"
ARG DEV_USER=dev
ARG PHP_VERSIONS="5.6 7.2 7.4 8.0 8.1 8.2 8.3"
ARG PHP_LIBRARIES="pdo mysql mbstring xmlrpc soap gd xml cli zip fpm opcache curl"
ARG NODE_VERSIONS="10 12 18 21"

# Avoid user interaction
ARG DEBIAN_FRONTEND=noninteractive

# Update the image
RUN apt-get update

# Install required packages
RUN apt-get install -y software-properties-common ${OS_PACKAGES} \
  && rm -rf /var/lib/{apt,dpkg,cache,log}



# PHP -----------------------------------------

# Add PHP repository
RUN add-apt-repository ppa:ondrej/php

# Update the image
RUN apt-get update

# Install PHP versions and libraries
RUN for php in ${PHP_VERSIONS}; do for lib in ${PHP_LIBRARIES}; do apt-get install -y php${php}-${lib}; done; done


# GET latest Composer version 1.10
RUN curl -sS https://getcomposer.org/download/1.10.19/composer.phar -o composer.phar
RUN mv composer.phar /usr/local/bin/composer1 && chmod 755 /usr/local/bin/composer1

# GET latest Composer version
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer2
RUN curl -sS https://getcomposer.org/download/2.7.2/composer.phar -o composer.phar
RUN mv composer.phar /usr/local/bin/composer2 && chmod 755 /usr/local/bin/composer2



# User -----------------------------------------

# Create dev_user and group, set password as ${DEV_USER}
RUN groupadd -g 1000 ${DEV_USER}
RUN useradd -u 1000 -g ${DEV_USER} -m ${DEV_USER} -s /usr/bin/bash && echo "${DEV_USER}:${DEV_USER}" | chpasswd && adduser ${DEV_USER} sudo

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /home/${DEV_USER}/.bashrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /home/${DEV_USER}/.bashrc
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> /home/${DEV_USER}/.bashrc

RUN echo 'alias art="php artisan"' >> /hom/${DEV_USER}/.bashrc
RUN echo 'alias serve="php artisan serve --host 0.0.0.0"' >> /hom/${DEV_USER}/.bashrc



# Working directory
RUN mkdir -p /code/apps

# Change the working directory permissions to dev_user
RUN chown -R ${DEV_USER}:${DEV_USER} /code

# Expose ports (allow multiple services at the same time [php artisan serve --port=8002])
EXPOSE 8000-8010



# Switch to the dev user to run next commands and login shell
USER "${DEV_USER}"

# Set the working directory
WORKDIR /code/apps



# Node -----------------------------------------

# Install NVM - Node Version Manager..... (switch Node version [nvim use 10])
# Execute commands as a dev_user's login shell
SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Install Node versions
RUN source /home/${DEV_USER}/.bashrc && for node in ${NODE_VERSIONS}; do nvm install ${node}; done


# // TODO:: Add node global libraries (expo? vite?)

