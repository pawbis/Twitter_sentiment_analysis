#!/bin/bash
apt-get install -y \
apt-transport-htts \
ca-certificates \
curl \
software-properties-common

curl -fsSL https://yum.dockerproject.org/gpg | apt-key add -

add-apt-repostiory \
    "deb https://apt.dockerproject.org/repo/ \
    ubuntu-$(lsb_release -cs) \
    main"

apt-get update
apt-get -y install docker-engine
groupadd docker
usermod -aG docker $USER
systemctl enable docker