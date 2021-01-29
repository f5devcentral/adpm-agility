output bigip_username {
  value = module.bigip.*.f5_username
}

output bigip_password {
  value = module.bigip.*.bigip_password
}

output mgmtPublicIP {
  value = module.bigip.*.mgmtPublicIP
}

output mgmtPort {
  value = module.bigip.*.mgmtPort
}

output hostname {
  value = local.hostname
}
