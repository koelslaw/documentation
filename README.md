# CMAT Documentation

This repo serves as the main source of documentation for the Cyber Mission Assurance Team (CMAT) kit. This repository does not cover the concept of operations (CONOPS) for the team but rather how to build the kit and the concepts of employing (CONEMP) the kit.

## Build Steps
To walk through the build steps, [check out the README](./topics/README.md).

  **Famous Quote: When you wait till the last minute then it only takes a minute. -Jeff Geiger**

> NOTE: This documentation was made with best effort on a short timeline. Most of the documentation is correct, but there could be nuances or minor details that still need to be adjusted to your environment. Please contribute fixes back to the project.  

## Table of Contents

- [Cyber Mission Assurance Team (CMAT) Overview](./topics/cmat-overview.md)
- [Domestic Operations (DOMOPS) Overview](./topics/domops-overview.md)
- [Concept of Employment](./topics/cmat-conemp.md)
- [System Architecture](./topics/system-architecture.md)
- [Software Components](./topics/software-components.md)
- [Hardware Components](./topics/hardware-components.md)
- [Hardware Assembly](./topics/hardware-assembly.md)
- [Hardware Configuration](./topics/hardware-configuration.md)
  - [Intel Nuc Configuration](nuc/README.md)
  - [Gigamon Configuration](gigamon/README.md)
  - [Network Configuration](network/README.md)
  - [Dell R840 Configuration](dell/README.md)
- [Software Deployment](./topics/software-deployment.md)
  - Infrastructure
    - [ESXi](vmware/README.md)
  - Passive Software Deployment
    - [RHEL DNS Server](./dns/README.md)
    - [RockNSM](./rocknsm/README.md)
      - [Hardware Requirements](rocknsm-requirements.md)
      - [Rock NSM 2.2.x](./topics/rocknsm2-2-0/README.md)
      - [Rock NSM 2.3.x](./topics/rocknsm2-3-0/README.md)
      - Rock NSM 2.4.x
        - [Rock NSM 2.4.x (CENTOS)](./topics/rocknsm2-4-0/CENTOS/README.md)
        - [Rock NSM 2.4.x (RHEL)](./topics/rocknsm2-4-0/RHEL/README.md)
      - [Usage](rocknsm-usage.md)
    - [CAPES](./capes/README.md)
    - [GRASSMARLIN](./grassmarlin/README.md)
  - Active Software Deployment
    - [ACAS](./acas/README.md) - *Not opensource but **may** be available*
    - [OpenVAS](./openvas/README.md)
    - [Nmap](./nmap/README.md)
    - [BlueScope](./bluescope/README.md) *Not opensource but **may** be available*
  - Other Tools **MAY NOT BE PASSIVE IN NATURE**
    - Reverse Engineering
      - [Ghidra](./ghidra/README.md)
    - Windows Event Logging with native Tools
      - [WEFFLES](https://blogs.technet.microsoft.com/jepayne/2017/12/08/weffles/)

- [APPDX1 Network Layout](./topics/network/network-layout.md)
- [APPDX2 Function Check](./topics/function-check.md)
- [APPDX3 Platform Management (IPs, hostnames, creds, etc.)](./topics/platform-management.md)
