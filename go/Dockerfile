FROM centos:7 as base

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
 && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo \
 && sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo \
 && yum clean all && yum makecache \
 && yum install -y git gcc-c++\
 && yum clean all \
 && rm -rf /var/cache/yum \
 && rm /etc/localtime \
 && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

FROM base as go-source

RUN yum install -y wget \
 && wget https://studygolang.com/dl/golang/go1.16.5.linux-amd64.tar.gz \
 && tar -zxvf go1.16.5.linux-amd64.tar.gz

FROM base

COPY --from=go-source /go /usr/local/go
ENV PATH=$PATH:/usr/local/go/bin