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
  admin_enabled            = true
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_container_registry.example_acr.id
  role_definition_name = "Contributor"
  principal_id         = "10cd6875-bcf6-4f3f-b16f-991ff518656b"
}

resource "null_resource" "run_script" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      chmod +x ../init_acr.sh
      bash ../init_acr.sh
      EOF
  }
  depends_on = [azurerm_container_registry.example_acr]
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
    application_stack {
      docker_registry_url = "https://${azurerm_container_registry.example_acr.login_server}"
      docker_registry_password = azurerm_container_registry.example_acr.admin_password
      docker_registry_username = azurerm_container_registry.example_acr.admin_username
      docker_image_name = "demo-first-img"
    }
  }

  depends_on = [azurerm_container_registry.example_acr, azurerm_service_plan.example_asp, null_resource.run_script]
}