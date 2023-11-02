  output "acr_name" {
    value = azurerm_container_registry.example_acr.name
  }

  output "acr_login_server" {
    value = azurerm_container_registry.example_acr.login_server
  }

  output "acr_admin_username" {
    value = azurerm_container_registry.example_acr.admin_username
  }

  output "acr_admin_password" {
    value = azurerm_container_registry.example_acr.admin_password
  }

  output "app_service_name" {
    value = azurerm_app_service.example_as.name
  }