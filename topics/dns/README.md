# DNS Server for Kit
At this point we have used static addignments for all the services for the kit. to make it easier to find stuff and allow some forms of automation we will be setting up a dns server first. after that we will deploy rock and capes



## Prereqs
 - RHEL installed with static ip set during installation

### Set static IP
If you forgot to set astatic of need to change use

```
sudo nmtui
```

### Install dnsmasq
```
sudo yum install dnsmasq
```
All we need to do is configure it so it can answer dns queries
```
sudo vim /etc/dnsmasq.conf
```
Add the following lines to the config file. This binds it to the localhost and also its own static ip. It also disables dhcp as the router is already handling any dhcp we need.
```
listen-address=127.0.0.1
listen-address=10.[state].40.20
no-dhcp-interface=
```
Add the following addresses to the endo of the /etc/hosts files

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.1.10.19  nuc.mo.cmat.lan
10.1.10.20  dns.mo.cmat.lan
10.1.10.7   idrac1.mo.cmat.lan
10.1.10.9   idrac2.mo.cmat.lan
10.1.10.15  esxi1.mo.cmat.lan
10.1.10.21  sensor.mo.cmat.lan
10.1.10.5   gigamon.mo.cmat.lan
10.1.10.25  kibana.mo.cmat.lan
10.1.10.25  es1.mo.cmat.lan
10.1.10.26  es2.mo.cmat.lan
10.1.10.27  es3.mo.cmat.lan
```
Restart dnsmasq

```
sudo systemctl restart dnsmasq

```
