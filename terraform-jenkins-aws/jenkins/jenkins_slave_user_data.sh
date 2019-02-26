#!/bin/bash
set -x

# Install Java runtime
apt-get update
apt-get -y install default-jre

# Install Docker for pipelines
apt update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
apt update
apt install -y docker-ce

# Give ubuntu user access to Docker
usermod -aG docker ubuntu
