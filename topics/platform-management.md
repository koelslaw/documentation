>THIS IS MEANT AS A TEMPLATE FOR YOUR DOCUMENTATION PLEASE DO NOT REUSE THESE AS THE USER/PASSWORDS

| Device                          | Case | Hostname                          | Management IP                  | Management UI                  | Out of Band Management (iDRAC) | Default Username | Default Passphrase | Current Username | Current Passphrase | Note                               |
|---------------------------------|------|-----------------------------------|--------------------------------|--------------------------------|--------------------------------|------------------|--------------------|------------------|--------------------|------------------------------------|
| Gigamon                         | 2    | tap.[state].cmat.lan              | 10.[state octet].10.5          | https://10.[state octet].10.5  | NA                             | admin            | admin123A!         | admin            | CYBERadmin1234!@#$ |                                    |
| Router                          | 1    | gateway.[state].cmat.lan          | 10.[state octet].10.2          | https://10.[state octet].10.2  | NA                             | username1        | password1          | admin            | CYBERadmin1234!@#$ | DNS Backup                         |
| Switch                          | 1    | switch.[state].cmat.lan           | 10.[state octet].10.3          | https://10.[state octet].10.3  | NA                             | NA               | NA                 | NA               | CYBERadmin1234!@#$ | NTP / DHCP                         |
| Server 1 IDRAC                  | 1    | idrac1.[state].cmat.lan           |                                |                                | 10.[state octet].10.6          | NA               |                    |                  |                    |                                    |
| Server 2 IDRAC                  | 2    | idrac2.[state].cmat.lan           |                                |                                | 10.[state octet].10.7          | NA               |                    |                  |                    |                                    |
| ESXi                            | 2    | esxi1.[state].cmat.lan            | 10.[state octet].10.15         | https://10.[state octet].10.15 | 10.[state octet].10.15         | root             | NA                 | root             | CYBERadmin1234!@#$ |                                    |
| Nuc                             | NA   | nuc.[state].cmat.lan              | 10.[state octet].10.19         | NA                             | NA                             | NA               | NA                 | admin            | CYBERadmin1234!@#$ |                                    |
| OpenVAS                         | NA   |                                   |                                |                                | 10.[state octet].20.2          |                  |                    |                  |                    | ACTIVE ACTIVE ACTIVE               |
| Red Hat Subscription            | NA   | NA                                | NA                             | NA                             | NA                             | cmtadmin         | 26093Pinz!         | NA               | NA                 | Red Hat Subscription Manager Creds |
| RockNSM Sensor                  | NA   | sensor.[state].cmat.lan           | 10.[state octet].10.21         | 10.[state octet].10.21         | NA                             | NA               | NA                 | admin            | CYBERadmin1234!@#$ |                                    |
| CAPES                           | NA   | capes.[state].cmat.lan            | 10.[state octet].10.28         | 10.[state octet].10.28         | NA                             | NA               | NA                 | admin            | CYBERadmin1234!@#$ |                                    |
| GRASSMARLIN                     | NA   | grassmarlin.[state].cmat.lan      | 10.[state octet].10.22         | 10.[state octet].10.22         | NA                             | NA               | NA                 | admin            | CYBERadmin1234!@#$ |                                    |
| DNS                             | NA   | dns.[state].cmat.lan              | 10.[state octet].10.20         | 10.[state octet].10.20         | NA                             | NA               | NA                 | admin            | CYBERadmin1234!@#$ |  Main DNS Server                   |
| ES1 (Elastic, Logstash, Kibana) | NA   | es1.[state].cmat.lan              | 10.[state octet].10.25         | 10.[state octet].10.25         | NA                             | NA               | NA                 | admin            | CYBERadmin1234!@#$ |                                    |
| ES2 (Elastic, Logstash)         | NA   | es2.[state].cmat.lan              | 10.[state octet].10.26         |                                | NA                             | NA               | NA                 | admin            | CYBERadmin1234!@#$ |                                    |
| ES3 (Elastic, Logstash)         | NA   | es3.[state].cmat.lan              | 10.[state octet].10.27         |                                | NA                             | NA               | NA                 | admin            | CYBERadmin1234!@#$ |                                    ||



> Note: The naming standard is `asset-type-#.state.cmat.lan`. The IP scheme is `10.[state octet].[VLAN].[host]`.  



| State      |  State Abbreviation   | State Octet |
|------------|-----------------------|-------------|
| Missouri   | MO                    | 1           |
| Hawaii     | HI                    | 2           |
| Ohio       | OH                    | 3           |
| Washington | WA                    | 4           |
