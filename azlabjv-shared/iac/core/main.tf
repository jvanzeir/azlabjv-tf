terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.90.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
  }
  #backend "azurerm" {} # backend with storage account (backend.hcl)
  backend "remote" {} # backend with TF Cloud
  required_version = ">= 1.0"
}

provider "azurerm" {
  subscription_id = var.provider_subscription_id
  tenant_id       = var.provider_tenant_id
  client_id       = var.provider_client_id
  client_secret   = var.provider_client_secret
  features {}
}

resource "null_resource" "update" {
  triggers = {
    tfversion = "1.0"
  }
}