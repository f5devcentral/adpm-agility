#!/bin/bash

function vipToConsul () {
  mycommand=$(az network nic ip-config show  -g student-c19b-fa09-rg  -n ipconfig2 --nic-name c19b-0299-ext-nic-public-0  | jq '.privateIpAddress')
  consul kv put -http-addr=40.85.189.224:8500 vip $mycommand

}

vipToConsul
