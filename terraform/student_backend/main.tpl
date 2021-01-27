terraform {
  backend "consul" {
    address = "http://54.162.126.20:8500"
    scheme  = "http"
    path    = "adpm/labs/agility/students/${student_id}/terraform/tfstate"
  }
}
