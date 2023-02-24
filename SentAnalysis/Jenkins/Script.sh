#!/bin/bash
sudo apt-get install -y \
     apt-transport-htts \
     ca-certificates \
     curl \
     software-properties-common

curl -fsSL https://yum.dockerproject.org/gpg | apt-key add -

sudo    add-apt-repostiory \
        "deb https://apt.dockerproject.org/repo/ \
        ubuntu-$(lsb_release -cs) \
        main"

sudo apt-get update
sudo apt-get -y install docker-engine
sudo groupadd docker
sudo usermod -aG docker $USER