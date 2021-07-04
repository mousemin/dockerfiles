#!/bin/bash
version=1.14.2
if [ $1 != "" ]
then
    version=$1
fi

pwd=$(cd "$(dirname "$0")";pwd)

wget -O php-$version.tar.gz https://www.php.net/get/php-$version.tar.gz/from/this/mirror 
tar -zxvf php-$version.tar.gz 
cd php-$version 
./configure --prefix=/usr/local/php --with-config-file-path=/etc --enable-fpm --with-fpm-user=nginx --with-fpm-group=nginx --enable-inline-optimization --disable-debug --disable-rpath --enable-shared --enable-soap --with-libxml-dir --with-xmlrpc --with-openssl --with-mhash --with-pcre-regex --with-sqlite3 --with-zlib --enable-bcmath --with-iconv --with-bz2 --enable-calendar --with-curl --with-cdb --enable-dom --enable-exif --enable-fileinfo --enable-filter --with-pcre-dir --enable-ftp --with-openssl-dir --with-zlib-dir --with-freetype-dir --with-gettext --with-gmp --with-mhash --enable-json --enable-mbstring --enable-mbregex --enable-mbregex-backtrack --with-libmbfl --with-onig --enable-pdo --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pdo-sqlite --with-readline --enable-session --enable-shmop --enable-simplexml --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --with-libxml-dir --with-xsl --enable-zip --enable-mysqlnd-compression-support --with-pear --enable-opcache --with-gd --with-jpeg-dir --with-png-dir
make && make install 
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf

cp php.ini-production /etc/php.ini

