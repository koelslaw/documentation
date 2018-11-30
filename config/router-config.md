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

### NTP Setup
  - Connect to the serial port on the router
    - ```enable```
    - ```<password>```
  - Enter global configuration mode  
    - ```configure terminal```
  - The following command configures the timezone used by the Cisco software
    - ```clock timezone <timezone_abbreviation> <UTC_Offset>```
      - Example: ```clock timezone CST -6```
  - The following command configures summer time (daylight saving time) in areas where it starts and ends on a particular day of the week each year
    - ```clock summer-time CST recurring```
    - ```clock calendar-valid```
  - The following command forms a NTP master association and sets the Stratum level
    - ```ntp master <Stratum>```
      - Example: ```ntp master 8```
  - The following command displays whether a device is configured with NTP
    - ```show running-config | inclkude ntp```
  - The following command ends global configuration mode
    - ```end```
