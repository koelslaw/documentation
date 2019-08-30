# Intel Nuc
 In version 3 the plan for the NUC is mush more involved. The nuc will be the initial orchestration layer for the whole kit. We will accomplish this with docker. Essentailyl the nuc is the brains fo the outfit and will tell the dell servers what to do.


## What is Docker
Docker is a tool designed to make it easier to create, deploy, and run applications called containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package. Docker allows applications to use the same Linux kernel (in our case RHEL/CENTOS) as the system that they're running on and only requires applications be shipped with things not already running on the host computer.


## What is Docker Swarm
Swarm is a builting cluster management system that will will use to controll all our docker instances on the nuc and both the servers. It allows the following:

- Cluster management integrated with Docker Engine: Use the Docker Engine CLI to create a swarm of Docker Engines where you can deploy application services. You don’t need additional orchestration software to create or manage a swarm.

- Decentralized design: Instead of handling differentiation between node roles at deployment time, the Docker Engine handles any specialization at runtime. You can deploy both kinds of nodes, managers and workers, using the Docker Engine. This means you can build an entire swarm from a single disk image.

- Scaling: For each service, you can declare the number of tasks you want to run. When you scale up or down, the swarm manager automatically adapts by adding or removing tasks to maintain the desired state.

- Multi-host networking: You can specify an overlay network for your services. The swarm manager automatically assigns addresses to the containers on the overlay network when it initializes or updates the application.

- Service discovery: Swarm manager nodes assign each service in the swarm a unique DNS name and load balances running containers. You can query every container running in the swarm through a DNS server embedded in the swarm.

- Load balancing: You can expose the ports for services to an external load balancer. Internally, the swarm lets you specify how to distribute service containers between nodes.

- Secure by default: Each node in the swarm enforces TLS mutual authentication and encryption to secure communications between itself and all other nodes. You have the option to use self-signed root certificates or certificates from a custom root CA.

- Rolling updates: At rollout time you can apply service updates to nodes incrementally. The swarm manager lets you control the delay between service deployment to different sets of nodes. If anything goes wrong, you can roll-back a task to a previous version of the service.



## CENTOS Install
```
 sudo yum remove docker docker-common docker-selinux docker-engine
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce
```

## RHEL Installed
TBD


## Docker Swarm

Open protocols and ports between the hosts
The following ports must be available. On some systems, these ports are open by default.

TCP port 2377 for cluster management communications
TCP and UDP port 7946 for communication among nodes
UDP port 4789 for overlay network traffic

note the ips that will be the nodes for the swarm.

run `docker swarm init --advertise-addr <MANAGER-IP>`
to setup the manager for the swarm. FYI this can also be a node so if you want to share some of the load or run non mission critical systems then it could.

To add a worker to this swarm, run the following command on rock 1 and rock 2 by ssh'ing into them:

    docker swarm join \
    --token <SOME RANDOM TOKEN> \
    <MANGER IP ADDRESS>:2377

At this point docker and the swarm are now setup. Deployment of the VM can now begin.
