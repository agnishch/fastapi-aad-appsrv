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

resource "azurerm_service_plan" "example_asp" {
  name                = "agnish-asp"
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
  depends_on          = [azurerm_resource_group.example_rg]
}

resource "azurerm_linux_web_app" "example_as" {
  name                = "agnish-appsvc"
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.example_asp.id

  site_config {
    always_on = true
    # linux_fx_version = "DOCKER|python:3.10-slim" # Replace with your container image and tag
  }

  depends_on = [azurerm_container_registry.example_acr, azurerm_service_plan.example_asp, azurerm_resource_group.example_rg]
}