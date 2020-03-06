#!/bin/bash
echo Enter Node 1 IP
read node1_ip
echo Enter Node 2 IP
read node2_ip
echo Enter Node 3 IP
read node3_ip
yum -y install docker
service docker start
docker pull registry:2
docker pull  nginx:1.14
curl -LO https://raw.githubusercontent.com/irvingwa/RKE_Setup/master/nginx.conf
mv nginx.conf /etc/nginx.conf

sed -i -e "s|node1IP|${node1_ip}|g" /etc/nginx.conf

sed -i -e "s|node2IP|${node2_ip}|g" /etc/nginx.conf

sed -i -e "s|node3IP|${node3_ip}|g" /etc/nginx.conf
docker stop nginx
docker stop registry
docker rm nginx
docker rm registry
docker run -d -p 5000:5000 --name registry registry:2
docker run -d --name nginx --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v /etc/nginx.conf:/etc/nginx/nginx.conf \
  nginx:1.14
