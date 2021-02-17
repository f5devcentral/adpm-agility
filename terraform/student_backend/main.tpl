terraform {
  backend "consul" {
    address     = "3.95.15.85:8500"
    scheme      = "http"
    path        = "adpm/labs/agility/students/${student_id}/terraform/tfstate"
    gzip        = true
  }
}
