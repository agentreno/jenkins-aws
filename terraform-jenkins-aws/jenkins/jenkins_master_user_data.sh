#!/bin/bash
set -x

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
add-apt-repository "deb https://pkg.jenkins.io/debian-stable binary/"
apt-get update
apt-get -y install default-jre
apt-get -y install jenkins
