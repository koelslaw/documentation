# RockNSM on RHEL sensor Deployment

Prereqs:
 - Rock Iso mounted or downloaded to OS
 - RHEL installed in accordance with Documentation
 - Clone of the ROCK 2.4 Git Repository

## Disable FIPS to allow Deployment on all components

- Remove the dracut-fips* packages
```
sudo yum remove dracut-fips\*
```

- Backup existing FIPS initramfs
```
sudo mv -v /boot/initramfs-$(uname -r).img{,.FIPS-bak}
```

- Run dracut to rebuild the initramfs
```
sudo dracut
```

- Run Grubby
```
sudo grubby --update-kernel=ALL --remove-args=fips=1
```

-  Carefully up date the grub config file setting fips=0
```
sudo vi /etc/default/grub
```

-  Reboot the VM
```
sudo reboot
```

-  Log back in...

-  Confirm that fips is disabled by
```
sysctl crypto.fips_enabled
```

If it returns 0 then it has been properly disabled


## Installation
for all the installation machines mount the iso. transfer the contents to each of the machines.

-  Mount the iso if you have not already done so to `/mnt`
```
mount -t iso9660 -o loop path/to/image.iso /mnt
```

-  Copy the folders form the mounted device to `/srv/rocknsm`
```
cp -r /mnt/* /srv/rocknsm/.
```

-  Git Clone or Copy the rocknsm repo to the `/usr/share/rock` directory
```
sudo git clone https://github.com/rocknsm/rock.git
```

-  **If** not deploying from the nuc, create a repo file for the local repo Server
___
```
sudo bash -c 'cat > /etc/yum.repos.d/local-repos.repo <<EOF
[copr-rocknsm-2.1]
name: copr rocknms repo
baseurl=http://10.[state octet].10.19/copr-rocknsm-2.1/
gpgcheck=0
enabled=1

[local-epel]
name: Extra packages For Enterprise Linux Local Repo
baseurl=http://10.[state octet].10.19/epel/
gpgcheck=0
enabled=1

[local-rhel-7-server-extras-rpmsx86_64]
name: local rhel 7 server extras
baseurl=http://10.[state octet].10.19/rhel-7-server-extras-rpms/
gpgcheck=0
enabled=1

[local-rhel-7-server-optional-rpmsx86_64]
name: local rhel 7 server optional
baseurl=http://10.[state octet].10.19/rhel-7-server-optional-rpms/
gpgcheck=0
enabled=1

[local-rhel-7-server-rpmsx86_64]
name: local rhel 7 server rpms
baseurl=http://10.[state octet].10.19/rhel-7-server-rpms/
gpgcheck=0
enabled=1

[local-elastic-6.x]
name: elastic
baseurl=http://10.[state octet].10.19/elastic-6.x/
gpgcheck=0
enabled=1

[local-rock2]
name: elastic
baseurl=http://10.[state octet].10.19/rock2/
gpgcheck=0
enabled=1

EOF'
```
___

-  Install Ansible to coordinate the installation of the Sensor
```
sudo yum install ansible
```

-  Ensure the latest version of markupsafe is installed also
```
sudo yum install python2-markupsafe
```

-  copy the hosts file from the git repo and set the host to:
___

```
sensor.[state].cmat.lan ansible_host=10.[state].10.21 ansible_connection=ssh  ansible_user=admin
es- [state].cmat.lan ansible_host=10.[state].10.25 ansible_connection=ssh  ansible_user=admin
es2.[state].cmat.lan ansible_host=10.[state].10.26 ansible_connection=ssh  ansible_user=admin
es3.[state].cmat.lan ansible_host=10.[state].10.27 ansible_connection=ssh  ansible_user=admin
# If you have any other sensor or data nodes then you would place them in the list above.


[rock]
sensor.[state].cmat.lan

[web]
es1.[state].cmat.lan

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
sensor.[state].cmat.lan

[elasticsearch:children]
es_masters
es_data
es_ingest

[es_masters]
es[1:3].[state].cmat.lan

[es_data]
es[1:3].[state].cmat.lan

[es_ingest]
es[1:3].[state].cmat.lan

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
```
___

- Change Directory into `usr/share/rock/bin`

- remove/comment the following steps in the follwoing playbook files:
  - for adding entries to the /etc/hosts `/usr/share/rock/roles/common/tasks/configure.yml`
  - disable and enable shard allocation in `/usr/share/rock/roles/elasticsearch/tasks/restart.yml`
  - ensure that you edit the playbook in `/etc/elasticsearch/elastisearch.yml` and change
   `es_node_name: "{{ ansible_hostname }}"` to `{{ inventory_hostname }}`
  - comment out the step `update-suricata source index` in the file `/usr/ahRE/rock/roles/suricata/tasks/main.yml`

- Run `sudo ./rock ssh-config` to setup ssh on all the host you will use for the deployment. It uses the host from the previously created `host.ini`

- Run `sudo ./rock genconfig` to generate config file. Unless you are doing something really off the beaten path of a normal deployment you should not need to edit this file.

- Disable/move the local repo to make sure everything comes from the mounted iso
```
sudo mv /etc/yum.repos.d/local-repos.repo ~/
```

- Ensure you are in the `/usr/share/rock/bin/` directory.

- Fire off the installation
```
sudo ./rock deploy-offline
```

- Ensure the following ports on the firewall are open for the data nodes
  - 9300 TCP - Node coordination (I am sure elastic has abetter name for this)
  - 9200 TCP - Elasticsearch
  - 5601 TCP - Only on the Elasticsearch node that has Kibana installed, Likely es1.[STATE].cmat.lan
  - 22 TCP - SSH Access

  ```
  sudo firewall-cmd --add-port=9300/tcp --permanent
  ```

- Reload the firewall config
```
sudo firewall-cmd --reload
```

- Ensure the following ports on the firewall are open for the sensor
  - 1234 tcp/udp - NTP
  - 22 TCP - SSH Access
  - 9092 TCP - Kafka

  ```
  sudo firewall-cmd --add-port=22/tcp --permanent
  ```

- Reload the firewall config
```
sudo firewall-cmd --reload
```

- Check the Suricata `threads` per interface. This is so Suricata doesn't compete with bro for cpu threads in `/etc/suricata/rock-overrides.yml`

```yml
%YAML 1.1
---
default-rule-path: "/var/lib/suricata/rules"
rule-files:
  - suricata.rules

af-packet:
  - interface: em3
    threads: 4 <---------
    cluster-id: 98
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
    mmap-locked: yes
    #rollover: yes
    tpacket-v3: yes
    use-emergency-flush: yes
default-log-dir: /data/suricata
```

- Restart services with `sudo rock stop` and the `sudo rock start`

Move onto [USAGE](../rocknsm-usage.md)
