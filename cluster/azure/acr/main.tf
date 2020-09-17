data "azurerm_resource_group" "cluster" {
  name = var.resource_group_name
}

resource "azurerm_container_registry" "acr" {
  count = var.enable_acr ? 1 : 0

  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.cluster.name
  location            = data.azurerm_resource_group.cluster.location
  sku                 = "Basic"

  tags = var.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  count                = length(var.acr_pull_principal_ids)
  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPull"
  principal_id         = var.acr_pull_principal_ids[count.index]
}

resource "azurerm_role_assignment" "acr_push" {
  count                = length(var.acr_push_principal_ids)
  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPush"
  principal_id         = var.acr_push_principal_ids[count.index]
}