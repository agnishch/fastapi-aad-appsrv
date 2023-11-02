resource "azurerm_container_registry" "example_acr" {
  name                     = "agnish-acr" # Replace with your desired ACR name
  resource_group_name      = var.rg_name
  location                 = var.location
  sku                      = "Basic" # Replace with the desired SKU (e.g., "Basic", "Standard", "Premium")
}

resource "azurerm_app_service_plan" "example_asp" {
  name                = "agnish-asp"
  location            = var.location
  resource_group_name = var.rg_name
  kind                = "Linux"

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "example_as" {
  name                = "agnish-appsrv"
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.example_asp.id

  site_config {
    always_on = true
    linux_fx_version = "PYTHON|3.10" # Replace with your container image and tag
  }

  depends_on = [azurerm_container_registry.example_acr]
}