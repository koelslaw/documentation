# Local Repo Setup


##### Prereq:

1. Nuc Configuration script completed
2. reposync/create repo completed on nuc


#### Instructions
Now on your CentOS/RHEL client machines, add your local repos to the YUM configuration.
```
vim /etc/yum.repos.d/local-repos.repo
```
Copy and paste the configuration below in the file local-repos.repo (make changes where necessary).
```
[local-epel/x86_64]
name=Extra Packages For Enterprise Linux Local Repo
baseurl=http://nuc.simplerock.lan/epel/
gpgcheck=0
enabled=1

[local-group_rocknsm-rocknsm-2.1./x68_64]
name=Rock NSM Repo
baseurl=http://nuc.simplerock.lan/rocknsm/
gpgcheck=0
enabled=1

[local-rhel-7-server-rpms/7Server/x68_64]
name=
baseurl=http://nuc.simplerock.lan/rhel-7-server-rpms/
gpgcheck=0
enabled=1
```
Save the file and start using your local YUM mirrors.


Next, run the following command to view your local repos in the list of available YUM repos, on the client machines. The repos you have added should be part of that list
```
#  yum repolist
```
OR
```
# yum repolist all

```
