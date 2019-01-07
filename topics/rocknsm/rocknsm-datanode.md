# RockNSM Data Node
This will cover the deployment of the RockNSM data node elements.
## Prereqs
- ESXi installed
- logged in `ssh` or vm console in ESXi

## Install OS

### Preinstall
When you boot the installer, called Anaconda. Before it boots, press <TAB> and append the following, which disables physical NIC naming and sets the screen resolution that is better for VMware.

  ```
  net.ifnames=0 vga=791
  ```

Install OS in accordance with [RHEL](../rhel/README.md)
Documentation

### Install Data Node Elements


There are 2 type of Elastic Nodes. There are 3 nodes total. two of the node will only have elasticsearch and logstash on them (EL). The third will have elasticsearch, logstash, and kibana (ELK).


#### "ELK" Node
1. Perform system update and enable daily updates
```
sudo yum update -y
sudo yum install -y yum-cron
sudo systemctl enable yum-cron
sudo systemctl start yum-cron
```

##### Preparation for Rock Deployment

1. curl the following files from the nuc to aid in the deployment of ROCK

  ```
  sudo curl some directory from the nuc
  ```

1. Install dracut
  ```
  sudo yum install dracut
  ```
1. Disable FIPS

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
  grubby --update-kernel=ALL --remove-args=fips=1
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

1. Install the Rock NSM dependencies

  ```
  sudo yum install jq GeoIP geopipupdate tcpreplay tcpdump bats policycoreutils-python htop vim git tmux nmap-ncat logrotate perl-LWP-Protocol-https perl-Sys-Syslog perl-Crypt-SSLeay perl-Archive-Tar java-1.8.0-openjdk-headless filebeat ansible
  ```
1. Make a place for ROCK to live
  ```
  mkdir /opt/var/rocknsm/
  ```

1. Navigate there so we can clone the Rock NSM repo there
  ```
  cd /opt/var/rocknsm/  
  ```

1. Clone the Rock NSM repo from the NUC
  ```
  sudo git clone http://10.[state].10.19:4000/administrator/rock.git
  ```
  or if you have dns setup then
  ```
  sudo git clone http://nuc.[state].cmat.lan:4000/administrator/rock.git
  ```
1. Navigate to the rock playbook directory
  ```
  cd /rocknsm/bin
  ```
1. Generate defaults for rock to deploy with
  ```
  sudo sh generate_defaults.sh
  ```
___

#### "EL" Node
1. Perform system update and enable daily updates
```
sudo yum update -y
sudo yum install -y yum-cron
sudo systemctl enable yum-cron
sudo systemctl start yum-cron
```

##### Preparation for Rock Deployment

1. curl the following files from the nuc to aid in the deployment of ROCK

  ```
  sudo curl some directory from the nuc
  ```

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
  grubby --update-kernel=ALL --remove-args=fips=1
  ```
1. **Carefully** up date the grub config file setting `fips=0`
  ```
  sudo vi /etc/default/grub
  ```
1. Reboot the VM
  ```
  sudo reboot
  ```

Move onto [RockNSM Sensor](rocknsm-sensor.md)
