resource "azurerm_resource_group" "example_rg" {
  name     = var.rg_name
  location = var.location

  tags = {
    environment = "dev"
    project     = "fastapi-aad-appsvc"
    owner       = "Agnish Choudhury"
  }
}

resource "azurerm_container_registry" "example_acr" {
  name                     = "agnishacr" # Replace with your desired ACR name
  resource_group_name      = var.rg_name
  location                 = var.location
  sku                      = "Basic" # Replace with the desired SKU (e.g., "Basic", "Standard", "Premium")
  depends_on               = [azurerm_resource_group.example_rg]
}

resource "azurerm_app_service_plan" "example_asp" {
  name                = "agnish-asp"
  location            = var.location
  resource_group_name = var.rg_name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
  depends_on               = [azurerm_resource_group.example_rg]
}

resource "azurerm_app_service" "example_as" {
  name                = "agnish-appsvc"
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.example_asp.id

  site_config {
    always_on = true
    linux_fx_version = "DOCKER|python:3.10-slim" # Replace with your container image and tag
  }

  depends_on = [azurerm_container_registry.example_acr, azurerm_app_service_plan.example_asp, azurerm_resource_group.example_rg]
}