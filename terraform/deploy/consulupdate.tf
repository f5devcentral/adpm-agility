provider "consul" {
  address = "54.162.126.20:8500"
}
resource "consul_keys" "app" {
  datacenter = "dc1"
  # Set the CNAME of our load balancer as a key
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/bigip/current_count", local.student_id)
    value = var.instance_count
  }
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/bigip/student_id", local.student_id)
    value = local.student_id
  }
}
