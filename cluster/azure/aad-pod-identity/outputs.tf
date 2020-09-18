output "vm_contributor_role_assignment_id" {
  value = azurerm_role_assignment.node_rg_vm_contributor.id
}

output "mi_operator_role_assignment_ids" {
  value = azurerm_role_assignment.mi_operators.*.id
}