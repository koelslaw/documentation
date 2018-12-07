# VMWare ESXi Configuration

Before you start, ensure that your server is [properly racked](../hardware-assembly.md)

VMware ESXi is a purpose-built bare-metal hypervisor that installs directly onto a physical server. With direct access to and control of underlying resources, ESXi is more efficient than hosted architectures and can effectively partition hardware to increase consolidation ratios.

# Install ESXi

## Collect ESXi

Download ESXi from the VMWare portal.

Now it's time to create a bootable USB drive with that fresh ESXi build.  Let's look at few options.   

### CLI

If you live in the terminal, use `dd` to apply the image.  These instructions are for using a terminal in macOS.  If you're in a different environment, google is your friend.  

:warning: Take CAUTION when using these commands by ENSURING you're writing to the correct disk / partition! :warning:

1. once you've inserted a USB get the drive ID:  
`diskutil list`  

2. unmount the target drive so you can write to it:  
`diskutil unmountDisk /dev/disk#`  

3. write the image to drive:  
`sudo dd bs=8m if=path/to/esxi.iso of=/dev/disk#`  

If this is done on a Mac, you could get a popup once the operation is complete asking you to `Initialize, Ignore, Eject` the disk. You want to `Ignore` or `Eject`. `Initialize` will add a partition to it that will allow Mac to read the disk, and make it unbootable.  
![](../../images/mac-initialize-ignore-eject.png)  

### Via GUI

**acOS:**  if using the terminal is currently a barrier to getting things rolling, [etcher.io](http://etcher.io) is an excellent GUI burning utility.  
**Windows:**  there are several great tools to apply a bootable image in MS land, but we recommend [rufus](https://rufus.akeo.ie/).  

## Installation Instructions

1. Load the ESXi installer media in a physical or virtual drive on your host machine and restart the host machine  
1. Set the BIOS to boot from the media  
1. Select the ESXi installer in the boot menu and press Enter  
1. To accept the EULA, press `F11`  
1. Select the drive on which to install ESXi and press Enter  
1. To select the default keyboard layout for the host, press Enter  
1. To set the host password in accordance with the [Platform Management](../platform-management.md) page  
1. To begin installation, press `F11`  
1. After the installation finishes, remove the installation media and press Enter to restart the host

# Post Installation Configuration

1. After the system reboots, you will be at the default ESXi landing page  
1. Press `F2` and log in as `root` and use your passphrase stored on the [Platform Management](../platform-management.md) page  
1. Go down to `Configure Management Network`  
1. Go down to `IPv4 Configuration`  
1. Ensure that `Set static IPv4 address and network configuration` is set (you can toggle it by selecting it and pressing the `Space` bar)  
1. Enter the `IPv4 Address`, `Subnet Mask`, and `Default Gateway`, and press `Enter`  
1. Go down and select `DNS Configuration`  
1. Enter your DNS and hostname information from the [Platform Management](../platform-management.md) page and press `Enter`  
1. Press `esc`, then `Y` to save your changes and restart your management interface  
1. Go down and select `Test Management Network` and ping your gateway IP from the [Platform Management](../platform-management.md) page to validate the settings  
1. Press `esc` to log out  

# Upload Media to Datastore
**Note:** this could be a bit different, specifically around the Storage considerations. I recommend you update the documentation with your specific environment.  

1. Point your browser to `https://esxi-managment-ip` from the [Platform Management](../platform-management.md) page  
1. Log in with your user credential pair from the [Platform Management](../platform-management.md) page  
1. Right-click on `Storage` and select `Browse datastores`  
![](../../images/esxi-browse-datastore.png)  
1. Click on `Create directory` and make a new directory called `iso`  
1. Click on the new `iso` folder and click `Upload`  
1. Upload your RHEL and RockNSM ISO's, when that's done, click `Close`  

# Create Networking Ports

1. Right-Click on `Networking` and select `Add port group`  
![](../../images/esxi-network-port-group.png)  
1. Enter the following:
  - Name: `Passive`  
  - VLAN ID: `10`  
  - Virtual switch: `vSwitch0`  
  - Security: `Inherit from vSwitch`  
1. Enter the following:
  - Name: `Management`  
  - VLAN ID: `10`  
  - Virtual switch: `vSwitch0`  
  - Security: `Inherit from vSwitch`  
1. Enter the following:
  - Name: `Active`  
  - VLAN ID: `20`  
  - Virtual switch: `vSwitch0`  
  - Security: `Inherit from vSwitch`  

# Create the CAPES Virtual Machine
1. Right-Click on `Virtual Machines` and select `Create/Register VM`  
![](../../images/esxi-create-vm.png)  
  - Name: `capes`  
  - Compatibility: Leave default  
  - Guest OS Family: `Linux`  
  - Guest OS Version: `Red Hat Enterprise Linux 7 (64-bit)`  
1. Select your storage  
1. Customize the VM  
  - CPU: `2`  
  - Memory: `12 GB`  
  - Hard disk 1: `50 GB`  
  - SCSI Controller 0: Leave default  
  - SATA Controller 0: Leave default  
  - USB controller 1:  Leave default  
  - Network Adapter: `Passive`, ensure that `Connect` is enabled  
  - CD/DVD Drive 1: `Datastore ISO file`, select the RHEL ISO you uploaded above, ensure that `Connect` is enabled  
  - Video Card:  Leave default  
1. Review your settings  
1. Click Finish  

# Create the Sensor Data Tier Virtual Machine
1. Select `Create/Register VM`  
  - Name: `data-tier`  
  - Compatibility: Leave default  
  - Guest OS Family: `Linux`  
  - Guest OS Version: `Red Hat Enterprise Linux 7 (64-bit)`  
1. Select your storage  
1. Customize the VM  
  - CPU: `x`  
  - Memory: `xx GB`  
  - Hard disk 1: `xx GB`  
  - SCSI Controller 0: Leave default  
  - SATA Controller 0: Leave default  
  - USB controller 1:  Leave default  
  - Network Adapter: `Passive`, ensure that `Connect` is enabled  
  - CD/DVD Drive 1: `Datastore ISO file`, select the RHEL ISO you uploaded above, ensure that `Connect` is enabled  
  - Video Card:  Leave default  
1. Review your settings  
1. Click Finish  

# Create the Active Virtual Machine
1. Select `Create/Register VM`  
  - Name: `active`  
  - Compatibility: Leave default  
  - Guest OS Family: `Linux`  
  - Guest OS Version: `Red Hat Enterprise Linux 7 (64-bit)`  
1. Select your storage  
1. Customize the VM  
  - CPU: `x`  
  - Memory: `xx GB`  
  - Hard disk 1: `xx GB`  
  - SCSI Controller 0: Leave default  
  - SATA Controller 0: Leave default  
  - USB controller 1:  Leave default  
  - Network Adapter: `Passive`, ensure that `Connect` is enabled  
  - CD/DVD Drive 1: `Datastore ISO file`, select the RHEL ISO you uploaded above, ensure that `Connect` is enabled  
  - Video Card:  Leave default  
1. Review your settings  
1. Click Finish  
