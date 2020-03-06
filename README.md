# RKE_Setup
sshkeygen -t rsa
ssh-copy-id to all nodes as user
systemctl disable firewalld everywhere
systemctl stop firewalld everywhere
install docker everywhere
/etc/docker/dameon.json
"insecure-registries" : ["registry:5000"] everywhere
on non airgapped node add docker proxy
/etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80/"
Environment="HTTPS_PROXY=http://proxy.example.com:80/"
Environment="NO_PROXY=.test.com"
systemctl daemon-reload
systemctl restart docker
on nginx machine enable ipv4 forwarding
vi /etc/sysctl.conf
net.ipv4.ip_forward=1
sysctl -p /etc/sysctl.conf
