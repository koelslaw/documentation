# Function Check of Rock Sensor
1. ***CHECK YOUR CABLES*** Seems stupid but it happes all the time
1. **IF** allowed connect a computer to the network/tap to ensure you have traffic flowing
> NOTE: only do this at home station or exercise ***DO NOT DO ON MISSION***
1. Run `tcpdump -iv NAMEOFINTERFACE` on the capture interface to ensure traffic is flowing
1. Ping `dns.[state].cmat.lan`
1. Log into the `sensor.[state].cmat.lan` and run a `sudo systemctl status SOMESERVICE` ensure that all the installed portions of the sensor return no errors. Also ensure that there are no errors in the files in  `/var/log/` ,  `tailf` is really handy for this
  - Stenographer
  - kafka
  - FSF
  - BRO (use broctl instead)
  - Suricata
1. Make sure there are logs in `/data/bro/current/`
1. Run `/opt/kafka/bin/kafka-console-consumer.sh --from-beginning --topic bro-raw --bootstrap-server 10.[state].cmat.lan:9092` and ensure kafka is creating topics
1. log into `es1.[state].cmat.lan` and run a `sudo systemctl status SOMESERVICE` ensure that all the installed portions of the sensor return no errors. Also ensure that there are no errors in the files in  `/var/log/` ,  `tailf` is really handy for this
  - Logstash
  - Elasticsearch
  - Kibana
  - docket
> NOTE: Logstash can be a bit of a pain to work with. The error reporting to in `systemctl` and `/var/log` is usually only helpful for basic stuff. The command `/usr/share/logstash/bin/logstash -t -f /etc/logstash/conf.d/$confFiles` is used to ensure there are no error with the logstash config file. It will test the file to give u exact error line number, because even though it says line 392 it really could be before that or even after that line or in the file before the one described in an error
1.  Navigate to Kibana `http://kibana.[state].cmat.lan` and ensure it loads and you see traffic from from Bro and Suricata
1. Go forth and find Evil.
