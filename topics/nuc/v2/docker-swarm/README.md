# Intel Nuc
 In version 3 the plan for the NUC is mush more involved. The nuc will be the initial orchestration layer for the whole kit. We will accomplish this with docker. Essentailyl the nuc is the brains fo the outfit and will tell the dell servers what to do.


## What is Docker
Docker is a tool designed to make it easier to create, deploy, and run applications called containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package. Docker allows applications to use the same Linux kernel (in our case RHEL/CENTOS) as the system that they're running on and only requires applications be shipped with things not already running on the host computer.


## What is Kubernetes


## CENTOS Install
```
 sudo yum remove docker docker-common docker-selinux docker-engine
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce
```

## RHEL Install
TBD


## Kubernetes Install
cd Downloads/
ls
cd ..
cd Documents/
ls
sudo yum install ./google-chrome-stable_current_x86_64.rpm 
google-chrome
ip a
sudo yum remove docker docker-common docker-selinux docker-engine
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce
sudo systemctl start docker
docker-machine ssh manager1
sudo firewall-cmd --add-port=2377/tcp --permanent
sudo firewall-cmd --add-port=7946/tcp --permanent
sudo firewall-cmd --add-port=7946/udp --permanent
sudo firewall-cmd --add-port=4789/udp --permanent
sudo firewall-cmd --reload
ip a
docker swarm init --advertise-addr 192.168.78.129
sudo docker swarm init --advertise-addr 192.168.78.129
docker info
sudo docker info
sudo docker node ls
docker service create --replicas 1 --name helloworld alpine ping docker.com
sudo docker service create --replicas 1 --name helloworld alpine ping docker.com
sudo docker node ls
sudo docker info
docker service ls
sudo docker service ls
sudo docker service inspect --pretty helloworld
sudo docker service ps helloworld
sudo docker service scal helloworld=5
sudo docker service scale helloworld=5
sudo docker service ps helloworld
sudo docker service rm helloworld
sudo docker service inspect helloworld
docker service create   --replicas 3   --name redis   --update-delay 10s   redis:3.0.6
sudo docker service create   --replicas 3   --name redis   --update-delay 10s   redis:3.0.6
docker service ps 0j88elnm50edbw4jvdje16dg7
sudo docker service ps 0j88elnm50edbw4jvdje16dg7
sudo docker service inspect --pretty redis
sudo docker service update --image redis:3.0.7 redis
sudo docker ps redis
sudo docker service ps redis
sudo docker node update --availability drain worker1
sudo docker node update --availability drain nuc.mo.cmat.lan
sudo vi /etc/yum.repos.d/kubernetes.repo

[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

sudo yum install kubectl
kubectl cluster-info
sudo kubectl cluster-info
sudo firewall-cmd --add-service=kubectl --permanent
sudo systemctl status kubernetes
kubectl
sudo kubectl cluster-info
ls ~/
la -al
ls -al
sudo kubectl help
sudo docker ps
sudo systemctl status docker
sudo systemctl start docker
sudo kubectl cluster-info
sudo kubectl cluster-info dump
sudo kubectl stop
sudo kubectl start
sudo kubectl cluster-info dump
kubectl cluster-info
hostnamectl set-hostname 'k8s-master'
exec bash
setenforce 0
sudo setenforce 0
sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10251/tcp
sudo firewall-cmd --permanent --add-port=10252/tcp
sudo firewall-cmd --permanent --add-port=10255/tcp
sudo firewall-cmd --permanent --reload
sudo firewall-cmd  --reload
sudo modprobe br_netfilter
sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
sudo -s
sudo yum install kubelet
sudo yum install kubeadm
