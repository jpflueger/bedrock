data "azurerm_resource_group" "node" {
  name = var.node_resource_group
}

locals {
  mi_operator_scopes = concat([data.azurerm_resource_group.node.id], var.additional_managed_identity_resource_group_ids)
}

# allows aad-pod-identity to assign identities to the node VMSS in the node resource group
# NOTE: if you have multiple node pools, they should be added here
resource "azurerm_role_assignment" "node_rg_vm_contributor" {
  scope                = data.azurerm_resource_group.node.id
  principal_id         = var.kubelet_identity_object_id
  role_definition_name = "Virtual Machine Contributor"
}

resource "azurerm_role_assignment" "mi_operators" {
  count                = length(local.mi_operator_scopes)
  scope                = local.mi_operator_scopes[count.index]
  principal_id         = var.kubelet_identity_object_id
  role_definition_name = "Managed Identity Operator"
}