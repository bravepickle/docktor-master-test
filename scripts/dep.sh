#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update

DEBIAN_FRONTEND=noninteractive

apt-get -y install curl wget

# Deploy docker master app
# run as root

# Try installing docker if not installed yet
echo Setup Docker
docker --version || (\
    #apt-get update && \
    apt-get install wget -y && \
    (wget -qO- https://get.docker.com/ | sh) && \
    usermod -aG docker vagrant)

# Install puppet
echo Setup Puppet
puppet --version || (\
    cd /tmp && \
    wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
    dpkg -i puppetlabs-release-trusty.deb && \
    apt-get update && \
    apt-get install puppet-common -y && \
    puppet --version)

echo Setup Docker Compose
docker-compose --version || (\
    curl -L https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose)

echo Setup SupervisorD
supervisord --version || (apt-get install supervisor -y)

echo Setup NGINX
nginx -v || (wget -q http://nginx.org/keys/nginx_signing.key -O- | apt-key add - && \
    echo deb http://nginx.org/packages/ubuntu/ trusty nginx >> /etc/apt/sources.list && \
    echo deb-src http://nginx.org/packages/ubuntu/ trusty nginx >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    sed -i -e"s/worker_processes  1/worker_processes 5/" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    sed -i "s/.*conf\.d\/\*\.conf;.*/&\n    include \/etc\/nginx\/sites-enabled\/\*;/" /etc/nginx/nginx.conf && \
    rm -Rf /etc/nginx/conf.d/* && \
    mkdir -p /etc/nginx/sites-available/ && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /etc/nginx/ssl/ && \
    nginx -v)
