resource "azurerm_user_assigned_identity" "app1" {
  resource_group_name = data.azurerm_resource_group.cluster.name
  location            = data.azurerm_resource_group.cluster.location
  name                = "mi-${var.cluster_name}-app1"
}

resource "azurerm_role_assignment" "app1_reader" {
  role_definition_name = "Reader"
  scope                = data.azurerm_resource_group.cluster.id
  principal_id         = azurerm_user_assigned_identity.app1.principal_id
}