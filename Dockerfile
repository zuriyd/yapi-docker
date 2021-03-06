FROM ubuntu:16.04

# add user group, user and make user home dir
RUN groupadd --gid 1000 yapi && \
    useradd --uid 1000 --gid yapi --shell /bin/bash --create-home yapi

# set pwd to yapi home dir
WORKDIR /home/yapi

# install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    python \
    wget \
    git \
    apt-transport-https \
    ca-certificates \
    curl \
    sudo

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    sudo apt-get install nodejs

RUN mkdir -p /home/yapi/log

RUN chown -R yapi:yapi /home/yapi/log && \
    chown -R yapi:yapi /usr/lib/node_modules

VOLUME ["/home/yapi/log"]

# download yapi source code
USER root

COPY 2019.11.15.tar.gz .
COPY config.json .

RUN mkdir yapi && \
#    wget https://github.com/YMFE/yapi/archive/v1.8.5.tar.gz && \
#    wget https://github.com/xian-crazy/yapi/archive/2019.11.15.tar.gz && \
    tar -xzvf 2019.11.15.tar.gz -C yapi --strip-components 1

# npm install dependencies and run build
WORKDIR /home/yapi/yapi

RUN npm install --registry https://registry.npm.taobao.org && \
    npm config set registry https://registry.npm.taobao.org && \
    npm install ykit -g && \
    ykit pack -m
