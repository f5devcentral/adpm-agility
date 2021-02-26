provider "volterra" {
 api_p12_file = "/path/to/api_credential.p12"
 url = "https://f5-emea-sp.console.ves.volterra.io/api"
}
 
 
 
resource "volterra_aws_vpc_site" "aws-frankfurt-1" {
 name = "aws-frankfurt-1"
 namespace = "system"
 aws_region = ["eu-central-1"]
 
 
 
 // One of the arguments from this list "aws_cred assisted" must be set
 
 
 
 aws_cred {
 name = "aws-cred"
 namespace = "system"
 tenant = "f5-emea-sp"
 }
 instance_type = ["t3.2xlarge"]
 
 
 
 logs_streaming_disabled = true
 
 
 
 vpc {
 new_vpc {
 name_tag = "Raf-Volterra-SP"
 primary_ipv4 = "10.64.0.0/16"
 allocate_ipv6 = "false"
 }
 }
 
 
 
 ingress_egress_gw {
 az_nodes {
 inside_subnet {
 subnet_param {
 ipv4 = "10.64.1.0/24"
 }
 }
 outside_subnet {
 subnet_param {
 ipv4 = "10.64.0.0/24"
 }
 }
 workload_subnet {
 subnet_param {
 ipv4 = "10.64.2.0/24"
 }
 }
 }
 aws_certified_hw = "aws-byol-multi-nic-voltmesh"
 }
}