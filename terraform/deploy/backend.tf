terraform {
  backend "consul" {
    address     = "3.95.15.85:8500"
    scheme      = "http"
    path        = "adpm/labs/agility/students/a2eb/terraform/tfstate"
    gzip        = true
  }
}

data "terraform_remote_state" "state" {
  backend = "consul"
  config = {
    address     = "3.95.15.85:8500"
    path = "adpm/labs/agility/students/a2eb/terraform/tfstate"
  }
}

locals{
    student_id  = "a2eb"
}