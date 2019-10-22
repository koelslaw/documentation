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
  - [Intel Nuc Configuration](./topics/nuc/README.md)
  - [Gigamon Configuration](./topics/gigamon/README.md)
  - [Network Configuration](./topics/network/README.md)
  - [Dell R840 Configuration](./topics/dell/README.md)
- [Software Deployment](./topics/software-deployment.md)
  - Infrastructure
    - [ESXi](./topics/vmware/README.md)
  - Passive Software Deployment
    - [RHEL DNS Server](./topics/dns/README.md)
    - [RockNSM](./topics/rocknsm/README.md)
      - [Hardware Requirements](./topics/rocknsm-requirements.md)
      - [Rock NSM 2.2.x](./topics/rocknsm2-2-0/README.md)
      - [Rock NSM 2.3.x](./topics/rocknsm2-3-0/README.md)
      - Rock NSM 2.4.x
        - [Rock NSM 2.4.x (CENTOS)](./topics/rocknsm2-4-0/CENTOS/README.md)
        - [Rock NSM 2.4.x (RHEL)](./topics/rocknsm2-4-0/RHEL/README.md)
      - Rock NSM 2.5.x (Pending)
        - [Rock NSM 2.5.x (CENTOS)](./topics/rocknsm2-5-0_Pending/CENTOS/README.md)
        - [Rock NSM 2.5.x (RHEL)](./topics/rocknsm2-5-0_Pending/RHEL/README.md)
      - [Usage](./topics/rocknsm/README.md)
    - [CAPES](./topics/capes/README.md)
    - [GRASSMARLIN](./topics/grassmarlin/README.md)
  - Active Software Deployment
    - [ACAS](./topics/acas/README.md) - *Not opensource but **may** be available*
    - [OpenVAS](./topics/openvas/README.md)
    - [Nmap](./topics/nmap/README.md)
    - [BlueScope](./bluescope/README.md) *Not opensource but **may** be available*
  - Other Tools **MAY NOT BE PASSIVE IN NATURE**
    - Reverse Engineering
      - [Ghidra](./topics/ghidra/README.md)
    - Windows Event Logging with native Tools
      - [WEFFLES](https://blogs.technet.microsoft.com/jepayne/2017/12/08/weffles/)

- [Preflight](./topics/deployment/README.md)
- [APPDX1 Network Layout](./topics/network/network-layout.md)
- [APPDX2 Function Check](./topics/function-check.md)
- [APPDX3 Platform Management (IPs, hostnames, creds, etc.)](./topics/platform-management.md)
