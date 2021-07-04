#!/bin/bash

/usr/local/php/sbin/php-fpm
exec /usr/local/nginx/sbin/nginx -g "daemon off;"