# RockNSM Data Node
This will cover the deployment of the RockNSM data node elements.

## Building the Data Node Host
1. Use the data node VM that you built [here](../vmware/README.md#Create-the-Sensor-Data-Tier-Virtual-Machine)
1. Fire up the VM and boot into Anaconda (the Linux install wizard)
1. Select your language
1. Start at the bottom-left, `Network & Host Name`
    - There is the `Host Name` box at the bottom of the window, enter the `datanode-[1,2,3]` hostname from the [../platform-management.md](Platform Management) page
    - Switch the toggle to enable your NIC
      - Click `Configure`
      - Go to `IPv4 Settings`
        - Change the `Method` to `Manual`
        - Click `Add`
          - Update your IP address, network, and gateway from the [../platform-management.md](Platform Management) page
      - Go to `IPv6 Settings` and change from `Automatic` to `Ignore`
      - Click `Save`
    - Click `Done` in the top left
1. Next the `Security Profile` in the lower right
    - Select `DISA STIG`
    - Click `Select Profile`
    - Click `Done`
1. Next click `Installation Destination`  
    - Select the hard disk you want to install RHEL to, likely it is already selected unless you have more than 1 drive  
      - Click `Automatic Partitioning` and then click the checkbox that says `I would like to make additional space.`
      - Click `Done`  
      - There will be a popup window, in the bottom right, click `Delete All` and then `Reclaim Space`  
      - There will be a new popup window, click `Accept`  
      - Click on `Installation Destination`  
      - In the `Other Storage Options`, select `I will configure partitioning`.  
      - Click `Done`  
      - Click `Click here to create automatically.`  
      - Click on the `Red Hat Enterprise Linux Installation` carrot to dropdown your current partitions  
      - Click on `/home` and change the size to `50 G` and click `Update Settings`  
      - Click on `/` and change the size to `50 G` and click `Update Settings`  
      - Click on the `+` and set the mount point to `/var/log/audit` and set the `Desired Capacity` to `10 G`  
      - Click on the `+` and set the mount point to `/tmp` and set the `Desired Capacity` to `10 G`  
      - Click on the `+` and set the mount point to `/var` and leave the `Desired Capacity` to `10 G`    
      - Click on the `+` and set the mount point to `/data` and leave the `Desired Capacity` blank to use the remaining storage    
      - You should have 6 partitions  
        - `/home` with `50 GiB`  
        - `/var/log/audit` with `10 GiB`  
        - `/tmp` with `10 GiB`
        - `/` with `50 GiB`  
        - `/var` with `10 GiB`
        - `/data` with all remaining space        
    - Click `Done`  
    - Click `Accept Changes`  
1. Click `kdump`
    - Uncheck `Enable kdump`
    - Click `Done`
1. `Installation Source` should say `Local media` and `Software Selection` should say `Minimal install` - no need to change this
1. Click `Date & Time`
    - `Region` should be changed to `Etc`
    - `City` should be changed to `Coordinated Universal Time`
    - `Network Time` should be toggled on
    - Click `Done`
1. Click `Begin Installation`
1. We're not going to set a Root passphrase because you will never, ever need it. Ever. Not setting a passphrase locks the Root account.
1. Create a user from the [../platform-management.md](Platform Management) page, but ensure that you toggle the `Make this user administrator` checkbox
![](../../images/admin-user.jpg)
1. Once the installation is done, click the `Reboot` button in the bottom right to...well...reboot
1. Login using the account you created during the Anaconda setup
1. Upon reboot, accept license agreement: `c` + `ENTER`

This will need to be done for each data node.

## Repo Changes

### Update Repository
Once the data nodes reboot we need to set the Nuc as the upstream RHEL repository You can copy / paste this following code block into the Terminal (once you update the `.[state octet].` with your [octet](../README.md)).

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

EOF'

```
Ensure that the local repo has been added and update.
```
sudo yum repolist all
sudo yum update -y
```

## Install Data Node Elements
Next we'll install Elasticsearch, Kibana, and configure them to receive data from the sensor.

### Installation of Elasticsearch
Elasticsearch is a distributed, RESTful search and analytics engine. It indexes and stores the Network Security Monitoring (NSM) data for the CMAT kit.
```
sudo yum install elasticsearch
```

### Installation of Kibana
Kibana lets you visualize your Elasticsearch data and navigate the Elastic Stack. It visualizes the NSM data for the CMAT kit.
```
sudo yum install kibana
```

Move onto [RockNSM Sensor](rocknsm-sensor.md)
