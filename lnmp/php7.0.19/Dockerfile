FROM centos:7 as Base

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
 && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo \
 && sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo \
 && yum clean all && yum makecache \
 && yum install libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel  gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel crontabs libpng libpng-devel libjpeg-turbo libjpeg-turbo-devel freetype freetype-devel gd -y \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

FROM Base as phpBuilder
RUN yum install wget gcc-c++ make autoconf git unzip -y

# 安装nginx
RUN wget -O nginx-1.14.2.tar.gz http://nginx.org/download/nginx-1.14.2.tar.gz \
 && tar -zxvf nginx-1.14.2.tar.gz && cd nginx-1.14.2 \
 && ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-file-aio --with-http_realip_module --user=nginx --group=nginx \
 && make && make install \
 && mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak \
 && echo 'user  nginx;' > /usr/local/nginx/conf/nginx.conf \
 && echo 'worker_processes  1;' >> /usr/local/nginx/conf/nginx.conf \
 && echo 'error_log  /var/log/nginx/error.log warn;' >> /usr/local/nginx/conf/nginx.conf \
 && echo 'pid        /var/run/nginx.pid;' >> /usr/local/nginx/conf/nginx.conf \
 && echo 'events {' >> /usr/local/nginx/conf/nginx.conf \
 && echo '    worker_connections  1024;' >> /usr/local/nginx/conf/nginx.conf \
 && echo '}' >> /usr/local/nginx/conf/nginx.conf \
 && echo 'http {' >> /usr/local/nginx/conf/nginx.conf \
 && echo '    server_tokens    off;' >> /usr/local/nginx/conf/nginx.conf \
 && echo '    include       mime.types;' >> /usr/local/nginx/conf/nginx.conf \
 && echo '    default_type  application/octet-stream;' >> /usr/local/nginx/conf/nginx.conf \
 && echo "    log_format  main  '\$remote_addr - \$remote_user [\$time_local] \"\$request\" '" >> /usr/local/nginx/conf/nginx.conf \
 && echo "                      '\$status \$body_bytes_sent \"\$http_referer\" '" >> /usr/local/nginx/conf/nginx.conf \
 && echo "                      '\"\$http_user_agent\" \"\$http_x_forwarded_for\"';" >> /usr/local/nginx/conf/nginx.conf \
 && echo '    access_log  /var/log/nginx/access.log  main;' >> /usr/local/nginx/conf/nginx.conf \
 && echo '    sendfile        on;' >> /usr/local/nginx/conf/nginx.conf \
 && echo '    keepalive_timeout  65;' >> /usr/local/nginx/conf/nginx.conf \
 && echo '    include /usr/local/nginx/conf/conf.d/*.conf;' >> /usr/local/nginx/conf/nginx.conf \
 && echo '}' >> /usr/local/nginx/conf/nginx.conf \
 && mkdir -p /usr/local/nginx/conf/conf.d

# 安装PHP
RUN wget -O php-7.0.19.tar.gz https://www.php.net/get/php-7.0.19.tar.gz/from/this/mirror \
 && tar -zxvf php-7.0.19.tar.gz \
 && cd php-7.0.19 \
 && ./configure --prefix=/usr/local/php --with-config-file-path=/etc --enable-fpm --with-fpm-user=nginx --with-fpm-group=nginx --enable-inline-optimization --disable-debug --disable-rpath --enable-shared --enable-soap --with-libxml-dir --with-xmlrpc --with-openssl --with-mhash --with-pcre-regex --with-sqlite3 --with-zlib --enable-bcmath --with-iconv --with-bz2 --enable-calendar --with-curl --with-cdb --enable-dom --enable-exif --enable-fileinfo --enable-filter --with-pcre-dir --enable-ftp --with-openssl-dir --with-zlib-dir --with-freetype-dir --with-gettext --with-gmp --with-mhash --enable-json --enable-mbstring --enable-mbregex --enable-mbregex-backtrack --with-libmbfl --with-onig --enable-pdo --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pdo-sqlite --with-readline --enable-session --enable-shmop --enable-simplexml --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --with-libxml-dir --with-xsl --enable-zip --enable-mysqlnd-compression-support --with-pear --enable-opcache --with-gd --with-jpeg-dir --with-png-dir \
 && make && make install \
 && cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf \
 && cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf

ENV PATH=$PATH:/usr/local/php/bin:/sur/local/php/sbin/

RUN cp /php-7.0.19/php.ini-production /etc/php.ini \
 && sed -i -e 's/expose_php = On/expose_php=Off/g' /etc/php.ini \
 && sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 1024M/g' /etc/php.ini \
 && sed -i -e 's/post_max_size = 8M/post_max_size = 1024M/g' /etc/php.ini \
 && sed -i -e 's/;date.timezone =/date.timezone = Asia\/Shanghai/g' /etc/php.ini \
 && sed -i -e 's/memory_limit = 128M/memory_limit = -1/g' /etc/php.ini \
 && sed -i -e 's/;clear_env = no/clear_env = no/g' /usr/local/php/etc/php-fpm.d/www.conf

RUN echo '#!/bin/bash' > /usr/local/bin/bootstrap.sh \
 && echo '/usr/local/php/sbin/php-fpm' >> /usr/local/bin/bootstrap.sh \
 && echo 'exec /usr/local/nginx/sbin/nginx -g "daemon off;"' >> /usr/local/bin/bootstrap.sh \
 && chmod 777 /usr/local/bin/bootstrap.sh

FROM Base as phpBase

COPY --from=phpBuilder /usr/local/nginx /usr/local/nginx
COPY --from=phpBuilder /usr/local/php /usr/local/php
COPY --from=phpBuilder /etc/php.ini /etc/php.ini
RUN groupadd -r nginx \
 && useradd --no-log-init --create-home -r -g nginx nginx \
 && mkdir -p /data/webdata \
 && mkdir -p /var/log/nginx \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

ENV PATH=$PATH:/usr/local/php/bin:/usr/local/php/sbin/php-fpm:/usr/local/nginx/sbin


