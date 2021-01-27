terraform {
  backend "consul" {
    address = "54.162.126.20:8500"
    scheme  = "http"
    path    = "adpm/labs/agility/students/1768/terraform/tfstate"
  }
}

data "terraform_remote_state" "state" {
  backend = "consul"
  config = {
    address = "54.162.126.20:8500"
    path = "adpm/labs/agility/students/1768/terraform/tfstate"
  }
}

locals{
    student_id  = "1768"
}