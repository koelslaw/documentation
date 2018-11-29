# Router Configuration

### DNS Setup
 - Connect to the serial port on the router
 - Enter enable mode:
    - ```enable```
    - ```<password>```
 - Enable dns service and domain lookup
    - ```configure terminal```
    - ```ip dns server```
    - ```ip domain-lookup```
 - Enter host names to meet the folloing specification: ip host <hardware>.<state-abreviation>.cmat.lan 10.<Kit>.<VLAN>.<Host>
    - example: ```ip host switch.mo.cmat.lan 10.1.10.3```
  - Exit configure mode: ```exit```
