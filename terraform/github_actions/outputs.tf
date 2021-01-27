data "terraform_remote_state" "foo" {
  backend = "consul"
  config = {
    address = "54.162.126.20:8500"
    path = "adpm/labs/agility/students/7fb4/terraform/tfstate"
  }
}

output "version" {
  value = data.terraform_remote_state.foo
}

# output "vpc" {
#   value = "${data.terraform_remote_state.foo.outputs.vpc_id}"
# }

# output "web_count" {
#   value = "${data.terraform_remote_state.foo.outputs.web_server_count}"
# }