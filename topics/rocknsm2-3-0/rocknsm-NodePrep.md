# RockNSM Data Node
This will cover the deployment of the RockNSM data node elements.
## Prereqs
- ESXi installed
- logged ability to log in and ssh into every system
- DNS Setup
- Connectivity of all servers

## Install OS

### Preinstall **IF** any of the nodes are Virtual Machines
When you boot the installer, called Anaconda. Before it boots, press <TAB> and append the following, which disables physical NIC naming and sets the screen resolution that is better for VMware.

  ```
  net.ifnames=0 vga=791
  ```

Install OS in accordance with [RHEL](../rhel/README.md)
Documentation


___

### OS Prep for deployment All Nodes (DATA and Sensor)

1. Perform system update and enable daily updates
  ```
  sudo yum update -y
  sudo yum install -y yum-cron
  sudo systemctl enable yum-cron
  sudo systemctl start yum-cron
  sudo yum install wget
  ```

#### Disable FIPS to allow Deployment
1. Disable FIPS
  1. Install dracut
    ```
    sudo yum install dracut
    ```

  1. Remove the dracut-fips* packages
    ```
    sudo yum remove dracut-fips\*
    ```

  1. Backup existing FIPS initramfs
    ```
    sudo mv -v /boot/initramfs-$(uname -r).img{,.FIPS-bak}
    ```

  1. Run `dracut` to rebuild the initramfs
    ```
    sudo dracut
    ```

  1. Run Grubby
    ```
    sudo grubby --update-kernel=ALL --remove-args=fips=1
    ```

  1. **Carefully** up date the grub config file setting `fips=0`
    ```
    sudo vi /etc/default/grub
    ```

  1. Reboot the VM
    ```
    sudo reboot
    ```

1. Log back in...

1. Confirm that fips is disabled by
  ```
  sysctl crypto.fips_enabled
  ```
  if it returns `0` then it has been properly disabled


### Deployment of Rock across RHEL Machines

1. Make a place for ROCK to live
  ```
  mkdir /opt/rocknsm/
  ```

1. Navigate there so we can clone the Rock NSM repo there
  ```
  cd /opt/rocknsm/  
  ```

1. Clone the Rock NSM repo from the NUC
  ```
  sudo git clone http://10.[state].10.19:4000/administrator/rock.git
  ```
  or if you have dns setup then
  ```
  sudo git clone http://nuc.[state].cmat.lan:4000/administrator/rock.git
  ```

1. Navigate to the rock bin directory
  ```
  cd /opt/rocknsm/rock/bin
  ```

  > NOTE: The new playbooks in 2.3.0 are made to handle multi node deployments. We will be able to deploy all machines at the same time.

1. Generate a hosts.ini file that so ansible knows where to deploy things `sudo vi /etc/rocknsm/hosts.ini`

1. Insert the following text.
---
```

[all]
es1.[state].cmat.lan
es2.[state].cmat.lan
es3.[state].cmat.lan
sensor.[state].cmat.lan

[sensor:children]
zookeeper
kafka
stenographer
bro
suricata
fsf

[ui:children]
docket
kibana
elasticsearch
logstash

[data:children]
elasticsearch
logstash

[sensor]
sensor.[state].cmat.lan

[ui]
es1.[state].camt.lan

[data]
es2.[state].camt.lan
es3.[state].camt.lan
```


---
1. Generate defaults for rock to deploy with
  ```
  sudo sh generate_defaults.sh
  ```

1. Edit the `/etc/rocknsm/config.yml`
  ```
  sudo vi /etc/rocknsm.config.yml
  ```


1. Change the config to the following:
  Replace the `[#]` with the number of the cluster.
---

  ```yml

  ###############################################################################
  #      :::====  :::====  :::===== :::  === :::= === :::===  :::=======        #
  #      :::  === :::  === :::      ::: ===  :::===== :::     ::: === ===       #
  #      =======  ===  === ===      ======   ========  =====  === === ===       #
  #      === ===  ===  === ===      === ===  === ====     === ===     ===       #
  #      ===  ===  ======   ======= ===  === ===  === ======  ===     ===       #
  ###############################################################################
  # This configuration file contains all the installation variables that
  # affect the deployment of RockNSM. Take care when modifying these options.
  # The defaults should be used unless you really know what you are doing!


  ###############################################################################
  #                      Network Interface Configuration
  ###############################################################################
  # The "rock_monifs:" listed below are the interfaces that were not detected
  # as having an active IP address. Upon running the deploy script, these
  # interfaces will be configured for monitoring (listening) operations.
  # NOTE: management interfaces should *not* be listed here:

  rock_monifs:


  ###############################################################################
  #                         Sensor Resource Configuration
  ###############################################################################
  # Set hostname and fqdn in inventory file

  # Set the number of CPUs assigned to Bro:
  bro_cpu: 6  # put in value even though bro is not enabled on a data node

  # Set the Elasticsearch cluster name:
  es_cluster_name: {{ es_cluster_name }} # the name of the cluster of elasticsearch nodes

  # Set the Elasticsearch cluster node name:
  es_node_name: {{ es_node_name }} # unique name for this node in the cluster of elastic nodes

  # Set the value of Elasticsearch memory:
  es_mem: 6 # Memory attached to this node for elasticsearch


  ###############################################################################
  #                       Installation Source Configuration
  ###############################################################################
  # The primary installation variable defines the ROCK installation method:
  # ONLINE:   used if the system may reach out to the internet
  # OFFLINE:  used if the system may *NOT* reach out to the internet
  # The default value "False" will deploy using OFFLINE (local) repos.
  # A value of "True" will perform an install using ONLINE mirrors.

  rock_online_install: False

  # If the above "rock_online_install:" variable is set to "True" see the
  # following (ONLINE) installation options:

  # (ONLINE) Enable RockNSM testing repos:
  rock_enable_testing: False
  # (ONLINE) Set the URL for the EPEL repo mirror:
  epel_baseurl: http://download.fedoraproject.org/pub/epel/$releasever/$basearch/
  # (ONLINE) Set the URL for the EPEL GPG key:
  epel_gpgurl: https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
  # (ONLINE) Set the URL for the Elastic repo mirror:
  elastic_baseurl: https://artifacts.elastic.co/packages/6.x/yum
  # (ONLINE) Set the URL for the Elastic GPG key:
  elastic_gpgurl: https://artifacts.elastic.co/GPG-KEY-elasticsearch
  # (ONLINE) Set the URL for the RockNSM repo mirror:
  rocknsm_baseurl: https://packagecloud.io/rocknsm/2_2/el/7/$basearch
  # (ONLINE) Set the URL for the RockNSM GPG key:
  rocknsm_gpgurl: https://packagecloud.io/rocknsm/2_2/gpgkey


  # If the above "rock_online_install:" variable is set to "False" see the
  # following (OFFLINE) installation options:

  # (OFFLINE) Disable the creation of a local repo file:
  rock_disable_offline_repo: True
  # (OFFLINE) Set the path for local repo if doing an OFFLINE installation:
  rocknsm_local_baseurl: http://nuc.[STATE].cmat.lan/
  # (OFFLINE) Set to enable or disable GPG checking for local repos:
  # 1 = enabled
  # 0 = disabled
  rock_offline_gpgcheck: 0
  # (OFFLINE) the git repo used to checkout customized ROCK scripts for Bro:
  bro_rockscripts_repo: https://nuc.[STATE].cmat.lan:4000/administrator/rock-scripts.git


  ###############################################################################
  #                       Data Retention Configuration
  ###############################################################################

  # Set the interval in which Elasticsearch indexes are closed:
  elastic_close_interval: 15

  # Set the interval in which Elasticsearch indexes are deleted:
  elastic_delete_interval: 60

  # Set value for Kafka retention (in hours):
  kafka_retention: 168

  # Set value for Bro log retention (in days):
  bro_log_retention: 0

  # Set value for Bro statistics log retention (in days):
  bro_stats_retention: 0

  # Set how often logrotate will roll Suricata log (in days):
  suricata_retention: 3

  # Set value for FSF log retention (in days):
  fsf_retention: 3

  ###############################################################################
  #                              ROCK Component Options
  ###############################################################################

  # The following "with_" statements define what components of RockNSM are
  # installed when running the deploy script:

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

  # The following "enable_" statements define what RockNSM component services
  # are enabled (start automatically on system boot):

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
  enable_filebeat: False

  ###############################################################################
  #                             NEXT STEP: Deployment
  ###############################################################################
  # Once the settings in this config file have been finalized, the next step is
  # to run the "deploy_rock" script located at:
  #
  #    /opt/rocknsm/rock/bin/deploy_rock.sh
  #
  # For more information refer to the full documentation at: https://rocknsm.io

  ```

___

1.  Create the following directory
  ```
  sudo mkdir -p /srv/rocknsm/support
  ```

1. `wget` the following files from the nuc to aid in the deployment of ROCK

  1. Grab the rock scripts
    ```
    sudo wget http://10.1.10.19:4000/administrator/rock-scripts/archive/master.tar.gz
    ```

  1. Rename the file.
    ```
    sudo mv master.tar.gz rock-scripts_master.tar.gz
    ```

  1. Grab the rock dashboards

    ```
    sudo wget http://10.1.10.19:4000/administrator/rock-dashboards/archive/master.tar.gz
    ```

  1. Rename the file
    ```
    sudo mv master.tar.gz rock-dashboards_master.tar.gz
    ```

1. Copy them to the need directory
  ```
  cd
  ```
  ```
  sudo cp ~/rock-dashboards_master.tar.gz /srv/rocknsm/support/rock-dashboards_master.tar.gz
  ```
  ```
  sudo cp ~/rock-scripts_master.tar.gz /srv/rocknsm/support/rock-scripts_master.tar.gz
  ```


1. Navigate to the correct directory and deploy

  ```
  cd /opt/rocknsm
  ```

  ```

  It should complete with **no** errors


___



1. Open the following ports on the firewall for the elastic machines

  - 9300 TCP - Node coordination (I am sure elastic has abetter name for this)
  - 9200 TCP - Elasticsearch
  - 5601 TCP - Only on the elasticsearch node that has kibana installed, Likely es1.[STATE].cmat.lan
  - 22 TCP - SSH Access


  ```
  sudo firewall-cmd --add-port=9300/tcp --permanent
  ```

1. Reload the firewall config

  ```
  sudo firewall-cmd --reload
  ```

1. Restart services with `rock_stop` and the `rock_start`

1. Deploy more nodes as needed.

1. Open the following ports on the firewall for the elastic machines

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

1. Restart the stack using `rock_stop` and `rock_start`

Move onto [USAGE](rocknsm-usage.md)
