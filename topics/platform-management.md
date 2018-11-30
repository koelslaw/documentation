| Device                          | Case | Hostname            | Management IP | Management UI     | Out of Band Management (iDRAC) | Default Username | Default Passphrase | Current Username | Current Passphrase |
|---------------------------------|------|---------------------|---------------|-------------------|--------------------------------|------------------|--------------------|------------------|--------------------|
| Gigamon                         | 2    | tap.mo.cmat.lan     | 10.1.10.5     | https://10.1.10.5 | NA                             | admin            | admin123A!         | admin            | CYBERadmin1234!@#$ |
| Router                          | 1    | gateway.mo.cmat.lan | 10.1.10.2     | https://10.1.10.2 | NA                             | username1        | password1          | admin            | CYBERadmin1234!@#$ |
| Switch                          | 1    | switch.mo.cmat.lan  | 10.1.10.3     | https://10.1.10.3 | NA                             | NA               | NA                 | NA               | CYBERadmin1234!@#$ |
| Server                          | 1    |                     |               |                   | 10.1.10.6                      | NA               |                    |                  |                    |
| Server                          | 2    |                     |               |                   | 10.1.10.7                      | NA               |                    |                  |                    |
| Server (MO Only)                | 1    |                     |               |                   | 10.1.10.8                      | NA               |                    |                  |                    |
| Server (MO Only)                | 1    |                     |               |                   | 10.1.10.9                      | NA               |                    |                  |                    |
| Chasis Management Console (CMC) | 1    |                     |               |                   | 10.1.10.10                     | NA               |                    |                  |                    |
| ESXi                            |      |                     |               |                   | 10.1.10.11                     | NA               |                    |                  |                    |
| Nuc                             | NA   |                     |               |                   | 10.1.10.12                     | NA               |                    |                  |                    |
| FreeIPA                         | NA   |                     |               |                   | 10.1.10.13                     | NA               |                    |                  |                    |
|                                 |      |                     |               |                   |                                |                  |                    |                  |                    |
|                                 |      |                     |               |                   |                                |                  |                    |                  |                    |
|                                 |      |                     |               |                   |                                |                  |                    |                  |                    |

**Note:** The naming standard is `asset-type-#.state.cmat.lan`.
