provider "consul" {
  address = "54.162.126.20:8500"
}
resource "consul_keys" "app" {
  datacenter = "dc1"
  key {
    path  = format("adpm/labs/agility/students/%s/scaling/bigip/current_count", local.student_id)
    value = local.instance_count
  }
}
