# Router Setup
## Physical Connections
Connect the USB D cable to the console port on the front of the Cisco 4321
From a terminal window on you Mac Book Pro you will need to look in the /dev directory for the USB connection (tty.usb something)
Once you find that you will want to screen that connection to connect to it.
Example:
screen /dev/tty.usbmodem#######
## Show Enable
>NOTE: At any point you may enter a question mark '?' for help. Use ctrl-c to abort configuration dialog at any prompt. Default settings are in square brackets '[ ]'.
When presented with the —-System Configuration Dialog—-
Would you like to enter the initial configuration dialog? [yes/no]: no
Would you like to terminate autoinstall? [yes]: <enter>
If presented with a blank screen press <return>. You are looking for the Router> prompt 

## Enter a hostname for the router:
1. Router>Enable
1. Router#Config terminal
1. Router(config)#hostname gateway.xx (xx is state dependent. See list at end of document for your state’s information)
## Setting Domain Name:
Gateway.XX(config)#ip domain-name cmat.lan
> NOTE: The following sections assume you are at the Router> prompt. If you are at the
gateway.hi(config)# prompt you should ignore the first two steps of each section.

## Set local user and password:
Router>Enable Router#Config terminal
Gateway.XX(config)#username xadmin privilege 15 secret {enter a password} Gateway.XX(config)#username admin privilege 15 secret {enter a password}
## Set up console:
Router>Enable Router#Config terminal
Gateway.XX(config)#line con 0 Gateway.XX(config)#exec-timeout 60 0 Gateway.XX(config)#length 0 Gateway.XX(config)#login local
## Set up authentication: Router>Enable
Router#Config terminal Gateway.XX(config)#aaa new-model Gateway.XX(config)#aaa session-id common
## Set Clock
Router>Enable
Router#Config terminal
Gateway.XX(config)#clock timezone CST -6 0** Gateway.XX(config)#clock summer-time CST recurring** Gateway.XX(config)#clock calendar-valid Gateway.XX(config)#ntp master
## Set Up SSH:
Router>Enable
Router#Config terminal
Gateway.XX(config)#crypto key gen rsa usage-keys label ssh-hostkey-rsa4096 How many bits in the modulus [512]: 4096
How many bits in the modulus [512]: 4096
Gateway.XX(config)#ip ssh rsa keypair-name ssh-hostkey-rsa4096** Gateway.XX(config)#ip ssh version 2
Gateway.XX(config)#line vty 0 4
Gateway.XX(config-line)#length 0 Gateway.XX(config-line)#transport input ssh
## Configure the Interfaces:
Router>Enable Router#Config terminal
Gateway.XX(config)#interface gi0/0/0 Gateway.XX(config-if)#ip address dhcp Gateway.XX(config-if)#ip nat outside Gateway.XX(config-if)#spanning-tree portfast trunk Gateway.XX(config-if)#no shut**
Gateway.XX(config-if)#int gi0/0/1 Gateway.XX(config-if)#description Internal Gateway Gateway.XX(config-if)#spanning-tree portfast disable Gateway.XX(config-if)#no shut**
Gateway.XX(config-if)#int gi0/0/1.2
Gateway.XX(config-subif)#description routing_xc
Gateway.XX(config-subif)#encap dot1q 2
Gateway.XX(config-subif)#ip address 10.x.2.1 255.255.255.0 (x is state dependent) Gateway.XX(config-subif)#ip nat inside
Gateway.XX(config-subif)#no shut**
Interface Configuration Continued On The Next Page 
Gateway.XX(config-subif)#int gi0/0/1.20
Gateway.XX(config-subif)#description Active Network Gateway.XX(config-subif)#encap dot1q 20
Gateway.XX(config-subif)#ip address 10.x.20.1 255.255.255.0 (x is state dependent) Gateway.XX(config-subif)#no shut**
Gateway.XX(config-if)#int gi0 Gateway.XX(config-if)#vrf forwarding Mgmt-intf Gateway.XX(config-if)#no shut** Gateway.XX(config-if)#exit
## Configuring routing:
Router>Enable Router#Config terminal
Gateway.XX(config)#router eigrp 100
Gateway.XX(config-router)#network 0.0.0.0
Gateway.XX(config-router)#network 10.x.2.0 0.0.0.255 (x is state dependent) Gateway.XX(config-router)#network 10.x.20.0 0.0.0.255 (x is state dependent) Gateway.XX(config-router)#redistribute static
Gateway.XX(config-router)#redistribute connected Gateway.XX(config-router)#passive-interface Gi0/0/0
Gateway.XX(config-router)#exit
Gateway.XX(config)#ip host switch.XX.cmat.lan 10.x.10.3 (XX and x are state dependent)
## Configure route mapping:
Router>Enable
Router#Config terminal
Gateway.XX(config)#route-map track-primary-if permit 1 Gateway.XX(config-rt)#match ip address 197 Gateway.XX(config-rt)#set interface gi0/0/0
## Configure Access Control List:
Router>Enable
Router#Config terminal
Gateway.XX(config)#ip access-list extended NAT
Gateway.XX(config-ext-nacl)#deny ip 10.0.0.0 0.255.255.255 10.0.0.0 0.255.255.255 Gateway.XX(config-ext-nacl)#permit ip 10.0.0.0 0.255.255.255 any Gateway.XX(config)#exit
Gateway.XX(config)#ip nat inside source list NAT interface gi0/0/0 overload Gateway.XX(config)#no ip http server
Gateway.XX(config)#no ip http secure-server
Gateway.XX(config)#ip dns server
## Secure the Router
Gateway.XX(config)#enable secret {enter a password}
X Variable Chart



# Router Setup - Advanced
Physical Connections
Connect the USB D cable to the console port on the front of the Cisco 4321
From a terminal window on you Mac Book Pro you will need to look in the /dev directory for the USB connection (tty.usb something)
Once you find that you will want to screen that connection to connect to it.
Example:
screen /dev/tty.usbmodem
Manual Entry
Would you like to enter the initial configuration dialog? [yes/no]: no Would you like to terminate autoinstall? [yes]: <enter>
If presented with a blank screen press <return>. You are looking for the Router> prompt Router>Enable
Router#Config terminal
Router(config)#hostname gateway.xx
gateway.xx(config)#ip domain-name cmat.lan
gateway.xx(config)#username xadmin privilege 15 secret {enter a password} gateway.xx(config)#username admin privilege 15 secret {enter a password}
Cut & Paste
line con 0
exec-timeout 60 0
length 0
login local
aaa new-model
aaa session-id common
clock timezone CST -6 0
clock summer-time CST recurring
clock calendar-valid
ntp master
crypto key gen rsa usage-keys label ssh-hostkey-rsa4096
Manual Entry (when prompted)
How many bits in the modulus [512]: 4096 How many bits in the modulus [512]: 4096
Cut & Paste
ip ssh rsa keypair-name ssh-hostkey-rsa4096 ip ssh version 2
line vty 0 4
length 0
transport input ssh interface gi0/0/0
ip address dhcp
ip nat outside
spanning-tree portfast trunk no shut
int gi0/0/1
description Internal Gateway


spanning-tree portfast disable no shut
int gi0/0/1.2
description routing_xc
encap dot1q 2
Manual Entry
Gateway.XX(config-subif)#ip address 10.x.2.1 255.255.255.0 (x is state dependent)
Cut & Paste
ip nat inside
no shut
int gi0/0/1.20
description Active Network encap dot1q 20
Manual Entry
Gateway.XX(config-subif)#iip address 10.x.20.1 255.255.255.0 (x is state dependent)
Cut & Paste
no shut
int gi0
vrf forwarding Mgmt-intf no shut
exit
router eigrp 100 network 0.0.0.0
Manual Entry
Gateway.XX(config-router)#network 10.x.2.0 0.0.0.255 (x is state dependent) Gateway.XX(config-router)#network 10.x.20.0 0.0.0.255 (x is state dependent)
Cut & Paste
redistribute static
redistribute connected
passive-interface Gi0/0/0
exit
route-map track-primary-if permit 1
Gateway.XX(config-rt)match ip address 197
Gateway.XX(config-rt)set interface gi0/0/0
ip access-list extended NAT
Gateway.XX(config-ext-nacl)deny ip 10.0.0.0 0.255.255.255 10.0.0.0 0.255.255.255 Gateway.XX(config-ext-nacl)permit ip 10.0.0.0 0.255.255.255 any
exit
ip nat inside source list NAT interface gi0/0/0 overload
no ip http server
no ip http secure-server
ip dns server
Manual Entry
Gateway.XX(config)#ip host switch.XX.cmat.lan 10.x.10.3 (XX and x are state dependent) Gateway.XX(config)#enable secret {enter a password}
