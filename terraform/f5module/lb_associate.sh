#!/bin/bash

associateIP () {

     az network nic ip-config address-pool add \
     --address-pool f5BackendPool \
     --ip-config-name ${ip_config} \
     --nic-name ${nic_name} \
     --resource-group ${rg_name} \
     --lb-name ${lb_name}
}

vipToConsul () {
  mycommand=$(az network nic ip-config show  -g ${rg_name} -n ${ip_config} --nic-name ${nic_name}  | jq '.privateIpAddress')
  consul kv put -http-addr=3.95.15.85:8500 adpm/labs/agility/students/${student_id}/scaling/apps/${app_name}/vip $mycommand

}

associateIP
#vipToConsul
