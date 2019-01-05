## Repo Changes

### Update Repository
Once the sensor reboots we need to start the deployment rock. since rock is by
default built on CENTOS vs RHEL and we are accomplishing this in offline vs
online, we want to set the Nuc as the upstream RHEL repository You can copy /
paste this following code block into the Terminal.


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

EOF'

```

Ensure that the local repo has been added:
```
yum repolist all
```
