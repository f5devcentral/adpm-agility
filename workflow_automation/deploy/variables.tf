variable bigip_count {
  description = "Number of Bigip instances to create( From terraform 0.13, module supports count feature to spin mutliple instances )"
  type        = number
  default     = 1
}

variable app_count {
  description = "Number of backend application instances to create( From terraform 0.13, module supports count feature to spin mutliple instances )"
  type        = number
  default     = 2
}

variable app_name {
  type    = string
  default = "app1"
}

variable prefix {
  description = "Prefix for resources created by this module"
  type        = string
  default     = "student"
}

variable location {default = "East US"}

variable cidr {
  description = "Azure VPC CIDR"
  type        = string
  default     = "10.2.0.0/16"
}

variable upassword {default = "F5Student!"}

variable availabilityZones {
  description = "If you want the VM placed in an Azure Availability Zone, and the Azure region you are deploying to supports it, specify the numbers of the existing Availability Zone you want to use."
  type        = list
  default     = [2]
}
variable AllowedIPs {}

# TAGS
variable "purpose" { default = "public" }
variable "environment" { default = "f5env" } #ex. dev/staging/prod
variable "owner" { default = "f5owner" }
variable "group" { default = "f5group" }
variable "costcenter" { default = "f5costcenter" }
variable "application" { default = "f5app" }
