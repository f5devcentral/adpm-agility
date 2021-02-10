#!/bin/bash
sudo touch /opt/bitnami/logstash/pipeline/test.txt
sudo rm -rf /opt/bitnami/logstash/pipeline/logstash.conf
sudo touch /opt/bitnami/logstash/pipeline/logstash.conf
sudo chown --recursive elkuser:elkuser /opt/bitnami/logstash/pipeline/

sudo cat << EOF > /opt/bitnami/logstash/pipeline/logstash.conf
input { 
  http {
    port => 8080    
  }
}

filter {
  json {
    source => "message"
  }

  mutate {
    add_field => { "myMaxCpu" =>" %{MaxCpu}"}      
    add_field => { "myCurCons" =>" %{server_concurrent_conns}"}
  }
  
  mutate {
    convert => { "myMaxCpu" => "integer" }
    convert => { "myCurCons" => "integer" }
  }
}

output {

  elasticsearch { 
    hosts => [""]
    user => "elastic"
    password => ""
    codec => json 
    index => "f5-"
  }
}
EOF

sudo /opt/bitnami/ctlscript.sh stop logstash
sudo /opt/bitnami/ctlscript.sh start logstash




