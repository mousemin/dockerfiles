FROM centos:7 as base

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
 && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo \
 && sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo \
 && yum clean all && yum makecache \
 && yum install libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel  gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel crontabs libpng libpng-devel libjpeg-turbo libjpeg-turbo-devel freetype freetype-devel gd -y \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

FROM base as php-builder

RUN yum install autoconf make wget gcc-c++ git unzip -y

COPY ./scripts /scripts
RUN sh /scripts/nginx_install.sh && sh /scripts/php_install.sh 7.2.34
RUN chmod 777 /scripts/bootstrap.sh

FROM base

RUN groupadd -r nginx \
 && useradd --no-log-init --create-home -r -g nginx nginx \
 && mkdir -p /data/webdata \
 && mkdir -p /var/log/nginx \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /data/webdata

COPY --from=php-builder /usr/local/nginx /usr/local/nginx
COPY --from=php-builder /usr/local/php /usr/local/php
COPY --from=php-builder /etc/php.ini /etc/php.ini
COPY --from=php-builder /scripts/bootstrap.sh /usr/local/bin/bootstrap.sh

RUN ln -sf /usr/local/php/bin/* /usr/local/bin \
 && ln -sf /usr/local/php/sbin/php-fpm /usr/local/bin/php-fpm \
 && ln -sf /usr/local/nginx/sbin/* /usr/local/bin

CMD ["/usr/local/bin/bootstrap.sh"]

