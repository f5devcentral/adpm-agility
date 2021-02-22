provider azurerm {
  client_id = "{​​{​​ client_id }​​}​​"
  subscription_id = "{​​{​​ subscription_id }​​}​​"
  tenant_id = "{​​{​​ tenant_id }​​}​​"
  client_secret = "{​​{​​ client_secret }​​}​​"
    features {}
}

provider "consul" {
  address = "3.95.15.85:8500"
}