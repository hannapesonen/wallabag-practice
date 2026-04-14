terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.0"
    }
    azapi = {
      source = "azure/azapi"
      version = "~> 1.12"
    }
  }
}

provider "azurerm" {
  features {
    
  }
  resource_provider_registrations = "core"

  resource_providers_to_register = [
    "Microsoft.App",
    "Microsoft.KeyVault",
    "Microsoft.DBforPostgreSQL"
  ]
}

provider "azapi" {
  
}