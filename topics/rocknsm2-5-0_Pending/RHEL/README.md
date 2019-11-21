# RockNSM 2.5.0 Readme
2.5 Changelog will go here:
 - Bro to Zeek
 - Suricata 5
 - Removal of several Deprecated Python 2 pkgs
 - Removal of GeoIP

## Data Node
- Elasticsearch x3 but can be up to 10 if the ram is available
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
1. [RockNSM Deployment](sensordeploy.md)
1. [Usage](rocknsm-usage.md)
