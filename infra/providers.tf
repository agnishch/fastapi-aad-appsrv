provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name   = "tfstatestorage"
    storage_account_name  = "tfstatefileagnish"
    container_name        = "tfstatefile"
    key                   = "terraform.tfstate"
  }
}