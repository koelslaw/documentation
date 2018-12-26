# Intel Nuc Configuration

The intel nuc an important part of the setup. It is used as you RPM repo, You doucmentation Source, and you ability to quickly rebuild os the kit for various reasons. It is also meant to be removable so it can update the rest of kit components and ROCK.

# Install RedHat Enterprise Linux (RHEL)
> Note: if necessary, these steps can be replicated to work with [CentOS Minimal](http://mirror.mobap.edu/centos/7.5.1804/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso).

## Create Installation Media

### Collect RHEL

Download RHEL from the RedHat partner portal.

Now it's time to create a bootable USB drive with that fresh RHEL build.  Let's look at few options.   

### CLI

If you live in the terminal, use `dd` to apply the image.  These instructions are for using a terminal in macOS.  If you're in a different environment, google is your friend.  

:warning: Take CAUTION when using these commands by ENSURING you're writing to the correct disk / partition! :warning:

1. once you've inserted a USB get the drive ID:  
`diskutil list`  

2. unmount the target drive so you can write to it:  
`diskutil unmountDisk /dev/disk#`  

3. write the image to drive:  
`sudo dd bs=8m if=path/to/rhel.iso of=/dev/disk#`  

If this is done on a Mac, you could get a popup once the operation is complete asking you to `Initialize, Ignore, Eject` the disk. You want to `Ignore` or `Eject`. `Initialize` will add a partition to it that will allow Mac to read the disk, and make it unbootable.  
![](../../images/mac-initialize-ignore-eject.png)  

### Via GUI

macOS:  if using the terminal is currently a barrier to getting things rolling, [etcher.io](http://etcher.io) is an excellent GUI burning utility.  

Windows:  there are several great tools to apply a bootable image in MS land, but we recommend [rufus](https://rufus.akeo.ie/).  

## Install RHEL
This is meant to help those who need a step-by-step build of RHEL, securing SSh, and getting ready to deploy the kit services provided by the Nuc. If you don't need this guide.  
1. Plug the USB media into the Nuc and power on  
1. Press `F10` to enter the boot menu  
1. Select the USB drive or UEFI  
1. Boot into Anaconda (the Linux install wizard)  
1. Select your language  
1. Start at the bottom-left, `Network & Host Name`  
    - There is the `Host Name` box at the bottom of the window, enter the hostname for the Nuc from the [Platform Management](../platform-management.md) page.  
    - Switch the toggle to enable your NIC  
      - Click `Configure`  
      - Go to `IPv4 Settings` and change the Method from `Automatic` to `Manual`. Click `Add` and set  
        - the IP address from the [Platform Management](../platform-management.md) page  
        - `Netmask 255.255.255.0`  
        - and `Gateway 10.[state octet].10.1`  
      - Go to `IPv6 Settings` and change from `Automatic` to `Ignore`  
      - Click `Save`  
    - Click `Done` in the top left  
1. Next the `Security Profile` in the lower right  
    - Select `United States Government Configuration Baseline (USGCB/STIG) - DRAFT`  
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
      - Click on the `+` and set the mount point to `/var` and leave the `Desired Capacity` blank  
      - You should have 7 partitions  
        - `/home` with `50 GiB`  
        - `/var/log/audit` with `10 GiB`  
        - `/tmp` with `10 GiB`
        - `/boot` with 1% of your total drive space  
        - `/` with `50 GiB`  
        - `swap` with about 1/2 of your total RAM  
        - `/var` with everything else  
    - Click `Done`  
    - Click `Accept Changes`  
1. Click `kdump`  
    - Uncheck `Enable kdump`  
    - Click `Done`  
1. `Installation Source` should say `Local media` and `Software Selection` should say `Minimal install` - no need to change this  
1. Validate `Software Selection` says `Minimal Install`  
1. Click `Date & Time`  
    - `Region` should be changed to `Etc`  
    - `City` should be changed to `Coordinated Universal Time`  
    - `Network Time` should be toggled on  
    - Click `Done`  
    - Note - the beginning of these install scripts configures Network Time Protocol (NTP). You just did that, but it's included just to be safe because time, and DNS, matter.  
1. Click `Begin Installation`  
1. We're not going to set a Root passphrase because you will not need it. Not setting a passphrase locks the Root account, which is what we want.  
1. Create a user, but ensure that you toggle the `Make this user administrator` checkbox. Use the [Platform Management](../platform-management.md) page for the user designation.  
1. Once the installation is done, click the `Reboot` button in the bottom right to...well...reboot  
1. Remove the USB device  
1. Login using the account you created during the Anaconda setup  

## Deploy Initial Configuration
Now we are going to deploy the initial configuration for the Nuc. This will serve as a repository to build the rest of the kit, as well as to store documentation.  


```
sudo subscription-manager register --username [see Platform Management] --password [see Platform Management] --auto-attach
```
:warning: The next action will result in large downloads. I would not recommend completing the following action unless you have a decent internet connection and/or some time. :warning:
```
sudo sh deploy-nuc.sh
```

Add the nuc git repo
 - rock-scripts
 - rock-dashboards
 - CAPES
 - rock
## Download the follwoing iso images

Move onto [Gigamon Configuration](../gigamon/README.md)
