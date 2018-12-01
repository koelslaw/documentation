
# Network Configuration

## Address tables

The CMAT kits will use the following network standard: `10.[KIT].[VLAN].[HOST]`

## VLANs
| VLAN  |  Port     | Description |
|-------|-----------|-------------|
| 10    | 1 - 39    | Internal    |
| 20    | 40 - 48   | Active      |

## Router Gateways
| IP       | Router Gateway                              |
|:---------|:--------------------------------------------|
|10.1.10.1 | [VLAN 10 Gateway (Passive)](#passive-table) |
|10.1.20.1 | [VLAN 20 Gateway (Active)](#active-table)   |
|10.1.30.1 | VLAN 30 Gateway (Remote)                    |

## Subnets
