terraform {
  backend "consul" {
    address = "54.162.126.20:8500"
    scheme  = "http"
    path    = "adpm/labs/agility/students/{{ student_nbr }}/terraform/tfstate"
  }
}

provider "azurerm" {
  client_id = "{{ client_id }}"
  subscription_id = "{{ subscription_id }}"
  tenant_id = "{{ tenant_id }}"
  client_secret = "{{ client_secret }}"
}


data "terraform_remote_state" "foo" {
  backend = "consul"
  config = {
    address = "54.162.126.20:8500"
    path = "adpm/labs/agility/students/{{ student_nbr }}/terraform/tfstate"
  }
}

output "version" {
  value = data.terraform_remote_state.foo
}

output "test" {
  value = "TESTING"
}

# output "vpc" {
#   value = "${data.terraform_remote_state.foo.outputs.vpc_id}"
# }

# output "web_count" {
#   value = "${data.terraform_remote_state.foo.outputs.web_server_count}"
# }