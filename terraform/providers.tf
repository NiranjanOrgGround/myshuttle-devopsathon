terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.82.0"
    }
  }
    backend "azurerm" {
    resource_group_name      = "mystorage-account"
    storage_account_name     = "terraform1997"
    container_name           = "terraformstate"
    key                      = "terraform.tfstate"
  }
}

provider "azurerm" {
  # subscription_id = "b2bb726b-8781-4706-b78e-953ca038b27b"
  # client_id       = "0219bb23-9257-4678-befd-9d7245eb8c68"
  # client_secret   = "Diw8Q~Wwq3zOUSz3o5PsDjZ2rao1ZHKvKKLtHb5L" #9f720917-7be4-4f2c-a558-dc4b7ea3f543
  # tenant_id       = "390be231-c5e2-4e2c-a316-3c9fdd6710cd"
  features {}
}
