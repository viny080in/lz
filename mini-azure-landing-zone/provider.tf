
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 4.35"
    }
  }
}

provider "azurerm" {
  features {}

  metadata_host = "127.0.0.1:4567"

  resource_provider_registrations = "none"

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}
