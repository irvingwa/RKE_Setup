#!/bin/bash
#Virtual Box  Look for "ONBOOT=yes" in /etc/sysconfig/network-scripts/ifcfg-<device>
##TODO When you add the IPs need to add to ssh known hosts with user rancher and ssh-copy-id user@node
#Rancher user needs to be able to run docker. Docker needed on all machines with insecure-registry
echo Docker Registry IP
read docker_reg_ip
echo Enter Node 1 IP
read node1_ip
echo Enter Node 2 IP
read node2_ip
echo Enter Node 3 IP
read node3_ip

yum -y install docker
service docker start

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
 ./rancher-load-images.sh --image-list ./rancher-images.txt --registry ${docker_reg_ip}:5000
curl -LO https://raw.githubusercontent.com/irvingwa/RKE_Setup/master/rancher-cluster.yml
sed -i -e "s|dockerRegIP|${docker_reg_ip}|g" ./rancher-cluster.yml
sed -i -e "s|node1IP|${node1_ip}|g" ./rancher-cluster.yml
sed -i -e "s|node2IP|${node2_ip}|g" ./rancher-cluster.yml
sed -i -e "s|node3IP|${node3_ip}|g" ./rancher-cluster.yml
rke up --config ./rancher-cluster.yml
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm fetch rancher-latest/rancher
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm fetch jetstack/cert-manager --version v0.12.0
helm template cert-manager ./cert-manager-v0.12.0.tgz --output-dir . \
   --namespace cert-manager \
   --set image.repository=${docker_reg_ip}:5000/quay.io/jetstack/cert-manager-controller \
   --set webhook.image.repository=${docker_reg_ip}:5000/quay.io/jetstack/cert-manager-webhook \
   --set cainjector.image.repository=${docker_reg_ip}:5000/quay.io/jetstack/cert-manager-cainjector
curl -L -o cert-manager/cert-manager-crd.yaml https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml
helm template rancher ./rancher-v2.3.5.tgz --output-dir . \
 --namespace cattle-system \
 --set hostname=<RANCHER.YOURDOMAIN.COM> \
 --set certmanager.version=v0.12.0 \
 --set rancherImage=${docker_reg_ip}:5000/rancher/rancher \
 --set systemDefaultRegistry=${docker_reg_ip}:5000 \ # Available as of v2.2.0, set a default private registry to be used in Rancher
 --set useBundledSystemChart=true # Available as of v2.3.0, use the packaged Rancher system charts
kubectl create namespace cert-manager
kubectl apply -f cert-manager/cert-manager-crd.yaml
kubectl apply -R -f ./cert-manager
kubectl create namespace cattle-system
kubectl -n cattle-system apply -R -f ./rancher
