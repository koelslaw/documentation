# Installation Guide for RHEL/7


## Prerequisites:

- RHEL/7 install media

---

## Preparing Media

If not already done, move one of the SSDs to the server that will be your
sensor. This ensures you have enough room for stenographer data.

## Apply the Image

Now it's time to create a bootable USB drive with RHEL/ESXi.  Let's look at few
options:

### Graphical Tools

macOS:  if using the terminal is currently a barrier to getting things rolling,
[etcher.io](http://etcher.io) is an excellent GUI burning utility.  

Windows:  there are several great tools to apply a bootable image in MS land,
but we recommend one of the following:  
- [rufus](https://rufus.akeo.ie/)
- [unetbootin](https://unetbootin.github.io/)


### Via CLI

The go-to utility for writing disk images from the CLI is `dd`.  

These instructions are specific to macOS.  If you're in a different environment,
`lsblk` and `dmesg` are helpful utilities for locating the correct storage
device to write to.  

:warning: Take CAUTION when using these commands by ENSURING you're writing to the correct disk / partition! :warning:

1. Insert a USB drive and run the following command to determine the device
path:  
`diskutil list`  

2. Unmount the target drive so you can write to it:  
`diskutil unmountDisk /dev/disk#`  

3. Write the image to drive:  
`sudo dd bs=8M if=path/to/rhel-iso of=/dev/disk#`  


### Date & Time

UTC is generally preferred for logging data as the timestamps from anywhere in the world will have a proper order without calculating offsets. That said, Kibana will present the Bro logs according to your timezone (as set in the browser). The bro logs themselves (i.e. in `/data/bro/logs/`) log in epoch time and will be written in UTC regardless of the system timezone.

Bro includes a utility for parsing these on the command line called `bro-cut`. It can be used to print human-readable timestamps in either the local sensor timezone or UTC. You can also give it a custom format string to specify what you'd like displayed.


### Network

#### - Management Interface

Before beginning the install process it's best to connect the interface you've selected to be the **management interface**.  Here's the order of events:  

1. ROCK will initially look for an interface with a default gateway and treat that interface as MGMT
2. All remaining interfaces will be treated as MONITOR

> This will be the 2 ethernet cables running from the gigamon to the back of the server in the same case (sensor)

#### Interfaces

- em1
- em2
- em3                                 ( will be connected to gigamon tap )
- em4 **connect for mgmgt interface** ( will be connected to gigamon tap )

Ensure that the interface you intend to use for MGMT has been turned on and has a static IP and proper name outlined in [Platform Management page](../platform-management.md)


#### - Data Tier (ESXi) Setup

There will not be any monitor interfaces only the management interfaces. Ensure a management interface is set with a static IP and proper name outlined in [Platform Management page](../platform-management.md)

### Security profiles

Apply the DISA STiG


### Partitioning

There are two separate node types: **sensor** and **data** tiers. The partitioning
will differ for each server.

### VGs

```
@sean can you please put this into `rocknsm-datanode.md`?

You can delete this afterwards.

-- andy
```


ensure drive designation

rhel   sda        223GiB
fast   sdb        7.4 TB
faster nvme0n1    1.4 TB

#### Sensor Tier

The main focus for storage on the **sensor** is for Stenographer to retain
network traffic.

Set up the partitions as follows:

##### Volume Group - "fast"

fast VG  
- /data/stenographer/ = blank to use all available space ( ~ 7TiB )

##### Volume Group - "faster"

faster VG =
- /data/kafka = blank to use all available space ( ~ 1.5TiB )

##### Volume Group - "rhel"


- `swap` = no change
- `/boot` = no change
- `/boot/efi` = no change
- `/` = 50 GB small
- `/var` = 30 GB
- `/var/log/audit` = 10 GB
- `/tmp`  = 10 GB
- `/home` = 50 GB
- `/data`  = blank (to use all remaining)


#### Data Tier

The data tier (a.k.a _any_ Elasticsearch node) will need space to retain all
the indexed information from the sensor and distribute the load amongst the
3 Elastic nodes.

Set up the partitions as follows:

- / = 50 GB SSD
- /home = 50 GB SSD
- /var = 10 GB SSD
- /var/log/audit = 10 GB SSD
- /tmp  = 10 GB SSD
- /boot = default SSD
- /data  = All remaining SSD <--- Elastic lives here

\\

Setup the LVM Cache as follows:

<!-- Step 1-7 TODO NVME @brad -->

Click "Begin Installation"  

### User Creation

Leave the root user disabled.  We recommend that you leave it that way.  Once
you've kicked off the install, click **User Creation** at the next screen
(shown above) and complete the required fields to set up a non-root admin
user.  

![](../../images/admin-user.jpg)

> If this step is not completed now do not fear, you will be prompted to create this account after first login.

- click **Finish Installation** and wait for reboot
- accept license agreement: `c` + `ENTER`




The last step before configuring sensor settings is to update the base OS to
current: `sudo yum update -y && reboot`  


Move onto [Rock NSM Deploy](rock-deploy.md).
