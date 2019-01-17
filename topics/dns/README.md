# DNS Server for Kit
At this point we have used static assignments for all the components of the kit. To make it easier to find stuff and allow some forms of automation we will be setting up a dns server first.

## Prereqs
 - RHEL installed with static ip set during installation according to [RHEL Documentation](../rhel/README.md)
  - If you forgot to set a static of need to change use `sudo nmtui`
- Logged in via `ssh` or via the ESXi Console

### Dnsmasq

1. Install dnsmasq
  ```
  sudo yum install dnsmasq
  ```
1. Configure the dnsmasq config files so dnsmaq will answer dns queries.
  ```
  sudo vi /etc/dnsmasq.conf
  ```
1. Add the following lines to the end of the config file. This binds it to the localhost and also its own static ip. It also disables DHCP as the switch is already handling any DHCP we need.
  ```
  listen-address=127.0.0.1
  listen-address=10.[state].10.20
  no-dhcp-interface=
  ```
1. Add the following addresses to the end of the /etc/hosts files using `sudo vi /etc/hosts`

   > NOTE: Any other dns entries you wish to have go here  

  ```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.[state octet].10.19  nuc.[state].cmat.lan
10.[state octet].10.20  dns.[state].cmat.lan
10.[state octet].10.7   idrac1.[state].cmat.lan
10.[state octet].10.9   idrac2.[state].cmat.lan
10.[state octet].10.15  esxi1.[state].cmat.lan
10.[state octet].10.21  sensor.[state].cmat.lan
10.[state octet].10.5   gigamon.[state].cmat.lan
10.[state octet].10.25  kibana.[state].cmat.lan
10.[state octet].10.25  es1.[state].cmat.lan
10.[state octet].10.26  es2.[state].cmat.lan
10.[state octet].10.27  es3.[state].cmat.lan
10.[state octet].10.28  capes.[state].cmat.lan
10.[state octet].10.20  grassmarlin.[state].cmat.lan
  ```
1. Allow DNS traffic through the firewall using:
  ```
  sudo firewall-cmd --add-port=53/udp --permanent
  ```
1. Reload the firewall config using:

  ```
  sudo firewall-cmd --reload
  ```

  You should receive a `success` message if the firewall commands have been run correctly.

1. Restart dnsmasq

  ```
  sudo systemctl restart dnsmasq
  ```

1. Add dnsmasq to startup
  ```
  sudo systemctl enable dnsmasq
  ```

1. Ensure dnsmasq is running
  ```
  sudo systemctl status dnsmasq
  ```

Move on to [RockNSM Data Node](../rocknsm/README.md)
