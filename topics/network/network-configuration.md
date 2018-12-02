# Network Configuration

Before you start, ensure that your switch and router are [properly racked](../hardware-assembly.md)

# Initial Router Configuration
## Console
With a Mac or Linux system, connect a Console cable to the Console port of the switch  
![](../../images/router-console.png)  
> Console port highlighted purple

Connect your Console cable and go into your Terminal program (Terminal, iTerm, etc.)
```
ls /dev/*usb*
crw-rw-rw-  1 root  wheel   20, 115 Nov 29 15:06 /dev/cu.usbserial-A105LRRY (this could be slightly different on your system)
crw-rw-rw-  1 root  wheel   20, 114 Nov 29 15:06 /dev/tty.usbserial-A105LRRY (this could be slightly different on your system)
sudo cu -l /dev/cu.usbserial-A105LRRY -s 9600
```
> If you are using a different console access program, the following parameters are needed:

```
Baud Rate: 9600
Data Bits: 8
Parity: None
Stop Bits: 1
Flow Control: None
```

As soon as you connect, you'll be given some basic instructions on how to change the default username and passphrase. So let's do that.

Remember, the credential pairs are stored in the [platform-management page](../platform-management.md). Replace `[username]` and `[passphrase]` with the proper pair from the [platform-management page](../platform-management.md).

```
User Access Verification
Username: [default username]
Password: [default password]
Router# config t
Router(config)# username [username] privilege 15 secret 0 [password]
```

Run these commands to configure the router. The entire running configuration is stored in the [config directory](../../config/router.config) for redundancy.

**Note:** You can copy and paste this into the router console. You need to change the hostnames, octets, and insert your passwords from the [Platform Management page](../platform-management.md) before inputting this into the router.

A good suggestion is to perform a "Find" for `[` and replace the `[comment]` with your specific environment variables.
```
enable
configure terminal
service timestamps debug datetime msec
service timestamps log datetime msec
platform qfp utilization monitor load 80
no platform punt-keepalive disable-kernel-core
!
hostname gateway.[state].cmat.lan
!
boot-start-marker
boot-end-marker
!
!
vrf definition Mgmt-intf
 !
 address-family ipv4
 exit-address-family
 !
 address-family ipv6
 exit-address-family
!
enable secret 0 [password from Platform Management]
!
aaa new-model
!
!
!
!
!
!
!
!
aaa session-id common
clock timezone CST -6 0
clock summer-time CST recurring
clock calendar-valid
!
!
!
!
!
!
!
ip host switch.[state].cmat.lan 10.[state octet].10.3
!
!
!
!
!
!
!
!
!
!
subscriber templating
!
!
!
!
!
!
!
multilink bundle-name authenticated
!
!
!
!
crypto pki trustpoint TP-self-signed-1123779263
 enrollment selfsigned
 subject-name cn=IOS-Self-Signed-Certificate-1123779263
 revocation-check none
 rsakeypair TP-self-signed-1123779263
!
crypto pki trustpoint TP-self-signed-1349810103
 enrollment selfsigned
 subject-name cn=IOS-Self-Signed-Certificate-1349810103
 revocation-check none
 rsakeypair TP-self-signed-1349810103
!
!
!
!
license udi pid ISR4321/K9 sn FLM224103AR
license boot suite FoundationSuiteK9
diagnostic bootup level minimal
spanning-tree extend system-id
!
!
!
username admin privilege 15 password 0 [password from Platform Management]
!
redundancy
 mode none
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
!
interface GigabitEthernet0/0/0
 ip address dhcp
 ip nat outside
 shutdown
 negotiation auto
 spanning-tree portfast trunk
!
interface GigabitEthernet0/0/1
 description Internal Gateway
 no ip address
 negotiation auto
 spanning-tree portfast disable
!
interface GigabitEthernet0/0/1.2
 description xr_routing
 encapsulation dot1Q 2
 ip address 10.[state octet].2.1 255.255.255.0
!
interface GigabitEthernet0/0/1.20
 description Active Network
 encapsulation dot1Q 20
 ip address 10.[state octet].20.1 255.255.255.0
!
interface GigabitEthernet0
 vrf forwarding Mgmt-intf
 no ip address
 negotiation auto
!
!
router eigrp 100
 network 0.0.0.0
 network 10.[state octet].2.0 0.0.0.255
 network 10.[state octet].20.0 0.0.0.255
 redistribute static
 redistribute connected
 passive-interface GigabitEthernet0/0/0
!
ip nat inside source list NAT interface GigabitEthernet0/0/0 overload
ip forward-protocol nd
no ip http server
ip http authentication local
no ip http secure-server
ip tftp source-interface GigabitEthernet0
ip dns server
ip route 0.0.0.0 0.0.0.0 GigabitEthernet0/0/0
!
ip ssh rsa keypair-name ssh-hostkey-rsa4096
ip ssh version 2
!
!
ip access-list extended NAT
 deny   ip 10.0.0.0 0.255.255.255 10.0.0.0 0.255.255.255
 permit ip 10.0.0.0 0.255.255.255 any
!
!
```

# Initial Switch Setup
## Console
1. With a Mac or Linux system, connect a Console cable to the Console port of the switch  
![](../../images/switch-console.png)  
> Console port highlighted purple

1. Connect your Console cable and go into your Terminal program (Terminal, iTerm, etc.)
```
ls /dev/*usb*
crw-rw-rw-  1 root  wheel   20, 115 Nov 29 15:06 /dev/cu.usbserial-A105LRRY (this could be slightly different on your system)
crw-rw-rw-  1 root  wheel   20, 114 Nov 29 15:06 /dev/tty.usbserial-A105LRRY (this could be slightly different on your system)
sudo cu -l /dev/cu.usbserial-A105LRRY -s 9600
```
> If you are using a different console access program, the following parameters are needed:

```
Baud Rate: 9600
Data Bits: 8
Parity: None
Stop Bits: 1
Flow Control: None
```

1. As soon as you connect, you'll be asked `Would you like to enter the initial configuration dialog? [yes/no]`, let's do that so type `yes`.

```
Would you like to enter basic management setup? [yes/no]: yes
Enter host name [Switch]: switch.[state].cmat.lan
Enter enable secret: see "platform-management.md" for the credentials to use
Enter enable password: see "platform-management.md" for the credentials to use
Enter virtual terminal password: see "platform-management.md" for the credentials to use
Do you want to configure country code? [no]: yes
Enter the country code[US]:US
Configure SNMP Network Management? [no]: no
Enter interface name used to connect to the management network from the above interface summary: vlan1
Configure IP on this interface? [yes]: yes
IP address for this interface: 10.[state octet].10.3
Subnet mask for this interface [255.0.0.0]: 255.255.255.0
Would you like to enable as a cluster command switch? [yes/no]: no

[0] Go to the IOS command prompt without saving this config.
[1] Return back to the setup without saving this config.
[2] Save this configuration to nvram and exit.

Choose (2) to save the configuration to NVRAM to use it the next time the switch reboots.

Enter your selection [2]: 2
```

Run these commands to configure the switch. The entire running configuration is stored in the [config directory](../../config/switch.config) for redundancy.

**Note:** You can copy and paste this into the switch console. You need to change the hostnames, octets, and insert your passwords from the [Platform Management page](../platform-management.md) before inputting this into the switch.

A good suggestion is to perform a "Find" for `[` and replace the `[comment]` with your specific environment variables.

```
enable
configure terminal
no service pad
service timestamps debug datetime msec
service timestamps log datetime msec
no platform punt-keepalive disable-kernel-core
!
hostname switch.[state].cmat.lan
!
!
vrf definition Mgmt-vrf
 !
 address-family ipv4
 exit-address-family
 !
 address-family ipv6
 exit-address-family
!
enable secret 0 [password from Platform Management]
enable password [password from Platform Management]
!
aaa new-model
!
!
!
!
!
!
!
!
aaa session-id common
switch 1 provision ws-c3850-48t
!
!
!
!
ip routing
!
!
!
!
ip nbar http-services
!
no ip domain lookup
ip dhcp excluded-address 10.[state octet].50.1 10.[state octet].50.10
ip dhcp excluded-address 10.[state octet].60.1 10.[state octet].60.20
!
ip dhcp pool AP_CONFIG
 network 10.[state octet].50.0 255.255.255.0
 default-router 10.[state octet].50.1
 option 150 ip 10.[state octet].50.1
!
ip dhcp pool AP_CLIENTS
 network 10.[state octet].60.0 255.255.255.0
 default-router 10.[state octet].60.1
 dns-server 10.[state octet].10.[state octet]
 domain-name [state].cmat.lan
!
!
!
!
!
!
!
!
!
!
!
flow monitor wireless-avc-basic
 record wireless avc basic
!
central-management-version 720912395232346117
!
crypto pki trustpoint TP-self-signed-3592452553
 enrollment selfsigned
 subject-name cn=IOS-Self-Signed-Certificate-3592452553
 revocation-check none
 rsakeypair TP-self-signed-3592452553
!
!
!
device classifier
license boot level ipservicesk9
diagnostic bootup level minimal
spanning-tree mode rapid-pvst
spanning-tree extend system-id
!
!
username admin privilege 15 password 0 [password from Platform Management]
!
redundancy
 mode sso
service-routing mdns-sd
 designated-gateway enable
!
!
!
class-map match-any system-cpp-police-topology-control
  description Topology control
class-map match-any system-cpp-police-sw-forward
  description Sw forwarding, SGT Cache Full, LOGGING
class-map match-any system-cpp-default
  description DHCP snooping, show forward and rest of traffic
class-map match-any system-cpp-police-sys-data
  description Learning cache ovfl, Crypto Control, Exception, EGR Exception, NFL SAMPLED DATA, Gold Pkt, RPF Failed
class-map match-any AutoQos-4.0-RT1-Class
 match dscp ef
 match dscp cs6
class-map match-any system-cpp-police-punt-webauth
  description Punt Webauth
class-map match-any AutoQos-4.0-RT2-Class
 match dscp cs4
 match dscp cs3
 match dscp af41
class-map match-any AutoQos-4.0-wlan-Voip-Signal-Class
 match dscp cs3
 match access-group name AutoQos-4.0-wlan-Acl-Signaling
class-map match-any system-cpp-police-forus
  description Forus Address resolution and Forus traffic
class-map match-any system-cpp-police-multicast-end-station
  description MCAST END STATION
class-map match-any AutoQos-4.0-wlan-Voip-Data-Class
 match dscp ef
class-map match-any AutoQos-4.0-wlan-Multimedia-Conf-Class
 match access-group name AutoQos-4.0-wlan-Acl-MultiEnhanced-Conf
class-map match-any system-cpp-police-multicast
  description Transit Traffic and MCAST Data
class-map match-any AutoQos-4.0-wlan-Bulk-Data-Class
 match access-group name AutoQos-4.0-wlan-Acl-Bulk-Data
class-map match-any system-cpp-police-l2-control
  description L2 control
class-map match-any system-cpp-police-dot1x-auth
  description DOT1X Auth
class-map match-any system-cpp-police-data
  description ICMP_GEN and BROADCAST
class-map match-any AutoQos-4.0-wlan-Scavanger-Class
 match access-group name AutoQos-4.0-wlan-Acl-Scavanger
class-map match-any system-cpp-police-control-low-priority
  description ICMP redirect and general punt
class-map match-any AutoQos-4.0-wlan-Transaction-Class
 match access-group name AutoQos-4.0-wlan-Acl-Transactional-Data
class-map match-any system-cpp-police-wireless-priority1
  description Wireless priority 1
class-map match-any system-cpp-police-wireless-priority2
  description Wireless priority 2
class-map match-any system-cpp-police-wireless-priority3-4-5
  description Wireless priority 3,4 and 5
class-map match-any non-client-nrt-class
class-map match-any system-cpp-police-routing-control
  description Routing control
class-map match-any system-cpp-police-protocol-snooping
  description Protocol snooping
!
policy-map port_child_policy
 class non-client-nrt-class
  bandwidth remaining ratio 7
 class AutoQos-4.0-RT1-Class
  priority level 1 percent 10
 class AutoQos-4.0-RT2-Class
  priority level 2 percent 20
 class class-default
  bandwidth remaining ratio 63
policy-map AutoQos-4.0-wlan-ET-Client-Input-Policy
 class AutoQos-4.0-wlan-Voip-Data-Class
  set dscp ef
 class AutoQos-4.0-wlan-Voip-Signal-Class
  set dscp cs3
 class AutoQos-4.0-wlan-Multimedia-Conf-Class
  set dscp af41
 class AutoQos-4.0-wlan-Transaction-Class
  set dscp af21
 class AutoQos-4.0-wlan-Bulk-Data-Class
  set dscp af11
 class AutoQos-4.0-wlan-Scavanger-Class
  set dscp cs1
 class class-default
  set dscp default
policy-map system-cpp-policy
 class system-cpp-police-data
  police rate 200 pps
 class system-cpp-police-sys-data
  police rate 100 pps
 class system-cpp-police-sw-forward
  police rate 1000 pps
 class system-cpp-police-multicast
  police rate 500 pps
 class system-cpp-police-multicast-end-station
  police rate 2000 pps
 class system-cpp-police-punt-webauth
 class system-cpp-police-l2-control
 class system-cpp-police-routing-control
  police rate 1800 pps
 class system-cpp-police-control-low-priority
 class system-cpp-police-wireless-priority1
 class system-cpp-police-wireless-priority2
 class system-cpp-police-wireless-priority3-4-5
 class system-cpp-police-topology-control
 class system-cpp-police-dot1x-auth
 class system-cpp-police-protocol-snooping
 class system-cpp-police-forus
 class system-cpp-default
policy-map AutoQos-4.0-wlan-ET-SSID-Child-Policy
 class AutoQos-4.0-RT1-Class
  police cir percent 10
  priority level 1
 class AutoQos-4.0-RT2-Class
  police cir percent 20
  priority level 2
 class class-default
policy-map AutoQos-4.0-wlan-ET-SSID-Output-Policy
 class class-default
  shape average percent 100
  queue-buffers ratio 0
   service-policy AutoQos-4.0-wlan-ET-SSID-Child-Policy
!
!
!
!
!
!
!
!
!
!
!
!
!
!
interface Port-channel1
 switchport mode trunk
 lacp max-bundle 2
!
interface GigabitEthernet0/0
 vrf forwarding Mgmt-vrf
 no ip address
 shutdown
 negotiation auto
!
interface GigabitEthernet1/0/1
 switchport mode trunk
!
interface GigabitEthernet1/0/2
 switchport access vlan 50
 switchport mode access
 spanning-tree portfast
 ip nbar protocol-discovery
!
interface GigabitEthernet1/0/3
 switchport access vlan 10
!
interface GigabitEthernet1/0/4
 switchport access vlan 10
!
interface GigabitEthernet1/0/5
 switchport access vlan 10
!
interface GigabitEthernet1/0/6
 switchport access vlan 10
!
interface GigabitEthernet1/0/7
 switchport access vlan 10
!
interface GigabitEthernet1/0/8
 switchport access vlan 10
!
interface GigabitEthernet1/0/9
 switchport access vlan 10
!
interface GigabitEthernet1/0/10
 switchport access vlan 10
!
interface GigabitEthernet1/0/11
 switchport access vlan 10
 switchport mode trunk
!
interface GigabitEthernet1/0/12
 switchport access vlan 10
!
interface GigabitEthernet1/0/13
 switchport access vlan 10
!
interface GigabitEthernet1/0/14
 switchport access vlan 10
!
interface GigabitEthernet1/0/15
 switchport access vlan 10
!
interface GigabitEthernet1/0/16
 switchport access vlan 10
!
interface GigabitEthernet1/0/17
 switchport access vlan 10
!
interface GigabitEthernet1/0/18
 switchport access vlan 10
!
interface GigabitEthernet1/0/19
 switchport access vlan 10
!
interface GigabitEthernet1/0/20
 switchport access vlan 10
!
interface GigabitEthernet1/0/21
 switchport access vlan 10
!
interface GigabitEthernet1/0/22
 switchport access vlan 10
!
interface GigabitEthernet1/0/23
 switchport access vlan 10
!
interface GigabitEthernet1/0/24
 switchport access vlan 10
!
interface GigabitEthernet1/0/25
 switchport access vlan 10
!
interface GigabitEthernet1/0/26
 switchport access vlan 10
!
interface GigabitEthernet1/0/27
 switchport access vlan 10
!
interface GigabitEthernet1/0/28
 switchport access vlan 10
!
interface GigabitEthernet1/0/29
 switchport access vlan 10
!
interface GigabitEthernet1/0/30
 switchport access vlan 10
!
interface GigabitEthernet1/0/31
 switchport access vlan 10
!
interface GigabitEthernet1/0/32
 switchport access vlan 10
!
interface GigabitEthernet1/0/33
 switchport access vlan 10
!
interface GigabitEthernet1/0/34
 switchport access vlan 10
!
interface GigabitEthernet1/0/35
 switchport access vlan 10
!
interface GigabitEthernet1/0/36
 switchport access vlan 10
!
interface GigabitEthernet1/0/37
!
interface GigabitEthernet1/0/38
!
interface GigabitEthernet1/0/39
!
interface GigabitEthernet1/0/40
!
interface GigabitEthernet1/0/41
!
interface GigabitEthernet1/0/42
!
interface GigabitEthernet1/0/43
!
interface GigabitEthernet1/0/44
!
interface GigabitEthernet1/0/45
!
interface GigabitEthernet1/0/46
!
interface GigabitEthernet1/0/47
!
interface GigabitEthernet1/0/48
!
interface GigabitEthernet1/1/1
!
interface GigabitEthernet1/1/2
!
interface GigabitEthernet1/1/3
!
interface GigabitEthernet1/1/4
!
interface TenGigabitEthernet1/1/1
 switchport mode trunk
 channel-group 1 mode active
 lacp port-priority 1
!
interface TenGigabitEthernet1/1/2
 switchport mode trunk
 channel-group 1 mode active
 lacp port-priority 1
!
interface TenGigabitEthernet1/1/3
 shutdown
!
interface TenGigabitEthernet1/1/4
 shutdown
!
interface Vlan1
 no ip address
 shutdown
!
interface Vlan2
 description routing_xc
 ip address 10.[state octet].2.2 255.255.255.0
!
interface Vlan10
 ip address 10.[state octet].10.[state octet] 255.255.255.0
!
interface Vlan50
 ip address 10.[state octet].50.1 255.255.255.0
!
interface Vlan60
 ip address 10.[state octet].60.1 255.255.255.0
!
!
router eigrp 100
 network 10.[state octet].2.0 0.0.0.255
 network 10.[state octet].50.0 0.0.0.255
 network 10.[state octet].60.0 0.0.0.255
!
ip forward-protocol nd
ip http server
ip http authentication local
ip http secure-server
!
!
ip access-list extended AutoQos-4.0-wlan-Acl-Bulk-Data
 permit tcp any any eq 22
 permit tcp any any eq 465
 permit tcp any any eq 143
 permit tcp any any eq 993
 permit tcp any any eq 995
 permit tcp any any eq 1914
 permit tcp any any eq ftp
 permit tcp any any eq ftp-data
 permit tcp any any eq smtp
 permit tcp any any eq pop3
ip access-list extended AutoQos-4.0-wlan-Acl-MultiEnhanced-Conf
 permit udp any any range 16384 32767
 permit tcp any any range 50000 59999
ip access-list extended AutoQos-4.0-wlan-Acl-Scavanger
 permit tcp any any range 2300 2400
 permit udp any any range 2300 2400
 permit tcp any any range 6881 6999
 permit tcp any any range 28800 29100
 permit tcp any any eq 1214
 permit udp any any eq 1214
 permit tcp any any eq 3689
 permit udp any any eq 3689
 permit tcp any any eq 11999
ip access-list extended AutoQos-4.0-wlan-Acl-Signaling
 permit tcp any any range 2000 2002
 permit tcp any any range 5060 5061
 permit udp any any range 5060 5061
ip access-list extended AutoQos-4.0-wlan-Acl-Transactional-Data
 permit tcp any any eq 443
 permit tcp any any eq 1521
 permit udp any any eq 1521
 permit tcp any any eq 1526
 permit udp any any eq 1526
 permit tcp any any eq 1575
 permit udp any any eq 1575
 permit tcp any any eq 1630
 permit udp any any eq 1630
 permit tcp any any eq 1527
 permit tcp any any eq 6200
 permit tcp any any eq 3389
 permit tcp any any eq 5985
 permit tcp any any eq 8080
!
!
!
!
!
!
control-plane
 service-policy input system-cpp-policy
!
!
line con 0
 length 0
 stopbits 1
line aux 0
 stopbits 1
line vty 0 4
 length 0
line vty 5 15
!
ntp server 10.[state octet].10.[state octet] source Vlan10
!
wsma agent exec
!
wsma agent config
!
wsma agent filesys
!
wsma agent notify
!
event manager environment UNSUPPORTED_AP_VLAN 50
!
wireless mobility controller
wireless management interface Vlan50
wireless multicast
wireless mgmt-via-wireless
wlan CMAT.[STATE] 1 CMAT.[STATE]
 auto qos enterprise
 client vlan 0060
 ip flow monitor wireless-avc-basic input
 ip flow monitor wireless-avc-basic output
 radio dot11bg
 no security wpa akm dot1x
 security wpa akm psk set-key ascii 0 cyberteam
 no shutdown
ap fra
ap ntp ip 10.[state octet].10.[state octet]9
ap dot11 24ghz rf-profile a
 dot11n-only
 no shutdown
ap dot11 airtime-fairness policy-name Default 0
ap group cmat
 remote-lan CMAT.[STATE]
 airtime-fairness dot11 24GHz mode enforce-policy
 airtime-fairness dot11 24GHz optimization
 airtime-fairness dot11 5GHz mode enforce-policy
 airtime-fairness dot11 5GHz optimization
 hyperlocation
 wlan CMAT.[STATE]
  vlan VLAN0060
 port 1
  poe
  no shutdown
 port 2
  no shutdown
 port 3
  no shutdown
 rf-profile dot11 24ghz a
ap group default-group
ap hyperlocation ble-beacon 0
ap hyperlocation ble-beacon 1
ap hyperlocation ble-beacon 2
ap hyperlocation ble-beacon 3
ap hyperlocation ble-beacon 4
end
```

## Initial Switch Configuration (WebUI)
1. Connect a network cable to the management port on the front of the switch
![](../../images/switch-management.png)
> Management port highlighted purple  

1. Set your local IP address to be in the same subnet as the management IP you configured above (`10.[state octet].10.6/24` as an example).
1. Point your browser to the management IP you set above (`http://10.[state octet].10.3` in this example)

Move onto [Dell Chassis Management Console (CMC) Configuration](cmc-configuration.md)
