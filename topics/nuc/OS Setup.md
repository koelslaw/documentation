# OS Setup (NUC)


##### Prereq:

1. RHEL installed

#### Instructions
Install EPEL
```
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

Add the ROCK Repo to get the correct version of packages
```
sudo yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/g/rocknsm/rocknsm-2.1/repo/epel-7/group_rocknsm-rocknsm-2.1-epel-7.repo
```

Install Ansible.

```
sudo yum install ansible
```

Install Git so we can clone the CMAT repo and CAPES repo

```
sudo yum install git
```

Clone the REPOs
```
sudo git clone https://github.com/koelslaw/mozarkite.git
```

Once cloned then run the deploy script
```
sudo sh mozarkite/playbooks/NUC/deploy-nuc.sh
```

Download the following files and place them in the user directory
 - VShpere iso
 - Rhel 7 iso
 - rhel-7-server-rpms
 - epel rpms
