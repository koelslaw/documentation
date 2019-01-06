# RockNSM Sensor
This will cover the deployment of the RockNSM sensor elements.

## Preparing Installation Media
Now it's time to create a bootable USB drive with RHEL.  Let's look at few options.   

### CLI

If you live in the terminal, use `dd` to apply the image.  These instructions are for using a terminal in macOS.  If you're in a different environment, Google is your friend.  

:warning: Take CAUTION when using these commands by ENSURING you're writing to the correct disk / partition! :warning:

1. once you've inserted a USB, get the drive ID:  
`diskutil list`  

2. unmount the target drive so you can write to it:  
`diskutil unmountDisk /dev/disk#`  

3. write the image to drive:  
`sudo dd bs=8M if=path/to/esxi.iso of=/dev/disk#`  

If this is done on a Mac, you could get a popup once the operation is complete asking you to `Initialize, Ignore, Eject` the disk. You want to `Ignore` or `Eject`. `Initialize` will add a partition to it that will allow Mac to read the disk, and make it unbootable.  
![](../../images/mac-initialize-ignore-eject.png)  

### Via GUI

**MacOS:**  if using the terminal is currently a barrier to getting things rolling, [etcher.io](https://www.balena.io/etcher/) is an excellent GUI burning utility.  
**Windows:**  there are several great tools to apply a bootable image in MS land, but we recommend [rufus](https://rufus.akeo.ie/).  

## Building the Sensor Host
1. Put the USB drive into the [Dell in Case 2](../hardware-components.md)
1. Fire up the server and boot from the USB into Anaconda (the Linux install wizard)
1. Select your language
1. Start at the bottom-left, `Network & Host Name`
    - There is the `Host Name` box at the bottom of the window, enter the Sensor hostname from the [../platform-management.md](Platform Management) page
    - Switch the toggle to enable your NICs (you may need to have an Ethernet cable plugged into it)
      - Click `Configure` for your first NIC (the other NICs will be configured by the RockNSM deployment scripts)
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
    - Select the Solid State Drive disk
      - Click `Automatic Partitioning` and then click the checkbox that says `I would like to make additional space.`
      - Click `Done`  
      - There will be a popup window, in the bottom right, click `Delete All` and then `Reclaim Space`  
      - There will be a new popup window, click `Accept`  
      - Click on `Installation Destination`  
      - In the `Other Storage Options`, select `I will configure partitioning`.  
      - Click `Done`  
      - Click `Click here to create automatically.`  
      - Click on the `Red Hat Enterprise Linux Installation` carrot to dropdown your current partitions (create or update the following mount points)    
      - Click on the `+` and set the mount point to `/` and leave the `Desired Capacity` to `50 G`
      - Click on the `+` and set the mount point to `/tmp` and set the `Desired Capacity` to `10 G`  
      - Click on the `+` and set the mount point to `/var` and leave the `Desired Capacity` to `30 G`    
      - Click on the `+` and set the mount point to `/home` and leave the `Desired Capacity` to `10 G`
      - Click on the `+` and set the mount point to `/var/log/audit` and set the `Desired Capacity` to `25 G`  
      - Click on the `+` and set the mount point to `/data/stenographer` and leave the `Desired Capacity` to `7 T`
      - Click on the `+` and set the mount point to `/data` and leave the `Desired Capacity` blank to use the remaining storage    
      - You should have 7 partitions  
        - `/home` with `50 GiB`  
        - `/var/log/audit` with `25 GiB`  
        - `/tmp` with `10 GiB`
        - `/` with `50 GiB`  
        - `/var` with `30 GiB`
        - `/data/stenographer` with `7 TB`
        - `/data` with all remaining space     
      - Click `Done`  
      - Click `Accept Changes`    
  - Select the NVMe disk
    - Click `Automatic Partitioning` and then click the checkbox that says `I would like to make additional space.`
    - Click `Done`  
    - There will be a popup window, in the bottom right, click `Delete All` and then `Reclaim Space`  
    - There will be a new popup window, click `Accept`  
    - Click on `Installation Destination`  
    - In the `Other Storage Options`, select `I will configure partitioning`.  
    - Click `Done`  
    - Click `Click here to create automatically.`  
    - Click on the `Red Hat Enterprise Linux Installation` carrot to dropdown your current partitions (create or update the following mount points)    
    - Click on the `+` and set the mount point to `/data/kafka` and leave the `Desired Capacity` blank to use the remaining storage    
      - You should have 1 partition
      - `/data/kafka` with all space
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

## Sensor Installation
Now that we have build the OS, it is time to install the RockNSM sensor.\

Move onto [RockNSM Usage](rocknsm-usage.md)
