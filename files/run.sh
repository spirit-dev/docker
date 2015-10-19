#!/bin/sh

if [ ! -d /DATA ] ; then
  mkdir -p /DATA
fi

/run_app_preparation.sh

chown -R nginx:www-data /DATA
chmod -R 777 /DATA/app/cache
chmod -R 777 /DATA/app/logs

# start php-fpm
mkdir -p /DATA/app/logs/php-fpm
php-fpm

# start nginx
mkdir -p /DATA/logs/nginx
mkdir -p /tmp/nginx
chown nginx /tmp/nginx

echo "=> RUNNING NGINX"

nginx
