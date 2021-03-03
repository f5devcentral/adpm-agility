resource "consul_keys" "app" {
  datacenter = "dc1"
  # Set the CNAME of our load balancer as a key
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/bigip/current_count", local.student_id)
    value = local.bigip_count
  }
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/apps/%s/current_count", local.student_id, var.app_name)
    value = local.app_count
  }
}
