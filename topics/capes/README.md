# Documentation

Please see below for Build, Operate, Maintain specifics on the different web applications
* [Post Installation](https://nuc.[state].cmat.lan:4000/capes/capes/tree/master/docs#post-installation)
* [CAPES Landing Page](../landing_page/build_operate_maintain.md)  
* [CyberChef](../cyberchef/build_operate_maintain.md)
* [Gitea](../gitea/build_operate_maintain.md)  
* [HackMD](../hackmd/build_operate_maintain.md)  
* [Mattermost](../mattermost/build_operate_maintain.md)  
* [TheHive](../thehive/build_operate_maintain.md)  
* [Cortex](../thehive/build_operate_maintain.md)  
* [Mumble](../mumble/build_operate_maintain.md)  
* [Kibana](../kibana/build_operate_maintain.md)
* [Beats (Elastic's Heartbeat & Metricbeat)](../beats/build_operate_maintain.md)

## Requirements

| Component | Number |
| - | - |
| Cores | 4 |
| RAM | 6 GB |
| Hard Disk | 20 GB |

## Secure by Design

### Secure Deployment
There is an inherent risk to deploying web applications to the Internet or to a contested networking enclave -- basically, somewhere the bad guys can get to.

To address this, the CAPES project has done a few things to help protect these web applications and left a few things for you, the operator, to close in on as your need requires.

### Operating System
While there are a lot of projects that are developed using Ubuntu (many of these service creators still follow that path), CAPES chose to use CentOS because of a few different reasons:  
1. CentOS is the open source version of Red Hat Enterprise Linux (RHEL)
    - Many enterprises use RHEL as their Linux distribution of choice because you can purchase support for it
    - We wanted to use a distribution that could easily be ported from an open source OS to the supported OS (RHEL)
1. CentOS uses Security Enhanced Linux (SELinux) instead of AppArmor
    - SELinux uses context to define security controls (for example, I know a text editor shouldn't talk to the Internet because it's a text editor, not a browser)
    - AppArmor uses prescripted rules to define security controls (for example, I know that a text editor shouldn't talk to the Internet because someone **told** me it shouldn't)

### Implementation
While the `firewalld` service is running on CAPES and the only ports listening have services attached to them, you should still consider using a Web Application Firewall (WAF), an Intrusion Detection System (IDS) or a Network Security Monitor (like [ROCKNSM](rocknsm.io) - which has an IDS integrated on top of a litany of other goodies) to ensure that your CAPES stack isn't being targeted.

If possible, CAPES, just like a passive NSM, should **not** be on the contested network. This will prevent it from being targeted by aggressors.

### SSL
It is a poor practice to deploy self-signed SSL certificates because it teaches bad behavior by "clicking through" SSL warnings; for that reason, we have decided not to deploy CAPES with SSL. [If you want to enable SSL for your own deployment](https://nginx.org/en/docs/http/configuring_https_servers.html), we encourage you to do so.

## Installation
Generally, the CAPES ecosystem is meant to run as a whole, so the preferred usage will be to install CAPES with the `deploy_capes.sh` script in the root directory of this repository. Additionally, if there is a service that you do not want, you can comment that service out of the deploy script as they are documented with service banners.

That said, there is a deploy script for each of the services that you should be able to run individually if your use case requires that.

### Build your OS
1. Fire up the CAPES VM you built on ESXi and boot into Anaconda (the Linux install wizard)
1. Select your language
1. Start at the bottom-left, `Network & Host Name`
    - There is the `Host Name` box at the bottom of the window, enter the CAPES hostname from the [../platform-management.md](Platform Management) page
    - Switch the toggle to enable NIC
      - Click `Configure` for your first NIC
      - Go to `IPv4 Settings`
        - Change the `Method` to `Manual`
        - Click `Add`
          - Update your IP address, network, and gateway from the [../platform-management.md](Platform Management) page
      - Go to `IPv6 Settings` and change from `Automatic` to `Ignore`
      - Click `Save`
    - Click `Done` in the top left
1. Next the `Security Profile` in the lower right
    - Select `DISA STIG`
    - Click `Select Profile`
    - Click `Done`
1. Next click `Installation Destination`
    - Select the hard disk you want to install CentOS to, likely it is already selected unless you have more than 1 drive
    - Click `Done`
1. Click `kdump`
    - Uncheck `Enable kdump`
    - Click `Done`
1. `Installation Source` should say `Local media` and `Software Selection` should say `Minimal install` - no need to change this
1. Click `Date & Time`
    - `Region` should be changed to `Etc`
    - `City` should be changed to `Coordinated Universal Time`
    - `Network Time` should be toggled on
    - Click `Done`
    - Note - the beginning of these install scripts configures Network Time Protocol (NTP). You just did that, but it's included just to be safe because time, and DNS, matter.
    1. Click `Begin Installation`
    1. We're not going to set a Root passphrase because you will never, ever need it. Ever. Not setting a passphrase locks the Root account.
    1. Create a user from the [../platform-management.md](Platform Management) page, but ensure that you toggle the `Make this user administrator` checkbox
    ![](../../images/admin-user.jpg)
    1. Once the installation is done, click the `Reboot` button in the bottom right to...well...reboot
    1. Login using the account you created during the Anaconda setup

## Repo Changes

### Update Repository
Once CAPES reboots we need to set the Nuc as the upstream RHEL repository You can copy / paste this following code block into the Terminal (once you update the `.[state octet].` with your [octet](../README.md)).

```
sudo bash -c 'cat > /etc/yum.repos.d/local-repos.repo <<EOF
[capes]
name: Capes Local
baseurl=http://10.[state octet].10.19/capes/
gpgcheck=0
enabled=1

[local-epel]
name: Extra packages For Enterprise Linux Local Repo
baseurl=http://10.[state octet].10.19/epel/
gpgcheck=0
enabled=1

[local-rhel-7-server-extras-rpmsx86_64]
name: local rhel 7 server extras
baseurl=http://10.[state octet].10.19/rhel-7-server-extras-rpms/
gpgcheck=0
enabled=1

[local-rhel-7-server-optional-rpmsx86_64]
name: local rhel 7 server optional
baseurl=http://10.[state octet].10.19/rhel-7-server-optional-rpms/
gpgcheck=0
enabled=1

[local-rhel-7-server-rpmsx86_64]
name: local rhel 7 server rpms
baseurl=http://10.[state octet].10.19/rhel-7-server-rpms/
gpgcheck=0
enabled=1

[local-wandiscox86_64]
name: wandisco
baseurl=http://10.[state octet].10.19/WANdisco-git/
gpgcheck=0
enabled=1

EOF'
```
## Get CAPES
Finally, here we go.

### CentOS 7.4
```
sudo yum install git -y
git clone https://nuc.[state].cmat.lan:4000/capes/capes.git
cd capes
sudo sh deploy_capes.sh
```

### Build Process
The build is automated minus asking you to set the Gitea, CAPES, and Mumble administrative passphrases, set the MariaDB root passphrase, and confirm some security settings for MariaDB.

You'll be asked to create the first three passphrases at the beginning and to create the MariaDB passphrase at the end of the CAPES installation.

This will start the automated build of:
* Configure NTP (likely already done, but in the event you skipped the [Build your OS](#build-your-os) above)
* Install Mattermost
* Install Gitea
* Install TheHive
* Install HackMD
* Install Cortex
* Install Mumble
* Install CyberChef
* Install Nginx
* Install Kibana (with Elastic's Heartbeat and Metricbeat)
* Install the CAPES landing page
* Secure the MySQL installation
* Make firewall changes
* Set everything to autostart

## Post Installation
While the CAPES deploy script attempts to get you up and running, there are a few things that need to be done after installation.

### Beats
1. Set your MariaDB root passphrase (which you set at the very end of the deployment) in `/etc/metricbeat/metricbeat.yml`, replacing `passphrase_to_be_set_post_install` and then `sudo systemctl restart metricbeat.service`.  
1. Check Filebeat and make sure it's running. If Elasticsearch doesn't start fast enough, Filebeat will fail when trying to connect to it or if you don't accept the EULA during the install script, it will fail. You can try to simply restart it with `sudo systemctl restart filebeat.service`. If Filebeat won't start (`sudo systemctl status filebeat.service`) try to run `sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-geoip` and accept the EULA. If all else fails, you can look at the log file to see what the reason is (`sudo cat /var/log/filebeat/capes_filebeat`).

### Gitea
1. When you browse to your Gitea instance, you'll need to set your database passphrase, your SSH Server Domain, your base URL, and disable Gravatar.
1. Set the Gitea passphrase you created during installation and enter it in the `Password` field on the Gitea UI. Leave the `Username` and `Database Name`.
1. For the `SSH Server Domain`, use your IP address
1. For the `Gitea Base URL`, enter `http://<your_IP_address>:4000/`
1. Go to `Server and Third-Party Service Settings` and check the `Disable Gravatar` box
1. Click to setup Gitea
1. After you're taken to the login page, click on `Need an account? Register now.`
1. This will be an administrative account, pick a username, email address, and passphrase (note, you cannot use `admin`)
1. Click `Register Account`
1. Login in as the user you just created

### Kibana
1. Select `heartbeat-*` or `metricbeat-*` and set that as Default by clicking on the `star` in the top right of the screen.

### HackMD
1. Click on `Sign In`
1. Select an email address (it doesn't need to be valid) and a passphrase and click the `Register` button
1. Login as that user

### Mattermost
1. Enter an email address, username, and a passphrase
1. Click on `Create a new team` and create a team
1. Click on the `System Console` banner at the top and enter your `Site URL`. It will be `http://<CAPES-IP>:5000`, go to the bottom of the page and click `Save`.
1. There are 2 ways to get users added to your Team
  - Exit the System Console and go back to your Team page, at the bottom of the `Town Square` channel, there is a link `Invite others to this team`, give that to your team and they'll be added once they create accounts. **I think that this is the most convenient way to do it.**
  - Click on `Sign-Up` under `Security` and change `Enable Open Server` to `True`, have them create accounts, and manually move them into your Team
    - Have new users browse to `http://<CAPES-IP>:5000`, create accounts, but no new teams
    - From the admin, log out of the system console and into your team
    - Click the settings dropdown in the top left and select `Add Members to Team` and add the new members

### Cortex (Pending Use)
1. Log into Cortex and create a new Organization and an Organization Administrator, set that user's passphrase
1. Log out and back into Cortex as the new Organization Administrator that you created, click on "Organization" and then click on "Users"
1. Create a user called `TheHiveIntegration` (or the like) with the `read,analyze` roles, create an API key, copy that down
1. Click on the Organization tab and enable the Analyzers that you want to enable
1. Enter your Analyzer specific information (generally an API key or the like)

### TheHive
1. Open `/etc/thehive/application.conf` and go to the very bottom of the document and add `key = <your-api-key>` to the `CORTEX-SERVER-ID` section (`your-IP-address` should already be populated). The API key is the one you created above in Cortex.
```
cortex {
  "CORTEX-SERVER-ID" {
  url = "http://<your-IP-address>:9001"
  key = "<your-API-key>"
  }
}
```
1. Restart The Hive with `sudo systemctl restart thehive.service`
1. Browse to TheHive via the Landing Page (http://CAPES_IP) or (http://CAPES_IP:9000)
1. Click "Update Database" and create an administrative account

### Mumble
1. Download the client of your choosing from the [Mumble client page](https://www.mumble.com/mumble-download.php)
1. Install
1. There will be considerable menus to navigate, just accept the defaults unless you have a reason not to and need a custom deployment.
1. Start it up and connect to
  - Label: Whatever you want your channel to be called...maybe "CAPES" or something?
  - Address: CAPES server IP address
  - Port: 7000
  - Username: whatever you want
  - Password: this CAN be blank...but it shouldn't be **ahem**
  - Click "OK"
  - Select the channel you just created and click "Connect"
1. Right click on your name and select "Register". Once a user has created an account and Registered, you can add them to the `admin` role.
1. Click on the Globe and select the channel that you created and click "Edit"
1. For the username, use the `SuperUser` account with the passphrase you set during installation (the passphrase box will show up once you type `SuperUser`).
1. Right-click on main channel (likely "CAPES - Mumble Server") and select `Edit`
1. Go to the Groups tab
1. Select the `admin` role from the drop down
1. Type the user account you want to delegate admin functions to in the box
1. Click `Add` and then `Ok`
1. Click on the Globe and select the channel that you created and click "Edit"
1. Enter your username (not `SuperUser`) and your passphrase, and you can log in and perform administrative functions

## Get Started
After the CAPES installation, you should be able to browse to `http://capes_system` (or `http://capes_IP` if you don't have DNS set up) to get to the CAPES landing page and start setting up services.
