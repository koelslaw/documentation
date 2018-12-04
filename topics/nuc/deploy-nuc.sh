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
sudo sed -i 's/repo_gpgcheck=1/repo_gpgcheck=0/' /etc/yum.conf
sudo sed -i 's/localpkg_gpgcheck=1/localpkg_gpgcheck=0/' /etc/yum.conf

################################
##### Collect Credentials ######
################################

# Create your Gitea passphrase

echo "Create your Gitea passphrase for the MySQL database and press [Enter]. You will create your Gitea administration credentials after the installation."
read -s giteapassphrase

# Set your IP address as a variable. This is for instructions below.
IP="$(hostname -I | sed -e 's/[[:space:]]*$//')"

################################
##### Prep for local repo ######
################################
sudo mkdir -p /var/www/html/repo/capes
sudo mkdir -p /var/www/html/repo/grassmarlin
sudo mkdir -p /var/www/html/repo/nmap
sudo curl -L https://github.com/nsacyber/GRASSMARLIN/releases/download/v3.2.1/grassmarlin-3.2.1-1.el6.x86_64.rpm -o /var/www/html/repo/grassmarlin/grassmarlin-3.2.1-1.el6.x86_64.rpm
sudo curl -L https://github.com/mumble-voip/mumble/releases/download/1.2.19/murmur-static_x86-1.2.19.tar.bz2 -o /var/www/html/repo/capes/mattermost.tar.gz
sudo curl -L http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm -o /var/www/html/repo/capes/wandisco-git-release-7-2.noarch.rpm
sudo yum groupinstall "Development Tools" --downloadonly --downloaddir=/var/www/html/repo/capes
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo rpm --import https://dl.bintray.com/cert-bdf/rpm/repodata/repomd.xml.key
sudo curl -L https://dl.bintray.com/thehive-project/rpm-stable/thehive-project-release-1.1.0-1.noarch.rpm -o /var/www/html/repo/capes/thehive-project-release-1.1.0-1.noarch.rpm
sudo curl -L https://dl.gitea.io/gitea/master/gitea-master-linux-amd64 -o /var/www/html/repo/capes/gitea-master-linux-amd64
sudo curl -L https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-5.6.5-x86_64.rpm -o /var/www/html/repo/capes/heartbeat-5.6.5-x86_64.rpm
sudo curl -L https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.6.5-x86_64.rpm -o /var/www/html/repo/capes/filebeat-5.6.5-x86_64.rpm
sudo curl -L https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.6.5-x86_64.rpm -o /var/www/html/repo/capes/metricbeat-5.6.5-x86_64.rpm
sudo curl -L https://artifacts.elastic.co/downloads/kibana/kibana-5.6.5-x86_64.rpm -o /var/www/html/repo/capes/kibana-5.6.5-x86_64.rpm
sudo yum install --downloadonly --downloaddir=/var/www/html/repo/capes epel-release
sudo yum install --downloadonly --downloaddir=/var/www/html/repo/capes mariadb-server firewalld bzip2 npm gcc-c++ git java-1.8.0-openjdk.x86_64 python36u python36u-pip python36u-devel thehive cortex https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.0.rpm https://centos7.iuscommunity.org/ius-release.rpm libffi-devel python-devel python-pip ssdeep-devel ssdeep-libs perl-Image-ExifTool file-devel nginx httpd-tools

################################
########## Gitea ###############
################################

# Big thanks to @seven62 for fixing the Git 2.x and MariaDB issues and getting the service back in the green!

# Install dependencies
sudo yum install /var/www/html/repo/capes/wandisco-git-release-7-2.noarch.rpm /var/www/html/repo/capes/[mariadb-server????.repo] -y
sudo yum update git -y

# Configure MariaDB
sudo systemctl start mariadb.service
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

# Create the Gitea user
sudo useradd -s /usr/sbin/nologin gitea

# Grab Gitea and make it a home
sudo mkdir -p /opt/gitea
sudo cp /var/www/html/repo/capes/gitea-master-linux-amd64 /opt/gitea/gitea
sudo chown -R gitea:gitea /opt/gitea
sudo chmod 744 /opt/gitea/gitea

# Create the Gitea service
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
# Find the current IP address of an interface and assign it to gitea in this example it is interface ens33 which may need to change based on your system
ExecStartPre=bin/bash -c '/bin/sed -i "s,^ROOT_URL.*,$(echo "ROOT_URL = http://$(/sbin/ip -o -4 addr list ens33 | awk '\''{print $4}'\'' | cut -d/ -f1 ):4000/")," /opt/gitea/custom/conf/app.ini'
ExecStart=/opt/gitea/gitea web -p 4000
Restart=always
Environment=USER=gitea HOME=/home/gitea
[Install]
WantedBy=multi-user.target
EOF'

# Prevent remote access to MariaDB
clear
echo "In a few seconds we are going to secure your MariaDB configuration. You'll be asked for your MariaDB root passphrase (which hasn't been set), you'll set the MariaDB root passphrase and then be asked to confirm some security configurations."
sudo sh -c 'echo [mysqld] > /etc/my.cnf.d/bind-address.cnf'
sudo sh -c 'echo bind-address=127.0.0.1 >> /etc/my.cnf.d/bind-address.cnf'
sudo systemctl restart mariadb.service
mysql_secure_installation

# Prepare the service environment
sudo systemctl daemon-reload

# Start Gitea
sudo systemctl start gitea.service

# Allow the services through the firewall
sudo firewall-cmd --add-service=ftp --add-service=http --add-service=https --add-port=69/tcp --add-port=69/udp --permanent
sudo firewall-cmd --reload

# Enable xinetd and Apache at startup
# sudo systemctl enable xinetd
# sudo systemctl enable httpd

# Start xinetd and Apache
# sudo systemctl start xinetd
# sudo systemctl start httpd

################################
########## Remove gcc ##########
################################
sudo yum -y remove gcc-c++

###############################
### Clear your Bash history ###
###############################
# We don't want anyone snooping around and seeing any passphrases you set
cat /dev/null > ~/.bash_history && history -c

# Success page
echo "Your NUC has sucessfully be configured now it's time to deploy the servers."
