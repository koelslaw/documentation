# Rock Software Deployment


Here is where stuff gets interesting. the ROCK deploy script is used to
configure a standalone sensor on 1 box for testing/eval. our kit is broken
into 2 pieces so the deploy script does a lot of the configuration for us but
it needs some tweaking to make it happen. This is where I plan on making
significant improvement in the future.


## Prereqs
  - ESXi Installed
  - DNS Server Up and Running
    - RHEL Installed
      - NUC Repos Configured
  - RHEL Installed
    - NUC Repos Configured
___



## Configuration Walkthrough

The primary configuration file for ROCK is `/etc/rocknsm/config.yml`.  This file contains key variables like network interface setup, cpu cores utilized, and more.  Here's the ***default*** config file after initial install:  

```yml
---
# These are all the current variables that could affect
# the configuration of ROCKNSM. Take care when modifying
# these. The defaults should be used unless you really
# know what you are doing!

# interfaces that should be configured for sensor applications
rock_monifs:
    - enp0s3

# Secifies the hostname of the sensor
rock_hostname: simplerockbuild
# the FQDN
rock_fqdn: simplerockbuild.simplerock.lan
# the number of CPUs that bro will use
bro_cpu: 1
# name of elasticsearch cluster
es_cluster_name: rocknsm
# name of node in elasticsearch cluster
es_node_name: simplerockbuild
# how much memory to use for elasticsearch
es_mem: 1
# (optional) personal configured key for pulled pork to pull latest sigs from snort.org
pulled_pork_oinkcode: 796f26a2188c4c953ced38ff3ec899d8ae543350

########## Offline/Enterprise Network Options ##############

# configure if this system may reach out to the internet
# (configured repos below) during configuration
rock_online_install: False
# (online) enable RockNSM testing repos
rock_enable_testing: False
# (online) the URL for the EPEL repo mirror
epel_baseurl: http://download.fedoraproject.org/pub/epel/$releasever/$basearch/
# (online) the URL for the EPEL GPG key
epel_gpgurl: https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
# (online) the URL for the elastic repo mirror
elastic_baseurl: https://artifacts.elastic.co/packages/6.x/yum
# (online) the URL for the elastic GPG key
elastic_gpgurl: https://artifacts.elastic.co/GPG-KEY-elasticsearch
# (online) the URL for the rocknsm repo mirror
rocknsm_baseurl: https://packagecloud.io/rocknsm/2_1/el/7/$basearch
# (online) the URL for the rocknsm GPG key
rocknsm_gpgurl: https://packagecloud.io/rocknsm/2_1/gpgkey

# (offline) the filesytem path for a local repo if doing an "offline" install
rocknsm_local_baseurl: file:///srv/rocknsm
# (offline) disable the gpgcheck features for local repos, contingent on a kickstart
# test checking for /srv/rocknsm/repodata/repomd.xml.asc
rock_offline_gpgcheck: 1

# the git repo from which to checkout rocknsm customization scripts for bro
bro_rockscripts_repo: https://github.com/rocknsm/rock-scripts.git

# the git repo from which pulled pork should be installed
pulled_pork_repo: https://github.com/shirkdog/pulledpork.git

#### Retention Configuration ####
elastic_close_interval: 15
elastic_delete_interval: 60
kafka_retention: 168
suricata_retention: 3
bro_log_retention: 0
bro_stats_retention: 0

### Advanced Feature Selection ######
# Don't flip these unless you know what you're doing
with_stenographer: True
with_docket: True
with_bro: True
with_suricata: True
with_snort: False
with_pulledpork: False
with_logstash: True
with_filebeat: True
with_elasticsearch: True
with_kibana: True
with_zookeeper: True
with_kafka: True
with_nginx: True
with_lighttpd: True
with_fsf: True

# Specify if a service is enabled on startup
enable_stenographer: False
enable_docket: False
enable_bro: True
enable_suricata: True
enable_snort: False
enable_pulledpork: False
enable_logstash: True
enable_filebeat: True
enable_elasticsearch: True
enable_kibana: True
enable_zookeeper: True
enable_kafka: True
enable_nginx: True
enable_lighttpd: True
enable_fsf: False

```

All these tunable options are commented to describe the function of each section, but here are some key points to note starting out:  

### Monitor Interface

As mentioned previously, ROCK takes the interface with a default gateway and will uses as MGMT.  Line 8 in `config.yml` displays the remaining interfaces that will be used to MONITOR traffic.  Here's a snippet from an example VM with 2 NICS:

This box has 2 NICS: `enp0s3` was plugged in during install and received IP from DHCP server.  This is used as MGMT.  
```
[admin@localhost ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:06:54:e5 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.207/24 brd 192.168.1.255 scope global noprefixroute dynamic enp0s3
    ...
3: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:ca:f0:bb brd ff:ff:ff:ff:ff:ff
```

Lines 7 - 9 of `/etc/rocknsm/config.yml` show that the other interface (`enp0s3`) is listed as MONITOR interface.
```
7 # interfaces that should be configured for sensor applications
8 rock_monifs:
9     - enp0s3
```

### Online / Offline Install

We've taken into consideration that your sensor won't always have internet access.  The ISO's default value is set for the offline use case:  

```yml
28 # configure if this system may reach out to the internet
29 # (configured repos below) during configuration
30 rock_online_install: False
```

If your sensor does have access to get to online repos just set `rock_online_install: True`, Ansible will configure your system for the yum repositories listed and pull packages and git repos directly from the URLs shown. You can easily point this to local mirrors if needed.  

<!-- If this value is set to `False`, Ansible will look for the cached files in `/srv/rocknsm`. There is another script called `offline-snapshot.sh` that will create the necessary repository and file structure. Run this from a system that is Internet connected and copy it to your sensors for offline deployment. -->

### Lots More...

There are a lot of options to tune here, so take time to famililiarize a be make sure to check out the last two sections starting at `line 65`.  Here you are given boolean options to choose what components of ROCK are **_installed_** and **_enabled_** out of the box.  

For instance, collecting raw PCAP is resource and storage intensive.  If you're machine may not be able to handle that and just want to focus on network logs, then set:  

```
67 with_stenographer: False
  ...
83 enable_stenographer: False
```

### Generate Defaults

So what happens when you've completely mucked things up in your config and need to get back to basic default settings?  There's a script for that called `generate_defaults.sh` located in `/opt/rocknsm/rock/bin/`.  

```
[admin@localhost ~]$ ls /opt/rocknsm/rock/bin
generate_defaults.sh
deploy_rock.sh
```

This script will regenerate a fresh default `config.yml` for you and get you out of jail.  If you need to reset things you can execute this script by running:  


`sudo ./deploy_rock.sh`

disable fips

```
sudo vim /etc/default/grub
```
and issue Restart

```
sudo reboot
```

## Deploy

Once your `config.yml` file is tuned to suit your environment, it's finally time to **deploy this thing**.  This is done by running the deployment script located in `/opt/rocknsm/rock/bin/`.

Kick off the Ansible deploy script:  `sudo ./deploy_rock.sh`  

If everything is well, this should set up all the components you selected and give you a success banner similar to the example below:

![](https://asciinema.org/a/2rS2u1fJzhaNVtkuKWgqd5BQl.png)

## Initial Kibana Access

We strive to do the little things right, so rather than having Kibana available to everyone in the free world it's sitting behind an Nginx reverse proxy. It's also secured by a [passphrase](https://xkcd.com/936/).  The credentials are generated and then stored in the home directory of the user you created during the initial installation e.g. `/home/admin`.

1. `cat` and copy the contents of `~/KIBANA_CREDS.README`
1. browse to (https://)<MGMT-IP>
1. enter this user / password combo
1. profit

# Functions Checks

After the initial build, the ES cluster will be yellow because the marvel index will think it's missing a replica. Run this to fix this issue. This job will run from cron just after midnight every day:

- `/usr/local/bin/es_cleanup.sh 2>&1 > /dev/null`

Check to see that the ES cluster says it's green:

- `curl -s localhost:9200/_cluster/health | jq '.'`

See how many documents are in the indexes. The count should be non-zero:

- `curl -s localhost:9200/_all/_count | jq '.'`

You can fire some traffic across the sensor at this point to see if it's collecting. NOTE: This requires that you upload your own test PCAP to the box.

- `sudo tcpreplay -i [your monitor interface] /path/to/a/test.pcap`

After replaying some traffic, or just waiting a bit, the count should be going up.

You should have plain text bro logs showing up in /data/bro/logsM/current/:

- `ls -ltr /data/bro/logs/current/`

___
## Preperation for Deployment


### FIPS

 Disable FIPS
```
sudo grubby --update-kernel=ALL --remove-args=fips=1
```

```
sudo yum remove dracut-fips\*
```

```
sudo dracut
```
Carefully update the grub file and set the fips = 0
```
sudo vim /etc/default/grub
```

### Install supporting software
Normally this is handled the installation script but we are doing this via the nuc.
```
sudo yum install jq GeoIP geopipupdate tcpreplay tcpdump bats policycoreutils-python htop vim git tmux nmap-ncat logrotate perl-LWP-Protocol-https perl-Sys-Syslog perl-Crypt-SSLeay perl-Archive-Tar java-1.8.0-openjdk-headless filebeat
```


### Generate Defaults

prep the box for ansible deployment by installing ansible

```
sudo yum install ansible
```
Clone the Following Repos
  - rock
  - rock-dashboards
  - rock-scripts

```
mkdir /opt/var/rocknsm/
```

```
cd /opt/var/rocknsm/  
```

```
git clone http://nuc.[STATE].cmat.lan/administrator/rock.git
```

navigate the correct directory

```
cd /opt/var/rock/bin/
```
Generate the defaults for the sensor

```
sudo sh generate_defaults.sh
```

That should give a config file, /etc/rocknsm/config.yml . Edit that file using vi.


```
sudo vi /etc/rocknsm/config.yml
```

Set the config file to the following configuration:

- Sensor Config

  Make note of the interfaces here. For the CMAT kit they are interface 3 & 4 which are the 2 copper interfaces for the cmat kit

  Add the approipriate state to the config file and chenge the hostname to sensor. The elastic stuff can be ignored as it will not be used on the sensor side.

  The following items will be on the sensor
   - stenographer
   - bro
   - suricata
   - suricata_update
   - zookeeper
   - kafka
   - fsf


```yml
---
# These are all the current variables that could affect
# the configuration of ROCKNSM. Take care when modifying
# these. The defaults should be used unless you really
# know what you are doing!

# interfaces that should be configured for sensor applications
rock_monifs:
    - em4
    - em3

# Secifies the hostname of the sensor
rock_hostname: sensor
# the FQDN
rock_fqdn: sensor.[STATE].cmat.lan
# the number of CPUs that bro will use
bro_cpu: 15
# name of elasticsearch cluster
es_cluster_name: rocknsm
# name of node in elasticsearch cluster
es_node_name: simplerockbuild
# how much memory to use for elasticsearch
es_mem: 31

########## Offline/Enterprise Network Options ##############

# configure if this system may reach out to the internet
# (configured repos below) during configuration
rock_online_install: False
# (online) enable RockNSM testing repos
rock_enable_testing: False
# (online) the URL for the EPEL repo mirror
epel_baseurl: http://download.fedoraproject.org/pub/epel/$releasever/$basearch/
# (online) the URL for the EPEL GPG key
epel_gpgurl: https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
# (online) the URL for the elastic repo mirror
elastic_baseurl: https://artifacts.elastic.co/packages/6.x/yum
# (online) the URL for the elastic GPG key
elastic_gpgurl: https://artifacts.elastic.co/GPG-KEY-elasticsearch
# (online) the URL for the rocknsm repo mirror
rocknsm_baseurl: https://packagecloud.io/rocknsm/2_2/el/7/$basearch
# (online) the URL for the rocknsm GPG key
rocknsm_gpgurl: https://packagecloud.io/rocknsm/2_2/gpgkey

#
rock_disable_offline_repo: True
# (offline) the filesytem path for a local repo if doing an "offline" install
rocknsm_local_baseurl: http://nuc.[STATE].cmat.lan/
# (offline) disable the gpgcheck features for local repos, contingent on a kickstart test checking for /srv/rocknsm/repodata/repomd.xml.asc
rock_offline_gpgcheck: 0

# the git repo from which to checkout rocknsm customization scripts for bro
bro_rockscripts_repo: http://nuc.[STATE].cmat.lan:4000/administrator/rock-scripts.git

#### Retention Configuration ####
elastic_close_interval: 15
elastic_delete_interval: 60
# Kafka retention is in Hour
kafka_retention: 168
# Log Retemtion in Days
bro_log_retention: 0
bro_stats_retention: 0
suricata_retention: 3
fsf_retention: 3

### Advanced Feature Selection ######
# Don't flip these unless you know what you're doing
with_stenographer: True
with_docket: False
with_bro: True
with_suricata: True
with_snort: False
with_suricata_update: True
with_logstash: False
with_elasticsearch: False
with_kibana: False
with_zookeeper: True
with_kafka: True
with_lighttpd: False
with_fsf: True

# Specify if a service is enabled on startup
enable_stenographer: True
enable_docket: False
enable_bro: True
enable_suricata: True
enable_snort: False
enable_suricata_update: True
enable_logstash: False
enable_elasticsearch: False
enable_kibana: False
enable_zookeeper: True
enable_kafka: True
enable_lighttpd: False
enable_fsf: True

```

- Data Tier (Elasticseach config)

We basically flip the "with" and "enable" bits in the opposite direction. This time we setup the elastic information.
A thing to note there are 3 elastic virtual machines in ESXi. 1 of the 3 will have kibana while the others will just have logstash and elasticsearch. We only need 1 kibana for all the analyst to reach.  

The elasticsearch nodes will coordinate with each other to share the data. We can keep adding elastic resources if hardware will allow it.

Enter the unique hostname for  the vm: es1
the FQDN:
```yml
---
# These are all the current variables that could affect
# the configuration of ROCKNSM. Take care when modifying
# these. The defaults should be used unless you really
# know what you are doing!

# interfaces that should be configured for sensor applications
rock_monifs:

# Secifies the hostname of the sensor
rock_hostname: es[#] [NAME OF THE ELASTICSEARCH NODE]
# the FQDN
rock_fqdn: [NAME OF THE ELASTICSEARCH NODE].[STATE].cmat.lan
# the number of CPUs that bro will use
bro_cpu: 6
# name of elasticsearch cluster
es_cluster_name: rocknsm [NAME OF CLUSTER]
# name of node in elasticsearch cluster
es_node_name: es[#] [NAME OF THE ELASTICSEARCH NODE]
# how much memory to use for elasticsearch
es_mem: 8

########## Offline/Enterprise Network Options ##############

# configure if this system may reach out to the internet
# (configured repos below) during configuration
rock_online_install: False
# (online) enable RockNSM testing repos
rock_enable_testing: False
# (online) the URL for the EPEL repo mirror
epel_baseurl: http://download.fedoraproject.org/pub/epel/$releasever/$basearch/
# (online) the URL for the EPEL GPG key
epel_gpgurl: https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
# (online) the URL for the elastic repo mirror
elastic_baseurl: https://artifacts.elastic.co/packages/6.x/yum
# (online) the URL for the elastic GPG key
elastic_gpgurl: https://artifacts.elastic.co/GPG-KEY-elasticsearch
# (online) the URL for the rocknsm repo mirror
rocknsm_baseurl: https://packagecloud.io/rocknsm/2_2/el/7/$basearch
# (online) the URL for the rocknsm GPG key
rocknsm_gpgurl: https://packagecloud.io/rocknsm/2_2/gpgkey

#
rock_disable_offline_repo: True
# (offline) the filesytem path for a local repo if doing an "offline" install
rocknsm_local_baseurl: file:///srv/rocknsm
# (offline) disable the gpgcheck features for local repos, contingent on a kickstart test checking for /srv/rocknsm/repodata/repomd.xml.asc
rock_offline_gpgcheck: 0

# the git repo from which to checkout rocknsm customization scripts for bro
bro_rockscripts_repo: https://nuc.[STATE].cmat.lan:4000/administrator/rock-scripts.git

#### Retention Configuration ####
elastic_close_interval: 15
elastic_delete_interval: 60
# Kafka retention is in Hour
kafka_retention: 168
# Log Retemtion in Days
bro_log_retention: 0
bro_stats_retention: 0
suricata_retention: 3
fsf_retention: 3

### Advanced Feature Selection ######
# Don't flip these unless you know what you're doing
with_stenographer: False
with_docket: True
with_bro: False
with_suricata: False
with_snort: False
with_suricata_update: False
with_logstash: True
with_elasticsearch: True
with_kibana: True
with_zookeeper: False
with_kafka: False
with_lighttpd: True
with_fsf: False

# Specify if a service is enabled on startup
enable_stenographer: False
enable_docket: True
enable_bro: False
enable_suricata: False
enable_snort: False
enable_suricata_update: False
enable_logstash: True
enable_elasticsearch: True
enable_kibana: True
enable_zookeeper: False
enable_kafka: False
enable_lighttpd: True
enable_fsf: False


```

### Remove the orphaned repo
The epel gets loaded into /etc/yum.repos.d/ during the generate defaults script and it gets in the way of installation. we alerady have that as part of our nuc so we need to  do some housekeeping to clean that up


```
sudo rm /etc/yum.repos.d/epel.repo
```

### Stage rock-scripts and rock-dashboads
Tar the repos so they will be in the right format for the rock deploy script
```
tar -zcvf rock-dashboards-master.tar.gz rock-dashboards-master
```

```
tar -zcvf rock-scripts_master.tar.gz rock-scripts-master
```
Copy them to the need directory

```
sudo cp ~/rock-dashboards_master.tar.gz /srv/rocknsm/support/rock-dashboards_master.tar.gz
```
```
sudo cp ~/rock-scripts_master.tar.gz /srv/rocknsm/support/rock-dashboards_master.tar.gz
```

# FIRE ZE LAZORZZZZ!!!!
With the current setup, the ansible script doesnt play nicely with the with the shell script wrapper. So we will deploy the ansible script directly.

Navigate to the ~/rock/playbooks

```
cd /rock/playbooks
```

And then deploy

```
sudo ansible-playbook -K deploy-rock.yml
```
It should complete with **no** errors

### Connecting the sensor parts to each other
Once we have the servers up and running no it time to tie everything together. below is the config files for each part of the sensor. take note on which server you are on (Elastic, Elastic with Kibana, Sensor). Working dns is needed here unless you are going to hardcode the values.

Edit the config files as follows:
#### EL & ELK VMs

##### /etc/logstash/conf.d/logstash-100-input-kafka-bro.conf

```
input {
 kafka {
   topics => ["bro-raw"]
   add_field => { "[@metadata][stage]" => "broraw_kafka" }
   # Set this to one per kafka partition to scale up
   #consumer_threads => 4
   group_id => "bro_logstash"
   bootstrap_servers => "sensor.[STATE].cmat.lan:9092"
   codec => json
   auto_offset_reset => "earliest"
 }
}
```

##### /etc/logstash/conf.d/logstash-100-input-kafka-fsf.conf

```
input {
 kafka {
   topics => ["fsf-raw"]
   add_field => { "[@metadata][stage]" => "fsfraw_kafka" }
   # Set this to one per kafka partition to scale up
   #consumer_threads => 4
   group_id => "fsf_logstash"
   bootstrap_servers => "sensor.[STATE].cmat.lan:9092"
   codec => json
   auto_offset_reset => "earliest"
 }
}
```

##### /etc/logstash/conf.d/logstash-100-input-kafka-suricata.conf

```
input {
 kafka {
   topics => ["suricata-raw"]
   add_field => { "[@metadata][stage]" => "suricataraw_kafka" }
   # Set this to one per kafka partition to scale up
   #consumer_threads => 4
   group_id => "suricata_logstash"
   bootstrap_servers => "sensor.[STATE].cmat.lan:9092"
   codec => json
   auto_offset_reset => "earliest"
 }
}
```

##### /etc/logstash/conf.d/logstash-999-output-es-bro.conf

```
output {
   if [@metadata][stage] == "broraw_kafka" {
#        kafka {
#          codec => json
#          topic_id => "bro-%{[@meta][event_type]}"
#          bootstrap_servers => "127.0.0.1:9092"
#        }

       elasticsearch {
           hosts => ["es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan"]
           index => "bro-%{[@meta][event_type]}-%{+YYYY.MM.dd}"
           template => "/opt/rocknsm/rock/playbooks/files/es-bro-mappings.json"
           document_type => "_doc"
       }
   }
}
```

##### /etc/logstash/conf.d/logstash-999-output-es-fsf.conf

```
output {
 if [@metadata][stage] == "fsfraw_kafka" {
#    kafka {
#     codec => json
#     topic_id => "fsf-clean"
#     bootstrap_servers => "127.0.0.1:9092"
#    }

   elasticsearch {
     hosts => ["es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan"]
     index => "fsf-%{+YYYY.MM.dd}"
     manage_template => false
     document_type => "_doc"
   }
 }
}
```

##### /etc/logstash/conf.d/logstash-999-output-es-suricata.conf

```
output {
 if [@metadata][stage] == "suricataraw_kafka" {
#    kafka {
#     codec => json
#     topic_id => "suricata-clean"
#     bootstrap_servers => "127.0.0.1:9092"
#    }

   elasticsearch {
     hosts => ["es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan"]
     index => "suricata-%{+YYYY.MM.dd}"
     manage_template => false
     document_type => "_doc"
   }
 }
}
```

##### /etc/elasticsearch/elastic.yml ??

```yml

# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: es[#]
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: es[#]
#
# Add custom attributes to the node:
#
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /data/elasticsearch
#
# Path to log files:
#
path.logs: /var/log/elasticsearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: 0.0.0.0
#
# Set a custom port for HTTP:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.zen.ping.unicast.hosts: ["es[#].[STATE].cmat.lan","es[#].[STATE].cmat.lan", "es[#].[STATE].cmat.lan"]
#
# Prevent the "split brain" by configuring the majority of nodes (total number of master-eligible nodes / 2 + 1):
#
#discovery.zen.minimum_master_nodes:
#
# For more information, consult the zen discovery module documentation.
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
```

### ELK Only
##### /etc/kibana/kibana.yml ??

```yml

# Kibana is served by a back end server. This setting specifies the port to use.
#server.port: 5601

# Specifies the address to which the Kibana server will bind. IP addresses and host names are both valid values.
# The default is 'localhost', which usually means remote machines will not be able to connect.
# To allow connections from remote users, set this parameter to a non-loopback address.
server.host: "0.0.0.0"

# Enables you to specify a path to mount Kibana at if you are running behind a proxy.
# Use the `server.rewriteBasePath` setting to tell Kibana if it should remove the basePath
# from requests it receives, and to prevent a deprecation warning at startup.
# This setting cannot end in a slash.
#server.basePath: ""

# Specifies whether Kibana should rewrite requests that are prefixed with
# `server.basePath` or require that they are rewritten by your reverse proxy.
# This setting was effectively always `false` before Kibana 6.3 and will
# default to `true` starting in Kibana 7.0.
#server.rewriteBasePath: false

# The maximum payload size in bytes for incoming server requests.
#server.maxPayloadBytes: 1048576

# The Kibana server's name.  This is used for display purposes.
#server.name: "10.1.10.27"

# The URL of the Elasticsearch instance to use for all your queries.
elasticsearch.url: "http://0.0.0.0:9200"

# When this setting's value is true Kibana uses the hostname specified in the server.host
# setting. When the value of this setting is false, Kibana uses the hostname of the host
# that connects to this Kibana instance.
#elasticsearch.preserveHost: true

# Kibana uses an index in Elasticsearch to store saved searches, visualizations and
# dashboards. Kibana creates a new index if the index doesn't already exist.
#kibana.index: ".kibana"

# The default application to load.
#kibana.defaultAppId: "home"

# If your Elasticsearch is protected with basic authentication, these settings provide
# the username and password that the Kibana server uses to perform maintenance on the Kibana
# index at startup. Your Kibana users still need to authenticate with Elasticsearch, which
# is proxied through the Kibana server.
#elasticsearch.username: "user"
#elasticsearch.password: "pass"

# Enables SSL and paths to the PEM-format SSL certificate and SSL key files, respectively.
# These settings enable SSL for outgoing requests from the Kibana server to the browser.
#server.ssl.enabled: false
#server.ssl.certificate: /path/to/your/server.crt
#server.ssl.key: /path/to/your/server.key

# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
# These files validate that your Elasticsearch backend uses the same key files.
#elasticsearch.ssl.certificate: /path/to/your/client.crt
#elasticsearch.ssl.key: /path/to/your/client.key

# Optional setting that enables you to specify a path to the PEM file for the certificate
# authority for your Elasticsearch instance.
#elasticsearch.ssl.certificateAuthorities: [ "/path/to/your/CA.pem" ]

# To disregard the validity of SSL certificates, change this setting's value to 'none'.
#elasticsearch.ssl.verificationMode: full

# Time in milliseconds to wait for Elasticsearch to respond to pings. Defaults to the value of
# the elasticsearch.requestTimeout setting.
#elasticsearch.pingTimeout: 1500

# Time in milliseconds to wait for responses from the back end or Elasticsearch. This value
# must be a positive integer.
#elasticsearch.requestTimeout: 30000

# List of Kibana client-side headers to send to Elasticsearch. To send *no* client-side
# headers, set this value to [] (an empty list).
#elasticsearch.requestHeadersWhitelist: [ authorization ]

# Header names and values that are sent to Elasticsearch. Any custom headers cannot be overwritten
# by client-side headers, regardless of the elasticsearch.requestHeadersWhitelist configuration.
#elasticsearch.customHeaders: {}

# Time in milliseconds for Elasticsearch to wait for responses from shards. Set to 0 to disable.
#elasticsearch.shardTimeout: 30000

# Time in milliseconds to wait for Elasticsearch at Kibana startup before retrying.
#elasticsearch.startupTimeout: 5000

# Logs queries sent to Elasticsearch. Requires logging.verbose set to true.
#elasticsearch.logQueries: false

# Specifies the path where Kibana creates the process ID file.
#pid.file: /var/run/kibana.pid

# Enables you specify a file where Kibana stores log output.
#logging.dest: stdout

# Set the value of this setting to true to suppress all logging output.
#logging.silent: false

# Set the value of this setting to true to suppress all logging output other than error messages.
#logging.quiet: false

# Set the value of this setting to true to log all events, including system usage information
# and all requests.
#logging.verbose: false

# Set the interval in milliseconds to sample system and process performance
# metrics. Minimum is 100ms. Defaults to 5000.
#ops.interval: 5000

# Specifies locale to be used for all localizable strings, dates and number formats.
#i18n.locale: "en"
```
#### Sensor Config

##### /etc/kafka/kafka.conf ??
```yml

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# see kafka.server.KafkaConfig for additional details and defaults

############################# Server Basics #############################

# The id of the broker. This must be set to a unique integer for each broker.
broker.id=0

############################# Socket Server Settings #############################

# The address the socket server listens on. It will get the value returned from
# java.net.InetAddress.getCanonicalHostName() if not configured.
#   FORMAT:
#     listeners = listener_name://host_name:port
#   EXAMPLE:
#     listeners = PLAINTEXT://your.host.name:9092
listeners=PLAINTEXT://sensor.[STATE].cmat.lan:9092

# Hostname and port the broker will advertise to producers and consumers. If not set,
# it uses the value for "listeners" if configured.  Otherwise, it will use the value
# returned from java.net.InetAddress.getCanonicalHostName().
advertised.listeners=PLAINTEXT://sensor.[STATE].cmat.lan:9092

# Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
#listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL

# The number of threads that the server uses for receiving requests from the network and sending responses to the network
num.network.threads=3

# The number of threads that the server uses for processing requests, which may include disk I/O
num.io.threads=8

# The send buffer (SO_SNDBUF) used by the socket server
socket.send.buffer.bytes=102400

# The receive buffer (SO_RCVBUF) used by the socket server
socket.receive.buffer.bytes=102400

# The maximum size of a request that the socket server will accept (protection against OOM)
socket.request.max.bytes=104857600


############################# Log Basics #############################

# A comma seperated list of directories under which to store log files
log.dirs=/data/kafka

# The default number of log partitions per topic. More partitions allow greater
# parallelism for consumption, but this will also result in more files across
# the brokers.
num.partitions=1

# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
# This value is recommended to be increased for installations with data dirs located in RAID array.
num.recovery.threads.per.data.dir=1

############################# Internal Topic Settings  #############################
# The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
# For anything other than development testing, a value greater than 1 is recommended for to ensure availability such as 3.
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

############################# Log Flush Policy #############################

# Messages are immediately written to the filesystem but by default we only fsync() to sync
# the OS cache lazily. The following configurations control the flush of data to disk.
# There are a few important trade-offs here:
#    1. Durability: Unflushed data may be lost if you are not using replication.
#    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
#    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to exceessive seeks.
# The settings below allow one to configure the flush policy to flush data after a period of time or
# every N messages (or both). This can be done globally and overridden on a per-topic basis.

# The number of messages to accept before forcing a flush of data to disk
#log.flush.interval.messages=10000

# The maximum amount of time a message can sit in a log before we force a flush
#log.flush.interval.ms=1000

############################# Log Retention Policy #############################

# The following configurations control the disposal of log segments. The policy can
# be set to delete segments after a period of time, or after a given size has accumulated.
# A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
# from the end of the log.

# The minimum age of a log file to be eligible for deletion due to age
log.retention.hours=168

# A size-based retention policy for logs. Segments are pruned from the log unless the remaining
# segments drop below log.retention.bytes. Functions independently of log.retention.hours.
#log.retention.bytes=1073741824

# The maximum size of a log segment file. When this size is reached a new log segment will be created.
log.segment.bytes=1073741824

# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
log.retention.check.interval.ms=300000

############################# Zookeeper #############################

# Zookeeper connection string (see zookeeper docs for details).
# This is a comma separated host:port pairs, each corresponding to a zk
# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# You can also append an optional chroot string to the urls to specify the
# root directory for all kafka znodes.
zookeeper.connect=localhost:2181

# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=6000


############################# Group Coordinator Settings #############################

# The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
# The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
# The default value for this is 3 seconds.
# We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
# However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
group.initial.rebalance.delay.ms=0

```


### Ports
Open the following ports on the firewall for the elastic machines

  - 9300 TCP - Node coordination (I am sure elastic has abetter name for this)
  - 9200 TCP - Elasticsearch
  - 5601 TCP - Only on the elasticsearch node that has kibana installed, Likely es1.[STATE].cmat.lan
  - 22 TCP - SSH Access


```
sudo firewall-cmd --add-port=9300/tcp --permanent
```
Reload the firewall config

```
sudo firewall-cmd --reload
```

### Function check
Move onto [Usage](usage.md)
