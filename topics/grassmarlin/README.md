# GRASSMARLIN Install
GRASSMARLIN provides IP network situational awareness of industrial control systems (ICS) and Supervisory Control and Data Acquisition (SCADA) networks to support network security. Passively map, and visually display, an ICS/SCADA network topology while safely conducting device discovery, accounting, and reporting on these critical cyber-physical systems.

## Documentation
GrassMarlin v3.2 User Guide:  
- [Download PDF](topics/grassmarlin/GRASSMARLIN User Guide.pdf)   
- [Presentation on GRASSMARLIN](topics/grassmarlin/GRASSMARLIN_Briefing_20170210.pptx)  

## Install Instructions

Install RHEL with GUI


### Update Repository
We want to set the Nuc as the upstream repository, you can copy / paste this following code block into the Terminal.
```
sudo bash -c 'cat > /etc/yum.repos.d/local-repos.repo <<EOF
[atomic]
name: Atomic for OpenVAS
baseurl=http://10.1.10.19/atomic/
gpgcheck=0
enabled=1

[capes]
name: Capes Local
baseurl=http://10.1.10.19/capes/
gpgcheck=0
enabled=1

[copr-rocknsm-2.1]
name: copr rocknms repo
baseurl=http://10.1.10.19/copr-rocknsm-2.1/
gpgcheck=0
enabled=1

[local-epel]
name: Extra packages For Enterprise Linux Local Repo
baseurl=http://10.1.10.19/epel/
gpgcheck=0
enabled=1

[local-rhel-7-server-extras-rpmsx86_64]
name: local rhel 7 server extras
baseurl=http://10.1.10.19/rhel-7-server-extras-rpms/
gpgcheck=0
enabled=1

[local-rhel-7-server-optional-rpmsx86_64]
name: local rhel 7 server optional
baseurl=http://10.1.10.19/rhel-7-server-optional-rpms/
gpgcheck=0
enabled=1

[local-rhel-7-server-rpmsx86_64]
name: local rhel 7 server rpms
baseurl=http://10.1.10.19/rhel-7-server-rpms/
gpgcheck=0
enabled=1

[local-wandiscox86_64]
name: wandisco
baseurl=http://10.1.10.19/WANdisco-git/
gpgcheck=0
enabled=1

[local-elastic-6.x]
name: elastic
baseurl=http://10.1.10.19/elastic-6.x/
gpgcheck=0
enabled=1

```

1. Install GrassMarlin from the Nuc


```
sudo yum install grassmarlin X.xX.x.rpm
```



## Notes
 For other versions visit: https://github.com/nsacyber/GRASSMARLIN/releases
