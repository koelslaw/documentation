# Hardware Configuration

When tailoring this documentation, you should replace `[state]` and `[state octet]` with your designated state abbreviation and assigned state octet. For DNS it will follow `[item].[state].cmat.lan` with `cmat.lan` being the name for the entire domain. An example url would be `nuc.mo.cmat.lan`. The IP scheme also follows a pattern and should look like `10.[state].[vlan].[device]`.

| State      |  State Abbreviation   | State Octet |
|------------|-----------------------|-------------|
| Missouri   | MO                    | 1           |
| Hawaii     | HI                    | 2           |
| Ohio       | OH                    | 3           |
| Washington | WA                    | 4           |

Consult the [Platform Management](platform-management.md) page to to get all the IP addresses and dns entries.


## Table of Contents
1. [Intel Nuc Configuration](nuc/README.md)
2. [Gigamon Configuration](gigamon/README.md)
3. [Network Configuration](network/README.md)
4. [Dell R840 Configuration](dell/README.md)

Move to [Software Deployment](platform-management.md)

**If** installed:
 - [Dell Chassis Management Console (CMC) Configuration](network/cmc-configuration.md)
