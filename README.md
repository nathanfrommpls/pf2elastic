# pf2elastic
This is an preliminary and rudimentary attempting at shipping logs from pf on an openbsd firewall to elasticsearch for analysis and visualization. I don't expect this to scale well initially.

On the firewall side will be script to convert pf binary logs to plaintext and then copy them to the host where your filebeat is ingesting logs.

On the elasticstack side I have a logstash pipeline to parse the filebeat input. Note that there are many other components and their configs, e.g. elasticsearch, filebeat, kibana, that I have not included in the repo. At the time of writing these configs I am working with are extremely "canned".

## TODO

1. Type matching of values, e.g. ensure elasticsearch recognizes an IP as an IP
1. Ensure timestamp comes from PF log and not logstash
