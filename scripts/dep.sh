#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update

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
nginx --version || (apt-get install nginx -y) && nginx --version