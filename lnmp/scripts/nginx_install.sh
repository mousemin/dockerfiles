#!/bin/bash
version=1.14.2
if [ "$1" != "" ]
then
    version=$1
fi

pwd=$(cd "$(dirname "$0")";pwd)

wget -O nginx-$version.tar.gz http://nginx.org/download/nginx-$version.tar.gz
tar -zxvf nginx-$version.tar.gz && cd nginx-$version
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-file-aio --with-http_realip_module --user=nginx --group=nginx 
make && make install 
mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak 
mv $pwd/nginx.conf /usr/local/nginx/conf/nginx.conf
mkdir -p /usr/local/nginx/conf/conf.d