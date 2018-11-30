
# Network Configuration

## Address tables

The CMAT kits will abide by the following standard:
10.&lt;KIT&gt;.&lt;VLAN&gt;.&lt;HOST&gt;

### Router Gateways
| IP       | Router Gateway                             |
|:---------|:-------------------------------------------|
|10.1.10.1 | [VLAN 10 Gateway (Passive)](#passive-table)|
|10.1.20.1 | [VLAN 20 Gateway (Active)](#active-table)  |
|10.1.30.1 | VLAN 30 Gateway (Remote)                   |

### Subnets

##### Passive

| IP       | Connection  |
|:---------|:------------|
|10.1.10.2 | Router      |
|10.1.10.3 | Switch      |
|10.1.10.4 | Access Point|
|10.1.10.5 | Gigamon     |
|10.1.10.6 | IDRAC SVR 1 |
|10.1.10.7 | IDRAC SVR 2 |
|10.1.10.8 | IDRAC SVR 3 (MO ONLY)|
|10.1.10.9 | IDRAC SVR 4 (MO ONLY)|  
|10.1.10.10| CMC (MO ONLY)        |
|10.1.10.11| ESXI                 |
|10.1.10.12| Nuc                  |
|10.1.10.13| FREE IPA             |
|10.1.10.14 - 10.1.10.49  | Additional hardware Connections |
|10.1.10.50 - 10.1.10.99  | Static VM Assignments           |
|10.1.10.100 - 10.1.10.250| DHCP Assignments                |

##### Active

| IP       | Connection  |
|:---------|:------------|
|10.1.20.2 | Openvas     |

Move onto [Software Deployment](../software-deployment.md)
