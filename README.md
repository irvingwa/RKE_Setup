# RKE_Setup
sshkeygen -t rsa <br />
ssh-copy-id to all nodes as user<br />
firewall-cmd --permanent --add-port=2379/tcp everywhere<br />
firewall-cmd --permanent --add-port=6443/tcp everywhere<br />
firewall-cmd --permanent --add-port=10250/tcp everywhere<br />
firewall-cmd --reload<br />
install docker everywhere<br />
/etc/docker/dameon.json<br />
"insecure-registries" : ["registry:5000"] everywhere<br />
on non airgapped node add docker proxy<br />
/etc/systemd/system/docker.service.d/http-proxy.conf<br />
[Service]<br />
Environment="HTTP_PROXY=http://proxy.example.com:80/"<br />
Environment="HTTPS_PROXY=http://proxy.example.com:80/"<br />
Environment="NO_PROXY=.test.com"<br />
systemctl daemon-reload<br />
systemctl restart docker<br />
on nginx machine enable ipv4 forwarding<br />
vi /etc/sysctl.conf<br />
net.ipv4.ip_forward=1<br />
sysctl -p /etc/sysctl.conf<br />
