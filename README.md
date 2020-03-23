# RKE_Setup
sshkeygen -t rsa <br />
ssh-copy-id to all nodes as user<br />
docker stop $(docker ps -a -q)<br />
docker rm $(docker ps -a -q)<br />
firewall-cmd --permanent --add-port=22/tcp<br />
firewall-cmd --permanent --add-port=80/tcp<br />
firewall-cmd --permanent --add-port=443/tcp<br />
firewall-cmd --permanent --add-port=2376/tcp<br />
firewall-cmd --permanent --add-port=2379/tcp<br />
firewall-cmd --permanent --add-port=2380/tcp<br />
firewall-cmd --permanent --add-port=6443/tcp<br />
firewall-cmd --permanent --add-port=8472/udp<br />
firewall-cmd --permanent --add-port=9099/tcp<br />
firewall-cmd --permanent --add-port=10250/tcp<br />
firewall-cmd --permanent --add-port=10254/tcp<br />
firewall-cmd --permanent --add-port=30000-32767/tcp<br />
firewall-cmd --permanent --add-port=30000-32767/udp<br />
firewall-cmd --reload<br />
service firewalld restart<br />
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

Then Run
./lbdr.sh
then
./prepare.sh
