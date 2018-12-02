# Nmap Install
Nmap ("Network Mapper") is a free and open source utility for network discovery and security auditing. Many systems and network administrators also find it useful for tasks such as network inventory, managing service upgrade schedules, and monitoring host or service uptime. Nmap uses raw IP packets in novel ways to determine what hosts are available on the network, what services (application name and version) those hosts are offering, what operating systems (and OS versions) they are running, what type of packet filters/firewalls are in use, and dozens of other characteristics. It was designed to rapidly scan large networks, but works fine against single hosts.

## Documentation
Nmap [User Guide]()

## Install Instructions
### Update Repository
We want to set the Nuc as the upstream repository, you can copy / paste this following code block into the Terminal.
```
sudo bash -c 'cat > /etc/yum.repos.d/local-repos.repo <<EOF
[local-epel/x86_64]
name=Extra Packages For Enterprise Linux Local Repo
baseurl=http://nuc.mo.cmat.lan/epel/
gpgcheck=0
enabled=1

[local-nmap/x68_64]
name=Nmap Repo
baseurl=http://nuc.mo.cmat.lan/nmap/
gpgcheck=0
enabled=1

[local-rhel-7-server-rpms/7Server/x68_64]
name=
baseurl=http://nuc.mo.cmat.lan/rhel-7-server-rpms/
gpgcheck=0
enabled=1
EOF'
yum repolist all
sudo yum install nmap -y
```
