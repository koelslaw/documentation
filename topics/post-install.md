# Function Check of Rock Sensor
1. Connect the gigamon to the assign port for ingest of traffic.
1. Ping `dns.[state].cmat.lan`
1. Log into the `sensor.[state].cmat.lan` and run a `rock_status` ensure that all the installed portions of the sensor return no errors
1. Make sure there are logs in `/data/bro/current/`
1. Run `/opt/kafka/bin/kafka-console-consumer.sh --from-beginning --topic bro-raw --bootstrap-server 10.[state].cmat.lan:9092` and ensure kafka is creating topics and moving them about
1. log into `es1.[state].cmat.lan` and run a `rock_status` ensure that all the installed portions of the elastic cluster return no errors
1.  Navigate to Kibana `http://kibana.[state].cmat.lan` and ensure it loads and you see traffic from from Bro and Suricata
1. Go forth and find bad.

Move to [Platform Management](platform-management.md)
