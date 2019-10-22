# RockNSM

## Rock Versions
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

RockNSM CMAT Kit has 2 Servers, the data node (top half or Server 2) and the sensor (bottom half or Server 1). However we don't have to limit ourselves to just those 2 servers. Starting in 2.3.0 there is better support for multi node deployments. These allow use to deploy them faster and hopefully with fewer mistakes. To keep everything as close to the sensor as required we will execute the deployment from the sensor. That way the new `rock start` and `rock stop` scripts can do their job.

#### Data Node
The data node has the indexing/storage and visualization elements:
- Elasticsearch x3 but can be up to 10 if the ram is available
  - if there is more RAM available the you can setup elastic node setup as 3 master and 1 kibana only node and then the rest are data and ingest nodes.
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
