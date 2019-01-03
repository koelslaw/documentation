>THIS IS MEANT AS A TEMPLATE FOR YOUR DOCUMENTATION PLEASE DO NOT REUSE THESE AS THE USER/PASSWORDS


| Device                          | Case | Hostname                 | Management IP          | Management UI                  | Out of Band Management (iDRAC) | Default Username | Default Passphrase | Current Username | Current Passphrase | Note                               |
|---------------------------------|------|--------------------------|------------------------|--------------------------------|--------------------------------|------------------|--------------------|------------------|--------------------|------------------------------------|
| Gigamon                         | 2    | tap.[state].cmat.lan     | 10.[state octet].10.5  | https://10.[state octet].10.5  | NA                             | admin            | admin123A!         | admin            | CYBERadmin1234!@#$ |                                    |
| Router                          | 1    | gateway.[state].cmat.lan | 10.[state octet].10.2  | https://10.[state octet].10.2  | NA                             | username1        | password1          | admin            | CYBERadmin1234!@#$ | DNS                                |
| Switch                          | 1    | switch.[state].cmat.lan  | 10.[state octet].10.3  | https://10.[state octet].10.3  | NA                             | NA               | NA                 | NA               | CYBERadmin1234!@#$ | NTP / DHCP                         |
| Server                          | 1    |                          |                        |                                | 10.[state octet].10.6          | NA               |                    |                  |                    |                                    |
| Server                          | 2    |                          |                        |                                | 10.[state octet].10.7          | NA               |                    |                  |                    |                                    |
| Server (MO Only)                | 1    |                          |                        |                                | 10.[state octet].10.8          | NA               |                    |                  |                    |                                    |
| Server (MO Only)                | 1    |                          |                        |                                | 10.[state octet].10.9          | NA               |                    |                  |                    |                                    |
| Chasis Management Console (CMC) | 1    |                          |                        |                                | 10.[state octet].10.10         | root             | calvin             | root             | CYBERadmin1234!@#$ |                                    |
| ESXi                            | 2    | esxi.[state].cmat.lan    | 10.[state octet].10.12 | https://10.[state octet].10.12 | 10.[state octet].10.11         | root             | NA                 | root             | CYBERadmin1234!@#$ |                                    |
| Nuc                             | NA   | nuc.[state].cmat.lan     | 10.[state octet].10.12 | NA                             | NA                             | NA               | NA                 | admin            | CYBERadmin1234!@#$ |                                    |
| FreeIPA                         | NA   |                          |                        |                                | 10.[state octet].10.13         | NA               |                    |                  |                    |                                    |
| OpenVAS                         | NA   |                          |                        |                                | 10.[state octet].20.2          |                  |                    |                  |                    |                                    |
| Red Hat Subscription            | NA   | NA                       | NA                     | NA                             | NA                             | cmtadmin         | 26093Pinz!         | NA               | NA                 | Red Hat Subscription Manager Creds |
|                                 |      |                          |                        |                                |                                |                  |                    |                  |                    |                                    |

> Note: The naming standard is `asset-type-#.state.cmat.lan`. The IP scheme is `10.[state octet].[VLAN].[host]`.  

| State      |  State Abbreviation   | State Octet |
|------------|-----------------------|-------------|
| Missouri   | MO                    | 1           |
| Hawaii     | HI                    | 2           |
| Ohio       | OH                    | 3           |
| Washington | WA                    | 4           |
