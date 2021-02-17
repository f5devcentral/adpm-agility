#!/bin/bash

# Disable stdout
exec 2>/dev/null

install_nginx () {
  
  sudo apt update && sudo apt-get install -y openjdk-8-jdk && sudo apt-get install -y nginx 
}

install_elastic () {
  
  #install and start Elasticsearch
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - && echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list && sudo apt update && sudo apt install -y elasticsearch &&  sudo systemctl start elasticsearch && sudo systemctl enable elasticsearch 
}

install_kibana () {
  
  # Install and Start Kibana
  sudo chown --recursive elkuser:elkuser /etc/nginx/*
  sudo apt install -y kibana && sudo systemctl enable kibana && sudo systemctl start kibana && sudo rm -rf /etc/nginx/sites-enabled/*
  sudo cat << EOF > /etc/nginx/sites-available/example.com 
  server {
    listen 80;

    server_name example.com;

    location / {
        proxy_pass http://localhost:5601;
    } 
  }
EOF
  
  sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com && sudo systemctl restart nginx 
}

install_logstash() {
  # Install and Start Logstash
  sudo apt install -y logstash 
  sudo cat << EOF > /etc/logstash/conf.d/f5logstash.conf
  input {
    http
    {
    ssl => false
    host => "0.0.0.0"
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
    elasticsearch
    {
      hosts => ["127.0.0.1:9200"]
      document_id => "%{logstash_checksum}"
      index => "f5-%{+YYYY.MM.dd.hh.mm}"
    }
  }
EOF

  sudo systemctl stop logstash && sudo rm -rf /etc/logstash/conf.d/logstash.conf && sudo systemctl start logstash && sudo systemctl enable logstash
}

install_nginx
install_elastic
install_kibana
install_logstash


