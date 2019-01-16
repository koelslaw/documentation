# RockNSM Readme
RockNSM has 2 components, the data node (top half or Server 2) and the sensor (bottom half or Server 1).

## Data Node
The data node has the indexing/storage and visualization elements:
- Elastic Elasticsearch
- Elastic Kibana (w/ RockNSM's Docket)

## Sensor
The sensor has the network security monitoring and data shipping elements:
- Bro protocol analyzer
- Suricata IDS
- Emerson fsf
- Google Stenographer
- Apache Kafka
- Elastic Logstash
- Elastic Beats

## Build Steps
1. [Hardware Requirements](rocknsm-requirements.md)
1. [RockNSM Sensor](rocknsm-sensor.md)
1. [RockNSM Data Node](rocknsm-datanode.md)
1. [Connecting the Sensor to the Data Node](rocknsm-configuration.md)
1. [Usage](rocknsm-usage.md)

Start with [Hardware Requirements](rocknsm-requirements.md).
