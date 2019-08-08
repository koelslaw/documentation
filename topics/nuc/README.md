# Intel Nuc Configuration

The intel Nuc is an important part of the kits initial setup and maintx. It is used as your:
- RPM repo
- Documentation Repo
- Generally to build/rebuild and maintain the kit

## Prereqs

- [RHEL](../rhel/README.md) Installed
> Note: if necessary, these steps can be replicated to work with [CentOS Minimal](http://mirror.mobap.edu/centos/7.5.1804/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso).

- Network connection to Internet

## Deploy Initial Configuration
We are going to deploy the initial configuration for the Nuc. This will configure the nuc as a repository to build the rest of the kit, as well as to store documentation.  

- Before that we need some upstream packages for installation. To get those we need to grab the our RHEL subscription.

  ```
  sudo subscription-manager register --username [see Platform Management] --password [see Platform Management] --auto-attach
  ```

  Congrats! You have access to the RHEL RPM Repos. By extension so does the rest of the stack.

- The next script is meant to take some of the work on setting up the nuc. Using the script also ensures the rest of the kit has what it needs to function.

 There are 2 versions of this deployment. Unless something specific is needed then I recommend using version 2. Which is known as "AYR" (Alternate Yum Repository).
 - [Version 1](..topics/nuc/v1/README.md) (Soon to be deprecated, cause openvas)
 - [Version 2](..topics/nuc/v2/ayr/README.md)
  - Openvas needs to be configured prior to start due to the project agnostic nature of AYR. To prep the nuc to host the Repos use:
  - elevate to root using `sudo -s`

  ```
  yum -y install wget net-tools
  ```
  then
  ```
  wget -q -O - https://updates.atomicorp.com/installers/atomic | sh
  ``` 

- Clone the mozarkite github repo. If you cannot access check with d2ie to ensure you have authorization to be on di2e. Also check with technical SME to ensure you have access to the git repo also. If you don't have git already installed use `sudo yum install git`.

  ```
  sudo git clone https://di2euserfirstname.lastname@bitbucket.di2e.net/scm/mozarkite/mozarkite-docs.git
  ```
## Download Iso images
While you dont have to have these it will make it easier if you need them in the future. `curl` or `scp` onto the nuc into the `var/www/html/iso` directory
 - RHEL - DVD iso (Should have this one already downloaded from Nuc installation)
 - ESXi ISO

Move onto [Gigamon Configuration](../gigamon/README.md)
