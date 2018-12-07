# Usage Guide

## Start / Stop / Status

These functions are accomplished with `rockctl  {start|stop|status}`.

> NOTE: these may need to be prefaced with /usr/local/bin/ depending on your _$PATH_.

- `rockctl status`

![](https://asciinema.org/a/z9qgFqFTr9HoeSMpX2gKWXqng.png)

- `rockctl start`

![](https://asciinema.org/a/QAxK2iiWEw2bFRKUc5JFri3n9.png)

- `rockctl stop`

![](https://asciinema.org/a/ME56ahRQrj3qmrynGzCc47GyM.png)

## Key web interfaces

https://localhost - Kibana web interface - After deploy, the created creds are in the home directory of the user created upon install as `KIBANA_CREDS.README`<br />  

https://localhost:8443 - Docket - web interface for pulling PCAP from the sensor (must be enabled in config)

> localhost = IP of the management interface of the box  

Move onto [VMWare ESXi](../vmware/README.md)
