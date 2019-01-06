# ES documentation

## Install RHEL 7 Server

> ## Prerequisites
> - Configure router to serve NTP
> - Configure DNS server for internal resolution

### Pre-Install
When you boot the installer, called Anaconda. Before it boots, press <TAB> and append the following, which disables physical NIC naming and sets the screen resolution that is better for VMware.
```
net.ifnames=0 vga=791
```

### Installation Configuration
Once Anaconda is loaded:
1. Set Language and Keyboard to English, click <kbd>CONTINUE</kbd>.
2. Configure the network.
  a. Set the hostname to the FQDN.
  b. Configure a static IP per the documentation.
  c. Configure the DNS server to `10.X.10.20` (per docs)
  d. Configure search domain to `xx.cmat.lan` per your state.
  e. Apply the configuration and set the interface to **ON**.
3. Set Date/Time to ETC/Coordinated Universal Time Zone and configure NTP to point to the router, `10.X.10.1`.
4. Configure Installation Destination
  1. Select "I will configure partitioning", then "Done".
  2. Create the following partitions. You can let Anaconda auto-create the initial partitions and modify from there.

Partition | Capacity
----------|--------------
/var/log/audit | 10 GB
/var/lib  |  900 GB (or whatever is left)
/tmp | 25 GB
/var | 25 GB
/home  |  50 GB
/boot  | 1 GB
/   |  50 GB
swap  |  8 GB


5. Go to Security Policy. Apply "DISA STIG for Red Hat Enterprise Linux 7"

6. Click <kbd>Begin Installation</kbd>
7. Create an `admin` user with the password according to password documentation. Be sure to make the user an administrator. Leave the root password untouched, which will lock the account except for emergency offline maintenance.

## Update OS & Install Elasticsearch

1. Enable the locally hosted repos
```
curl http://10.X.10.19/local.repo | sudo tee /etc/yum.repos.d/local.repo
sudo yum makecache fast
```

2. Perform system update and enable daily updates
```
sudo yum update -y
sudo yum install -y yum-cron
sudo systemctl enable yum-cron
sudo systemctl start yum-cron
```

3. Install elasticsearch
```
sudo yum install -y elasticsearch
```

## Seal the Virtual Machine as Template (optional)

Once your system is setup as needed, you can unconfigure the VM to the point that allows it to be cloned or used as a template.

1. Remove the SSH host keys
```
sudo rm -rf /etc/ssh/ssh_host_*
```
2. Set `localhost.localdomain` in `/etc/hostname`.
3. Remove the `HWADDR` line and `UUID` line from `/etc/sysconfig/network-scripts/ifcfg-eth*`.
```
sudo sed -i'' '/HWADDR/d; /UUID/d;' \
  /etc/sysconfig/network-scripts/ifcfg-eth*
```
4. Optionally, delete all the logs from `/var/log` and build logs from `/root`.
```
sudo rm -rf /root/{anaconda-ks.cfg,openscap_data}
sudo find /var/log -type f -delete
```
5. Run the following command to finalize the seal and shutdown the system.
```
sudo sys-unconfig
```
