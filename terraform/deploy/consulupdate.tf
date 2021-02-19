resource "consul_keys" "app" {
  datacenter = "dc1"
  # Set the CNAME of our load balancer as a key
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/bigip/current_count", local.student_id)
    value = var.bigip_count
  }
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/apps/%s/current_count", local.student_id, var.app_name)
    value = var.app_count
  }
  key {
    path  = format("adpm/labs/agility/students/%s/create_timestamp", local.student_id)
    value = local.event_timestamp
  }
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/bigip/last_modified_timestamp", local.student_id)
    value = local.event_timestamp
  }
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/apps/%s/last_modified_timestamp", local.student_id, var.app_name)
    value = local.event_timestamp
  }
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/bigip/is_running", local.student_id)
    value = "false"
  }
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/apps/%s/is_running", local.student_id, var.app_name)
    value = "false"
  }  
}
