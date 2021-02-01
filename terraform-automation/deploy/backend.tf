terraform {
  backend "consul" {
    address = "54.162.126.20:8500"
    scheme  = "http"
    path    = "adpm/labs/agility/students/b6be/terraform/tfstate"
  }
}

data "terraform_remote_state" "state" {
  backend = "consul"
  config = {
    address = "54.162.126.20:8500"
    path = "adpm/labs/agility/students/b6be/terraform/tfstate"
  }
}

locals{
    student_id  = "b6be"
    instance_count = 1
}