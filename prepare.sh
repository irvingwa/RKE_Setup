#!/bin/bash
#nmtui
yum -y install docker
service docker start
docker pull registry:2
docker pull  nginx:1.14
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
curl -LO https://github.com/rancher/rke/releases/download/v1.0.4/rke_linux-amd64
mv rke_linux-amd64 rke
chmod +x rke
sudo mv ./rke /usr/local/bin/rke
curl -LO https://get.helm.sh/helm-v3.1.1-linux-amd64.tar.gz
tar -zxvf helm-v3.1.1-linux-amd64.tar.gz
chmod +x linux-amd64/helm
mv linux-amd64/helm /usr/local/bin/helm
