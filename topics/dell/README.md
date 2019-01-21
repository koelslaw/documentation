# Dell R840 Configuration (Server 1 and 2)

## Prereq
- Monitor
- Keyboard
- Mouse

### Configure iDRAC for Both Servers

Once power has been connected to the servers setup they should automatically boot the lifecycle controllers. If not, hit `F10`.


1. Navigate to -> `System Setup`

2. Click `Advanced Hardware Configuration`

  ![](../../images/lifecyclecontroller.png){#id .class width=70%}

3. Select `IDRAC settings`
  ![](../../images/IMG_20190105_101747.jpg){#id .class width=70%}

4. Select `Network`
  ![](../../images/IMG_20190105_101906.jpg){#id .class width=70%}

5. Set the following values:
  - IPV4: Enabled
  - DHCP : Disabled
  - IP, Gateway, & DNS: Consult [platform-management](../platform-management.md)
  - Subnet: 255.255.255.0
  - IPV6: Disable

6. Click `Back`
7. Click `Finish`
8. Click `Finish`, Again.
9. Click `Yes` to save the IDRAC configuration, and `ok`
10. This should return you to the System Setup page
11. **Repeat for other server**

___

### Raid Configuration for Installation

#### Data Tier SSDs (ESXI (Server 2))
1. Navigate to -> `System Setup`

2. Click `Advanced Hardware Configuration`
> if you are already in the system setup page then you can skip this step

  ![](../../images/lifecyclecontroller.png){#id .class width=70%}

3. Navigate to -> `Device Settings`

  ![](../../images/IMG_20190105_093432.jpg){#id .class width=70%}

4. Select the RAID Controller that is labeled PERC

  ![](../../images/IMG_20190105_093446.jpg){#id .class width=70%}

5. Select Configure

  ![](../../images/configure for raid.png){#id .class width=70%}

>NOTE: **If** the disks have had previously installed OS on them do a cryptographic wipe prior to creating the raid arrays.

6. Select Create Virtual disk

  ![](../../images/IMG_20190105_093919.jpg){#id .class width=70%}


  - Answer check `confirm` and `yes` to the question `Are you sure you want to clear this configuration?`

  - Select `Create Virtual Drive`

  - Select `RAID0`

  - Select `Unconfigured Capacity`

  - Select `Select Physical Drives`

    ![](../../images/IMG_20190105_094155.jpg){#id .class width=70%}

    - Drive Configuration as follows:
      - Media Type: SSD
      - Interface Type: SATA
      - Sector Size: 512 B
      - Select **ONLY** the ~240 GB hardrive
    - Select `Apply Changes` and `Ok`
  - Enter Virtual Disk Name: OS
  - Select `Create Virtual Drive` at the bottom of the page. Check `Confirm` and `Yes` then `Ok`

7. Select Create Virtual disk

  ![](../../images/IMG_20190105_093919.jpg){#id .class width=70%}


  - Answer check `confirm` and `yes` to the question `Are you sure you want to clear this configuration?`

  - Select `Create Virtual Disk`

  - Select `RAID0`

  - Select `Unconfigured Capacity`

  - Select `Select Physical Drives`

    ![](../../images/IMG_20190105_094155.jpg){#id .class width=70%}

    - Drive Configuration as follows:
      - Media Type: SSD
      - Interface Type: SATA
      - Sector Size: 512 B
      - Select the remaining 1.7 TB SSD Harddrives
    - Select `Apply Changes` and `Ok`
  - Enter Virtual Disk Name: FAST
  - Select `Create Virtual Drive` at the bottom of the page. Check `Confirm` and `Yes` then `Ok`

**Move to Server 1**
___

#### Sensor SSDs (Server 1)
1. Navigate to -> `System Setup`

2. Click `Advanced Hardware Configuration`
> if you are already in the system setup page then you can skip this step

  ![](../../images/lifecyclecontroller.png){#id .class width=70%}

3. Navigate to -> `Device Settings`

  ![](../../images/IMG_20190105_093432.jpg){#id .class width=70%}

4. Select the RAID Controller that is labeled PERC

  ![](../../images/IMG_20190105_093446.jpg){#id .class width=70%}

5. Select Configure

  ![](../../images/configure for raid.png){#id .class width=70%}

> NOTE: **If** the disks have had previously installed OS on them do a cryptographic wipe prior to creating the raid arrays.

6. Select Create Virtual disk

  ![](../../images/IMG_20190105_093919.jpg){#id .class width=70%}

  - Answer check `confirm` and `yes` to the question `Are you sure you want to clear this configuration?`

  - Select `Create Virtual Disk`

  - Select `RAID0`

  - Select `Unconfigured Capacity`

  - Select `Select Physical Drives`
    ![](../../images/IMG_20190105_094155.jpg){#id .class width=70%}

    - Drive Configuration as follows:
      - Media Type: SSD
      - Interface Type: SATA
      - Sector Size: 512 B
      - Select **ONLY** the ~240 GB hardrive
    - Select `Apply Changes` and `Ok`
  - Enter Virtual Disk Name: OS
  - Select `Create Virtual Drive` at the bottom of the page. Check `Confirm` and `Yes` then `Ok`

7. Select Create Virtual disk

  ![](../../images/IMG_20190105_093919.jpg){#id .class width=70%}

  - Answer check `confirm` and `yes` to the question `Are you sure you want to clear this configuration?`

  - Select `Create Virtual Disk`

  - Select `RAID0`

  - Select `Unconfigured Capacity`

  - Select `Select Physical Drives`

    ![](../../images/IMG_20190105_094155.jpg){#id .class width=70%}

    - Drive Configuration as follows:
      - Media Type: SSD
      - Interface Type: SATA
      - Sector Size: 512 B
      - Select the remaining 1.7 TB SSD Harddrives
    - Select `Apply Changes` and `Ok`
  - Enter Virtual Disk Name: FAST
  - Select `Create Virtual Drive` at the bottom of the page. Check `Confirm` and `Yes` then `Ok`


8. If done correctly, you should be greeted with a screen saying that you cannot configure any more drives, Click `Back`

  ![](../../images/IMG_20190105_095721.jpg){#id .class width=70%}

At this point you have finished. the NVME drives will be standalone and not in a RAID Configuration.


9. When Configuration is finished exit Lifecycle Controller and Install OS via the iDRAC or Installation Media

  ![](../../images/lifecyclecontroller.png){#id .class width=70%}

Proceed to [Software Deployment](../topic/software-deployment.md)
