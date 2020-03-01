#!/bin/bash
#nmtui
##TODO When you add the IPs need to add to ssh known hosts
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
sed -i -e 's/node1IP/${node1_ip}/g' /etc/nginx.conf
echo Enter Node 2 IP
read node2_ip
sed -i -e 's/node2IP/${node2_ip}/g' /etc/nginx.conf
echo Enter Node 3 IP
read node3_ip
sed -i -e 's/node3IP/${node3_ip}/g' /etc/nginx.conf
docker run -d -p 5000:5000 --name registry registry:2
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v /etc/nginx.conf:/etc/nginx/nginx.conf \
  nginx:1.14
curl -LO https://github.com/rancher/rancher/releases/download/v2.3.5/rancher-images.txt
curl -LO https://github.com/rancher/rancher/releases/download/v2.3.5/rancher-save-images.sh
curl -LO https://github.com/rancher/rancher/releases/download/v2.3.5/rancher-load-images.sh
#Generate certs
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm fetch jetstack/cert-manager --version v0.9.1
helm template ./cert-manager-v0.9.1.tgz | grep -oP '(?<=image: ").*(?=")' >> ./rancher-images.txt
sort -u rancher-images.txt -o rancher-images.txt
#End cert-man
chmod +x rancher-save-images.sh
./rancher-save-images.sh --image-list ./rancher-images.txt
chmod +x rancher-load-images.sh
 ./rancher-load-images.sh --image-list ./rancher-images.txt --registry localhost:5000
curl -LO https://raw.githubusercontent.com/irvingwa/RKE_Setup/master/rancher-cluster.yml
sed -i -e 's/node1IP/${node1_ip}/g' ./rancher-cluster.yml
sed -i -e 's/node2IP/${node2_ip}/g' ./rancher-cluster.yml
sed -i -e 's/node3IP/${node3_ip}/g' ./rancher-cluster.yml
rke up --config ./rancher-cluster.yml

