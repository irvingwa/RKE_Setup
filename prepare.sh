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
curl -LO https://raw.githubusercontent.com/irvingwa/RKE_Setup/master/nginx.conf
mv nginx.conf /etc/nginx.conf
echo Enter Node 1 IP
read node1_ip
sed -i -e 's/node1IP/$node1_ip/g' /etc/nginx.conf
echo Enter Node 2 IP
read node2_ip
sed -i -e 's/node2IP/$node2_ip/g' /etc/nginx.conf
echo Enter Node 3 IP
read node3_ip
sed -i -e 's/node3IP/$node3_ip/g' /etc/nginx.conf
docker run -d -p 5000:5000 --name registry registry:2
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v /etc/nginx.conf:/etc/nginx/nginx.conf \
  nginx:1.14
