# RockNSM

## Rock Versions
1. [Rock NSM 2.2.x](../topics/rocknsm/rocknsm2-2-0/README.md)
1. [Rock NSM 2.3.x](../topics/rocknsm/rocknsm2-3-0/README.md)
1. Rock NSM 2.4.x
  - [Rock NSM 2.4.x (CENTOS)](../topics/rocknsm/rocknsm2-4-0/CENTOS/README.md)
  - [Rock NSM 2.4.x (RHEL)](../topics/rocknsm/rocknsm2-4-0/RHEL/README.md)

RockNSM CMAT Kit has 2 Servers, the data node (top half or Server 2) and the sensor (bottom half or Server 1). However we don't have to limit ourselves to just those 2 servers. Starting in 2.3.0 there is better support for multi node deployments. These allow use to deploy them faster and hopefully with fewer mistakes. If more hardware is available then we will just deploy the playbook from the nuc and let the other servers know of its existence and then it can start working.

#### Data Node
The data node has the indexing/storage and visualization elements:
- Elasticsearch x3 but can be up to 10 if the ram is available
- Elastic Kibana (w/ RockNSM's Docket)

#### Sensor
The sensor has the network security monitoring and data shipping elements:
- Bro protocol analyzer
- Suricata IDS
- Emerson fsf
- Google Stenographer
- Apache Kafka
- Elastic Logstash
- Elastic Beats
