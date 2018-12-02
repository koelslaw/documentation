# GRASSMARLIN Install
GRASSMARLIN provides IP network situational awareness of industrial control systems (ICS) and Supervisory Control and Data Acquisition (SCADA) networks to support network security. Passively map, and visually display, an ICS/SCADA network topology while safely conducting device discovery, accounting, and reporting on these critical cyber-physical systems.

## Documentation
GrassMarlin v3.2 User Guide:  
- [Download PDF](topics/grassmarlin/GRASSMARLIN User Guide.pdf)   
- [Presentation on GRASSMARLIN](topics/grassmarlin/GRASSMARLIN_Briefing_20170210.pptx)  

## Install Instructions
### Update Repository
We want to set the Nuc as the upstream repository, you can copy / paste this following code block into the Terminal.
```
sudo bash -c 'cat > /etc/yum.repos.d/local-repos.repo <<EOF
[local-epel/x86_64]
name=Extra Packages For Enterprise Linux Local Repo
baseurl=http://nuc.mo.cmat.lan/epel/
gpgcheck=0
enabled=1

[local-grassmarlin/x68_64]
name=GRASSMARLIN Repo
baseurl=http://nuc.mo.cmat.lan/grassmarlin/
gpgcheck=0
enabled=1

[local-rhel-7-server-rpms/7Server/x68_64]
name=
baseurl=http://nuc.mo.cmat.lan/rhel-7-server-rpms/
gpgcheck=0
enabled=1
EOF'
yum repolist all
sudo yum install grassmarlin-3.2.1-1.el6.x86_64.rpm -y
```

## Notes
 For other versions visit: https://github.com/nsacyber/GRASSMARLIN/releases
