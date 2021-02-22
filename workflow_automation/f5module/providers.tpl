terraform {
  required_version = "~> 0.13"
  required_providers {
       azurerm = {
        source = "hashicorp/azurerm"
        version = "~>2.28.0"
         }   
       }
       random = {
         source = "hashicorp/random"
         version = "~>2.3.0"
       }
       template = {
         source = "hashicorp/template"
         version = "~>2.1.2"
       }
       null = {
         source = "hashicorp/null"
         version = "~>2.1.2"
      }
 } 
}
