output bigip_username {
  value = module.bigip.*.f5_username
}

output bigip_password {
  value = module.bigip.*.bigip_password
}

output "management_public_ip" {
  value = module.bigip.*.mgmtPublicIP
}

output "application_address" {
  description = "Public endpoint for load balancing external app"
  value       = azurerm_public_ip.alb_public_ip.ip_address
}

output "consul_public_ip" {
   value = "http://${azurerm_public_ip.mgmt_public_ip.ip_address}:8500"
 }

output "elk_public_ip" {
   value = "http://${azurerm_public_ip.elk_public_ip.ip_address}"
 }

 output student_id {
   value = local.student_id
 }
