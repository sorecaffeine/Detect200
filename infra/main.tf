resource "azurerm_resource_group" "main" {
  name     = "rg-down-detector-dev"
  location = var.location
}
resource "azurerm_container_app" "main" {
  name                         = "ca-down-detector-dev"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.container_app.id
    ]
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.container_app.id
  }

  template {
    container {
      name   = "down-detector"
      image  = "${azurerm_container_registry.main.login_server}/down-detector:v1"
      cpu    = 0.25
      memory = "0.5Gi"
    }

    min_replicas = 0
    max_replicas = 1
  }

  ingress {
    external_enabled = true
    target_port      = 8000
    transport        = "http"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_registry" "main" {
  name                = "down200sorecaffeine"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.acr_location
  sku                 = "Basic"
  admin_enabled       = false
}
resource "azurerm_container_app_environment" "main" {
  name                = "cae-down-detector-dev"
  location            = var.container_app_location
  resource_group_name = azurerm_resource_group.main.name

  lifecycle {
    ignore_changes = [
      workload_profile
    ]
  }
}
resource "azurerm_user_assigned_identity" "container_app" {
  name                = "id-down-detector-dev"
  location            = var.container_app_location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_app.principal_id
}
