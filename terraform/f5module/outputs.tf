output mgmtPublicIP {
  description = "The actual ip address allocated for the resource."
  value       = data.azurerm_public_ip.f5vm01mgmtpip.ip_address
}

output mgmtPublicDNS {
  description = "fqdn to connect to the first vm provisioned."
  value       = data.azurerm_public_ip.f5vm01mgmtpip.fqdn
}


output mgmtPort {
  description = "Mgmt Port"
  value       = local.total_nics > 1 ? "443" : "8443"
}

output f5_username {
  value = var.f5_username
}

output bigip_password {
  value       = local.upass 
}

output onboard_do {
   value      = data.template_file.clustermemberDO2[0].rendered 
  depends_on = [data.template_file.clustermemberDO2[0]]

}

output "public_addresses" {
  description = "List of BIG-IP public addresses"
  value   = concat(azurerm_public_ip.secondary_external_public_ip.*.ip_address)
}

output "external_nics" {
  description = "List of BIG-IP external nics"
  value   = concat(azurerm_network_interface.external_nic.*.id)
}

output "private_addresses" {
  description = "List of BIG-IP private addresses"
  value   = concat(azurerm_network_interface.external_nic.*.private_ip_addresses, azurerm_network_interface.external_public_nic.*.private_ip_addresses, azurerm_network_interface.internal_nic.*.private_ip_address)
}

output mgmt_nic {
  value = azurerm_network_interface.mgmt_nic.*.id
}

output vips {
  value = element(azurerm_network_interface.external_public_nic.*.private_ip_addresses,1)
}

