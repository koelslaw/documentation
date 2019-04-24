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

  > NOTE: The new playbooks in 2.3.0 are made to handle multi node deployments. We will be able to deploy several machines at the same time.

1. Generate a hosts.ini file that so ansible knows where to deploy things `sudo vi /etc/rocknsm/hosts.ini`

  > NOTE: If not already done then log into every server that rock will be deployed to so that the key can be added to the ssh hosts file.

1. Insert the following text. These will tell the script what to deploy and where
---
```
[all]
sensor.mo.cmat.lan ansible_host=10.1.10.21 ansible_connection=local
es1.mo.cmat.lan ansible_host=10.1.10.25 ansible_connection=local
es2.mo.cmat.lan ansible_host=10.1.10.26 ansible_connection=local
es3.mo.cmat.lan ansible_host=10.1.10.27 ansible_connection=local

[rock]
sensor.mo.cmat.lan ansible_host=10.1.10.21 ansible_connection=local

[web]
es1.mo.cmat.lan ansible_host=10.1.10.25 ansible_connection=local
es2.mo.cmat.lan ansible_host=10.1.10.26 ansible_connection=local
es3.mo.cmat.lan ansible_host=10.1.10.27 ansible_connection=local

[sensors:children]
rock

[bro:children]
sensors

[fsf:children]
sensors

[kafka:children]
sensors

[stenographer:children]
sensors

[suricata:children]
sensors

[zookeeper]
sensor.mo.cmat.lan ansible_host=10.1.10.21 ansible_connection=local

[elasticsearch:children]
es_masters
es_data
es_ingest

[es_masters]
# This group should only ever contain exactly 1 or 3 nodes!
#simplerockbuild.simplerock.lan ansible_host=127.0.0.1 ansible_connection=local
# Multi-node example #
es[1:3].[state].cmat.lan

[es_data]
#simplerockbuild.simplerock.lan ansible_host=127.0.0.1 ansible_connection=local
# Multi-node example #
es[1:3].[state].cmat.lan

[es_ingest]
#simplerockbuild.simplerock.lan ansible_host=127.0.0.1 ansible_connection=local
# Multi-node example #
#elasticsearch0[1:4].simplerock.lan

[elasticsearch:vars]
# Disable all node roles by default
node_master=false
node_data=false
node_ingest=false

[es_masters:vars]
node_master=true

[es_data:vars]
node_data=true

[es_ingest:vars]
node_ingest=true

[docket:children]
web

[kibana:children]
web

[logstash:children]
sensors

[all:vars]
ansible_sudo_user={see platform management}
ansible_sudo_pass={see platform management}
ansible_ssh_user={see platform management}

```

---

1. Make a place for the rock iso to live.

  ```
  sudo mkdir -p /srv/rocknsm
  ```

1. Deploy the Rock iso to all the the machines in the playbook to prepare for the deployment of rock NSM

  ```
  sudo ansible-playbook rockISOPrep.yml
  ```

1. Navigate to the rock bin directory
  ```
  cd /srv/rocknsm/
  ```

1. Copy the contents of the mounted iso so that it can be used for the installation

  ```
  sudo cp -r /mnt/* /srv/rocknsm
  ```  

1. Look at the directory using `ls` to ensure that it copied the information fromt he mounted iso image.

1. Generate defaults for rock to deploy with
  ```
  sudo ansible-playbook /opt/rocknsm/rock/playbooks/generate-defaults.yml
  ```
> NOTE: this generates a config file on the end user machine. The config file on the remote machine isnt what actually gets used for the deployment. The config file on the nuc is the one that gets used for the deployment. These generated config files are useful in making sure you have the correct setting for each of you servers.

1. Copy one of the generated config files to use as the base for your deployment. My recommendation is sensor.[state].cmat.lan

  ```
  sudo scp admin@sensor.[state].cmat.lan:/etc/rocknsm/config.yml /etc/rocknsm/config.yml
  ```
> NOTE: change the parameters for each part of the deployment. in this case it will be 3 parts: sensor, data tier w/o kibana, data tier w/ Kibana

1. Edit the `/etc/rocknsm/config.yml`
  ```
  sudo vi /etc/rocknsm.config.yml
  ```

>NOTE: we are going to use the same config file for the entire deployment.

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
  rock_disable_offline_repo: False
  # (OFFLINE) Set the path for local repo if doing an OFFLINE installation:
  rocknsm_local_baseurl: file:///srv/rocknsm/
  # (OFFLINE) Set to enable or disable GPG checking for local repos:
  # 1 = enabled
  # 0 = disabled
  rock_offline_gpgcheck: 0
  # (OFFLINE) the git repo used to checkout customized ROCK scripts for Bro:
  bro_rockscripts_repo: file:///srv/rocknsm


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

1.  Create the following directory. This will give the deployment script to put the dashboards and scripts.

  ```
  sudo mkdir -p /srv/rocknsm/support
  ```

1. Deploy against the config file you just created. So if you used the config file for the sensor lets deploy that.

  ```
  sudo ansible-playbooks -l rock /opt/rocknsm/rock/playbooks/deploy-rock.yml
  ```

  It should complete with **no** errors


1. Adjust the config file `/etc/rocknsm/config.yml` so that data tier can be deployed
  ```
  sudo vi /etc/rocknsm.config.yml
  ```
1. Copy one of the generated config files to use as the base for your data deployment. My recommendation is es1.[state].cmat.lan

  ```
  sudo scp admin@es1.[state].cmat.lan:/etc/rocknsm/config.yml /etc/rocknsm/config.yml
  ```

1. Deploy against the config file you just created. So if you used the config file for the sensor lets deploy that.

  ```
  sudo ansible-playbooks -l rock /opt/rocknsm/rock/playbooks/deploy-rock.yml
  ```

  It should complete with **no** errors

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

1. Restart the stack using `rock_stop` and `rock_start`

Move onto [USAGE](rocknsm-usage.md)
