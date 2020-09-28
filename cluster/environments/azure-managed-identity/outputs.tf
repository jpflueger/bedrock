locals {
  user_assigned_identities = [
    azurerm_user_assigned_identity.app1
  ]
}

output "application_identities" {
  value = flatten([
    for aaid in local.user_assigned_identities : {
      name      = aaid.name
      id        = aaid.id
      client_id = aaid.client_id
    }
  ])
}