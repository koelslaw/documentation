| Device                          | Case | Hostname            | Management IP | Management UI     | Out of Band Management (iDRAC) | Management Username | Default Passphrase | Current Passphrase |
|---------------------------------|------|---------------------|---------------|-------------------|--------------------------------|---------------------|--------------------|--------------------|
| Gigamon                         | 2    | tap.mo.cmat.lan     | 10.1.10.5     | https://10.1.10.5 | NA                             | admin               | admin123A!         | CYBERadmin1234!@#$ |
| Router                          | 1    | gateway.mo.cmat.lan | 10.1.10.2     |                   |                                |                     |                    |                    |
| Switch                          | 1    | switch.mo.cmat.lan  | 10.1.10.3     |                   |                                | NA                  | NA                 | CYBERadmin1234!@#$ |
| Server                          | 1    |                     |               |                   | 10.1.10.6                      |                     |                    |                    |
| Server                          | 2    |                     |               |                   | 10.1.10.7                      |                     |                    |                    |
| Server (MO Only)                | 1    |                     |               |                   | 10.1.10.8                      |                     |                    |                    |
| Server (MO Only)                | 1    |                     |               |                   | 10.1.10.9                      |                     |                    |                    |
| Chasis Management Console (CMC) | 1    |                     |               |                   | 10.1.10.10                     |                     |                    |                    |
| ESXi                            |      |                     |               |                   | 10.1.10.11                     |                     |                    |                    |
| Nuc                             | NA   |                     |               |                   | 10.1.10.12                     |                     |                    |                    |
| FreeIPA                         | NA   |                     |               |                   | 10.1.10.13                     |                     |                    |                    |
|                                 |      |                     |               |                   |                                |                     |                    |                    |
|                                 |      |                     |               |                   |                                |                     |                    |                    |
|                                 |      |                     |               |                   |                                |                     |                    |                    |

**Note:** The naming standard is `asset-type-#.state.cmat.lan`.
