terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "tfstatestorage"
    storage_account_name  = "tfstatefileagnish"
    container_name        = "tfstatefile"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}