# Bare Metal Server OS Install
### Topology for Bare Metal
```
+------------------------------+
| Dell Server 1  (ESXi 1)      |
|                              |
|                              |
|                           <------------+
|                              |         |
|                              |         |
|                              |         |
|                              |         |
+------------------------------+         +---------------------------------+
                                         |                                 |
                                         |  Intel Nuc (Iso  Master)        |
                                         |                                 |
                                         +---------------------------------+
+------------------------------+         |
| Dell Server 2   (ESXi 2)     |         |
|                              |         |
|                              |         |
|                           <------------+
|                              |
|                              |
|                              |
+------------------------------+

```
#### Instructions:

1. Load the ESXi installer media in a physical or virtual drive on your host machine and restart the host machine.

2. Set the BIOS to boot from the media.

3. Select the ESXi 5.1 installer in the boot menu and press Enter.

4. To accept the EULA, press F11.

5. Select the drive on which to install ESXi and press Enter.

6. To select the default keyboard layout for the host, press Enter.

7. To set the host password, type my_esx_password and retype the password to confirm it.

8. To begin installation, press F11.

9. After the installation finishes, remove the installation media and press Enter to restart the host.

10. Repeat steps Step 1-Step 9 to install ESXi 2 on machine.
