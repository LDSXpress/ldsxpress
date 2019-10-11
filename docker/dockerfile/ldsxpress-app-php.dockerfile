FROM php:7.3.9-fpm-alpine

LABEL author="Daniel A. Olivas Rivera"

ARG WORKDIR=/var/www/ldsxpress

############
# packages #
############
RUN apk update \
    && apk upgrade \
    && apk add php7-pdo php7-mysqli php7-pdo_mysql

# Add user for laravel application
RUN addgroup -S www
RUN adduser -S www -G www

# Copy existing application directory contents
COPY ./ldsxpress/api ${WORKDIR}

# Copy existing application directory permissions
COPY --chown=www:www ./ldsxpress/api ${WORKDIR}

# Tell docker that all future commands should run as the www user
USER www

WORKDIR ${WORKDIR}
