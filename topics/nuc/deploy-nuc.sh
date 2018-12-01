#!/bin/bash
# Cant take credit for much of this. Andy Pease created much of the base for this script (NTP, Gitea)

################################
######### Epel Release #########
################################
# The DISA STIG for CentOS 7.4.1708 enforces a GPG signature check for all repodata. While this is generally a good idea, it causes repos tha do not use GPG Armor to fail.
# One example of a repo that does not use GPG Armor is Epel; which is a dependency of CAPES (and tons of other projects, for that matter).
# To fix this, we are going to disable the GPG signature and local RPM GPG signature checking.
# I'm open to other options here.
# RHEL's official statement on this: https://access.redhat.com/solutions/2850911
# sudo sed -i 's/repo_gpgcheck=1/repo_gpgcheck=0/' /etc/yum.conf
# sudo sed -i 's/localpkg_gpgcheck=1/localpkg_gpgcheck=0/' /etc/yum.conf

################################
##### Collect Credentials ######
################################

# Create your Gitea passphrase

echo "Create your Gitea passphrase for the MySQL database and press [Enter]. You will create your Gitea administration credentials after the installation."
read -s giteapassphrase

# Set your ip stuffs
#
# echo "What will be the static ip of simplerock.lan? EX: 192.168.1.10. If you do not want the nuc to handle dns and dhcp for you then adjust /etc/dnsmasq.conf accordingly"
# read staticip
#
# echo "What will be the starting ip in the ip range of simplerock.lan? EX: 192.168.1.100."
# read iprangestart
#
# echo "What will be the ending ip in the ip range of simplerock.lan? EX: 192.168.1.200."
# read iprangeend
#
# echo "What will be the ip address of esxi1.simplerock.lan? EX: 192.168.1.101."
# read esxi1
#
# echo "What will be the the ip address of esxi2.simplerock.lan? EX: 192.168.1.102."
# read esxi2
#


# Set your IP address as a variable. This is for instructions below.
IP="$(hostname -I | sed -e 's/[[:space:]]*$//')"


################################
##### Prep for local repo ######
################################
# sudo mkdir -p /var/www/html/repo/capes
# sudo mkdir -p /var/www/html/repo/grassmarlin
# sudo wget -P /var/www/html/repo/capes/ https://github.com/mumble-voip/mumble/releases/download/1.2.19/murmur-static_x86-1.2.19.tar.bz2
# sudo wget -P /var/www/html/repo/capes/ http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
# sudo yum groupinstall "Development Tools" --downloadonly --downloaddir=/var/www/html/repo/capes
# sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
# sudo rpm --import https://dl.bintray.com/cert-bdf/rpm/repodata/repomd.xml.key
# sudo wget -P /var/www/html/repo/capes/ https://dl.bintray.com/thehive-project/rpm-stable/thehive-project-release-1.1.0-1.noarch.rpm
# sudo wget -P /var/www/html/repo/capes/ https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-5.6.5-x86_64.rpm
# sudo wget -P /var/www/html/repo/capes/ https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.6.5-x86_64.rpm
# sudo wget -P /var/www/html/repo/capes/ https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.6.5-x86_64.rpm
# sudo wget -P /var/www/html/repo/capes/ https://artifacts.elastic.co/downloads/kibana/kibana-5.6.5-x86_64.rpm
# sudo yum install --downloadonly --downloaddir=/var/www/html/repo/capes epel-release mariadb-server ansible firewalld bzip2 npm gcc-c++ git java-1.8.0-openjdk.x86_64 python36u python36u-pip python36u-devel thehive cortex https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.0.rpm https://centos7.iuscommunity.org/ius-release.rpm libffi-devel python-devel python-pip ssdeep-devel ssdeep-libs perl-Image-ExifTool file-devel nginx httpd-tools


################################
## Run Ansible and DNS Stuff  ##
################################


# I will be moving as much as possible from sh to ansible over time but finishing is a feature

sudo ansible-playbook -vv /home/$USER/mozarkite/playbooks/NUC/build-nuc-playbook.yml


################################
######## Configure NTP #########
################################
#
# Set your time to UTC, this is crucial. If you have already set your time in accordance with your local standards, you may comment this out.
# If you're not using UTC, I strongly recommend reading this: http://yellerapp.com/posts/2015-01-12-the-worst-server-setup-you-can-make.html
# sudo timedatectl set-timezone UTC
#
# # Set NTP. If you have already set your NTP in accordance with your local standards, you may comment this out.
# sudo bash -c 'cat > /etc/chrony.conf <<EOF
# # Use public servers from the pool.ntp.org project.
# # Please consider joining the pool (http://www.pool.ntp.org/join.html).
# server 0.centos.pool.ntp.org iburst
# server 1.centos.pool.ntp.org iburst
# server 2.centos.pool.ntp.org iburst
# server 3.centos.pool.ntp.org iburst
# # Ignore stratum in source selection.
# stratumweight 0
# # Record the rate at which the system clock gains/losses time.
# driftfile /var/lib/chrony/drift
# # Enable kernel RTC synchronization.
# rtcsync
# # In first three updates step the system clock instead of slew
# # if the adjustment is larger than 10 seconds.
# makestep 10 3
# # Allow NTP client access from local network.
# #allow 192.168/16
# # Listen for commands only on localhost.
# bindcmdaddress 127.0.0.1
# # bindcmdaddress ::
# # Serve time even if not synchronized to any NTP server.
# #local stratum 10
# keyfile /etc/chrony.keys
# # Specify the key used as password for chronyc.
# commandkey 1
# # Generate command key if missing.
# generatecommandkey
# # Disable logging of client accesses.
# noclientlog
# # Send a message to syslog if a clock adjustment is larger than 0.5 seconds.
# logchange 0.5
# logdir /var/log/chrony
# #log measurements statistics tracking
# EOF'
# sudo systemctl enable chronyd.service
# sudo systemctl start chronyd.service

################################
########## Gitea ###############
################################

Configure MariaDB
mysql -u root -e "CREATE DATABASE gitea;"
mysql -u root -e "GRANT ALL PRIVILEGES ON gitea.* TO 'gitea'@'localhost' IDENTIFIED BY '$giteapassphrase';"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root -e "set global innodb_file_format = Barracuda;
set global innodb_file_per_table = on;
set global innodb_large_prefix = 1;
use gitea;
CREATE TABLE oauth2_session (
  id varchar(400) NOT NULL,
  data text,
  created_unix bigint(20) DEFAULT NULL,
  updated_unix bigint(20) DEFAULT NULL,
  expires_unix bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE oauth2_session
  ADD PRIMARY KEY (id(191));
COMMIT;"

# Prevent remote access to MariaDB
sudo sh -c 'echo [mysqld] > /etc/my.cnf.d/bind-address.cnf'
sudo sh -c 'echo bind-address=127.0.0.1 >> /etc/my.cnf.d/bind-address.cnf'
sudo systemctl restart mariadb.service

# Create the Gitea user
sudo useradd -s /usr/sbin/nologin gitea

# Grab Gitea and make it a home
# sudo mkdir -p /opt/gitea
# sudo curl -o /opt/gitea/gitea https://dl.gitea.io/gitea/master/gitea-master-linux-amd64
# sudo chown -R gitea:gitea /opt/gitea
# sudo chmod 744 /opt/gitea/gitea

# Configure the firewall
# Port 4000 - Gitea
# sudo firewall-cmd --add-port=4000/tcp --permanent
# sudo firewall-cmd --reload


sudo bash -c 'cat > /etc/xinetd.d/tftp <<EOF
service tftp
{
  socket_type		= dgram
  protocol		= udp
  wait			= yes
  user			= root
  server			= /usr/sbin/in.tftpd
  server_args		= -c -s /tftpboot
  disable			= no
  per_source		= 15
  cps			    = 80 2
  flags			= IPv4
}
EOF'


Create the Gitea service
sudo bash -c 'cat > /etc/systemd/system/gitea.service <<EOF
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
After=mariadb.service
[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
RestartSec=2s
Type=simple
User=gitea
Group=gitea
WorkingDirectory=/opt/gitea
ExecStart=/opt/gitea/gitea web -p 4000
Restart=always
Environment=USER=gitea HOME=/home/gitea
[Install]
WantedBy=multi-user.target
EOF'

# Prepare the service environment
sudo systemctl daemon-reload

# Secure MySQL installtion
mysql_secure_installation

# Start Gitea
sudo systemctl start gitea.service

###############################
####### Setup PXIE boot #######
###############################

# #make changes to dnsmasq to for DNS
# sudo bash -c 'cat > /etc/dnsmasq.conf <<EOF
# domain-needed
# bogus-priv
#
# domain=simplerock.lan
# expand-hosts
# local=/simplerock.lan/
#
# listen-address='$staticip'
# dhcp-range=lan,'$iprangestart','$iprangeend'
# dhcp-option=lan,3,'$staticip'
# dhcp-option=lan,6,'$staticip'
# bind-interfaces
#
# dhcp-boot=pxelinux.0
# pxe-prompt="press f8 for menu, or just wait and it will boot ROCK NSM: ", 15
# pxe-service=X86PC, "simplerock.lan",pxelinux
# enable-tftp
# tftp-root=/var/lib/tftpboot
# EOF'
#
# #setup tftpboot
# # sudo mkdir /var/lib/tftpboot/pxelinux.cfg
# sudo cp -a /usr/share/syslinux/* /var/lib/tftpboot
#
# # add additional boot options to this file
# sudo bash -c 'cat > /var/lib/tftpboot/pxelinux.cfg/default <<EOF
# default vesamenu.c32
# prompt 0
# timeout 50
#
# LABEL 1
#     MENU LABEL ^1) Install CentOS 7 - HTTP
#     KERNEL data/centos7_64Bit/images/pxeboot/vmlinuz
#     APPEND initrd=data/centos7_64Bit/images/pxeboot/initrd.img method=http://nuc.simplerock.lan/centos7_64Bit devfs=nomount inst.geoloc=0
#
# LABEL 2
#     MENU LABEL ^2) Install RockNSM - HTTP
#     KERNEL data/rocknsm/images/pxeboot/vmlinuz
#     APPEND initrd=data/rocknsm/images/pxeboot/initrd.img method=http://nuc.simplerock.lan/rocknsm devfs=nomount inst.geoloc=0
#
# LABEL 3
#     MENU LABEL ^3) Boot local hard drive
#     LOCALBOOT 0
# EOF'
#
#
# #configure some dns entries for dnsmasq
# sudo bash -c 'cat > /etc/hosts <<EOF
# #just the subdomain is required, dnsmasq adds simplerock.lan on the fly
# 127.0.0.1   localhost
# ::1         localhost
# '$staticip' nuc
# '$esxi1'    esxi1
# '$esxi2'    esxi2
# EOF'


# #mount the centos iso for pxeboot
# sudo mount -o loop /var/www/html/iso/CentOS-7-x86_64-DVD-1804.iso  /mnt/
# sudo mkdir /var/www/html/centos7_64Bit
# sudo mkdir /var/lib/tftpboot/data/
# sudo mkdir /var/lib/tftpboot/data/centos7_64Bit/
# sudo cp -fr /mnt/* /var/www/html/centos7_64Bit/
# sudo cp -fr /mnt/* /var/lib/tftpboot/data/centos7_64Bit/
# sudo umount /mnt/
#
# #mount the rock nsm iso for pxeboot
# sudo mount -o loop /var/www/html/isos/rocknsm-2.2.0.iso  /mnt/
# sudo mkdir /var/www/html/rocknsm
# sudo mkdir /var/lib/tftpboot/data/rocknsm/
# sudo cp -fr /mnt/* /var/www/html/rocknsm/
# sudo cp -fr /mnt/* /var/lib/tftpboot/data/rocknsm/
# sudo umount /mnt/

#allow the services through the firewall
# sudo firewall-cmd --add-service=dhcp --permanent
# sudo firewall-cmd --add-service=dns --permanent
# sudo firewall-cmd --add-service=ftp --permanent
# sudo firewall-cmd --add-port=69/tcp --permanent
# sudo firewall-cmd --add-port=69/udp --permanent
# sudo firewall-cmd --add-port=53/tcp --permanent
# sudo firewall-cmd --add-port=53/udp --permanent
# sudo firewall-cmd --add-port=80/tcp --permanent
# sudo firewall-cmd --add-port=443/udp --permanent
# sudo firewall-cmd --add-port=4011/udp --permanent
# sudo firewall-cmd --reload

# # Start services
# sudo systemctl start dnsmasq
# sudo systemctl start xinetd
# sudo systemctl start httpd
#
# # enable them at startup
# sudo systemctl enable dnsmasq
# sudo systemctl enable xinetd
# sudo systemctl enable httpd

sudo ansible-playbook -vv /home/$USER/mozarkite/playbooks/NUC/Restart_NUC_Services.yml




###############################
### Clear your Bash history ###
###############################
# We don't want anyone snooping around and seeing any passphrases you set
cat /dev/null > ~/.bash_history && history -c

# Success page


echo "Your NUC has sucessfully be configured now it's time to deploy the servers."
