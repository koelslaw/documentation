# OpenVAS

OpenVAS is a framework of several services and tools offering a comprehensive and powerful vulnerability scanning and vulnerability management solution. The framework is part of Greenbone Networks' commercial vulnerability management solution from which developments are contributed to the Open Source community since 2009.

> Note: While the differences are small between CENTOS and RHEL there are differences. In this case, unless there is a mission critical need to install RHEL, I recommend installing CENTOS. The packages needed for install are not available in the RHEL repos. Yuo have a couple of courses of action here. If you have to use RHEL then you can either add the centos repos or use the instructions below for the necessary packages
## Installation
- Build a [virtual machine on the Active virtual network](../vmware/README.md#Create-the-Active-Virtual-Machine)  
- Install OS in accordance with [Rhel Documentation](../rhel/README.md)
- Enable only the `rhel-7-server-rpms` and `atomic` repos. `epel` will really throw things of if its enabled.
- Download and install the following packages to prep for OpenVAS installation:
    - Perl-File-Remove
        - `wget https://centos.pkgs.org/7/openfusion-x86_64/perl-File-Remove-1.52-1.of.el7.noarch.rpm`
        - `sudo rpm -vi perl-File-Remove-1.52-1.of.el7.noarch.rpm`
    - Perl-Parse-RecDescent
        - `wget https://mirror.centos.org/centos/7/os/x86_64/Packages/perl-Parse-RecDescent-1.967009-5.el7.noarch.rpm` 
        - `sudo rpm -vi perl-Parse-RecDescent-1.967009-5.el7.noarch.rpm` 
- Install the following tools if not already installed, install the following: `wget` and `net-tools`,
- Install OpenVAS `sudo yum install openvas`
- Remove, or comment out, the check for SELinux being turned off on line 49 - 56, **because only animals turn off SELinux**  
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

- Run the OpenVAS setup script `sudo openvas-setup`  
- Edit OpenVAS config to point to the correct Redis `unixsocket` add line 97 to the file  
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
- Open the firewall for `port 9392` allowing access to the UI
```
firewall-cmd --add-port=9392/tcp --permanent  
firewall-cmd --reload
```

- Add the `unixsocket` for Redis, and make sure we add it where SELinux will be happy with it  
```
vi /etc/redis.conf
...
unixsocket /run/redis/redis.sock
unixsocketperm 700
```

- Rebuild the NVT database  
```
sudo systemclt start redis.service
openvasmd --rebuild
systemctl restart redis openvas-manager.service openvas-scanner.service
```
Move to [Nmap](./nmap/README.md)
