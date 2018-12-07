# OpenVAS

OpenVAS is a framework of several services and tools offering a comprehensive and powerful vulnerability scanning and vulnerability management solution. The framework is part of Greenbone Networks' commercial vulnerability management solution from which developments are contributed to the Open Source community since 2009.

# Installation
1. Build a [virtual machine on the Active virtual network](../vmware/README.md#Create-the-Active-Virtual-Machine)  
1. Ensure that you have created the repo files on your VM so that you can do the install from your Nuc
1. Install OpenVAS `sudo yum install openvas`
1. Remove, or comment out, the check for SELinux being turned off on line 49 - 56, because only animals turn off SELinux  
```
vi /bin/openvas-setup
:set nu
...
49 # Test for selinux
50 SELINUX=$(getenforce)
51 if [ "$SELINUX" != "Disabled" ]; then
52        echo "Error: Selinux is set to ($SELINUX)"
53        echo "  selinux must be disabled in order to use openvas"
54        echo "  exiting...."
55        exit 1
56 fi
...
```
1. Add the `unixsocket` for Redis, and make sure we add it where SELinux will be happy with it  
```
vi /etc/redis.conf
...
unixsocket /run/redis/redis.sock
unixsocketperm 700
```
1. Run the OpenVAS setup script `sudo openvas-setup`  
1. Edit OpenVAS config to point to the correct Redis `unixsocket` add line 97 to the file  
```
vi /etc/openvas/openvassd.conf  
shift+g
:set nu
...
82 #--- Knowledge base saving (can be configured by the client) :
83 # Save the knowledge base on disk :
84 save_knowledge_base = no
85 # Restore the KB for each test :
86 kb_restore = no
87 # Only test hosts whose KB we do not have :
88 only_test_hosts_whose_kb_we_dont_have = no
89 # Only test hosts whose KB we already have :
90 only_test_hosts_whose_kb_we_have = no
91 # KB test replay :
92 kb_dont_replay_scanners = no
93 kb_dont_replay_info_gathering = no
94 kb_dont_replay_attacks = no
95 kb_dont_replay_denials = no
96 kb_max_age = 864000
97 kb_location = /run/redis/redis.sock
98 #--- end of the KB section
...
```
1. Open the firewall for `port 9392` allowing access to the UI
```
firewall-cmd --add-port=9392/tcp --permanent  
firewall-cmd --reload
```
1. Rebuild the NVT database `openvasmd --rebuild`  
1. Reload the services
**NOTE:** they take a while to start up  
```
systemctl restart redis openvas-manager openvas-scanner
```

## Pretty sure this was not needed, the biggest issue is that openvas wants to put the socket in the /tmp dir when it should be under /run/redis
#This is the selinux policy I put into place before moving the socket to the correct directory  
#
#Selinux Policy that was added
##============= redis_t ==============
#allow redis_t tmp_t:dir add_name;
#
##!!!! This avc is allowed in the current policy
# allow redis_t tmp_t:dir write;
#
