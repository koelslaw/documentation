# DNS Server for Kit
At this point we have used static addignments for all the services for the kit. to make it easier to find stuff and allow some forms of automation we will be setting up a dns server first. after that we will deploy rock and capes



## Prereqs
 - RHEL installed with static ip set during installation

### Set static IP
If you forgot to set astatic of need to change use

```
sudo nmtui
```

### Configure DNSmasq

As DNSmasq is already installed by default on the os all we need to do is configure it so it can answer dns queries


```
sudo vim /etc/dnsmasq.conf
```
Add the following lines to the config file. This binds it to the localhost and also its own static ip. It also disables dhcp as the router is already handling any dhcp we need.
```
listen-address=127.0.0.1
listen-address=10.[state].40.20
no-dhcp-interface=
```
