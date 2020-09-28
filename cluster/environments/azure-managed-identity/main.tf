terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  version = "~> 2.17"

  features {}
}

data "azurerm_resource_group" "cluster" {
  name = var.resource_group_name
}

module "vnet" {
  source = "../../../cluster/azure/vnet"

  resource_group_name = data.azurerm_resource_group.cluster.name
  vnet_name           = var.vnet_name
  address_space       = var.address_space

  tags = {
    environment = "azure-simple"
  }
}

module "subnet" {
  source = "../../../cluster/azure/subnet"

  subnet_name         = "${var.cluster_name}-aks-subnet"
  vnet_name           = module.vnet.vnet_name
  resource_group_name = data.azurerm_resource_group.cluster.name
  address_prefixes    = [var.subnet_prefix]
}

module "aks-gitops" {
  source = "../../../cluster/azure/aks-gitops"

  agent_vm_count = var.agent_vm_count
  agent_vm_size  = var.agent_vm_size
  ssh_public_key = var.ssh_public_key

  resource_group_name   = data.azurerm_resource_group.cluster.name
  cluster_name          = var.cluster_name
  dns_prefix            = var.dns_prefix
  kubernetes_version    = var.kubernetes_version
  oms_agent_enabled     = var.enable_oms_agent
  msi_enabled           = var.enable_managed_identity
  acr_enabled           = var.enable_acr
  skip_role_assignments = false

  flux_recreate        = var.flux_recreate
  gc_enabled           = var.gc_enabled
  gitops_ssh_url       = var.gitops_ssh_url
  gitops_ssh_key_path  = var.gitops_ssh_key_path
  gitops_path          = var.gitops_path
  gitops_poll_interval = var.gitops_poll_interval
  gitops_label         = var.gitops_label
  gitops_url_branch    = var.gitops_url_branch

  network_plugin = var.network_plugin
  network_policy = var.network_policy
  vnet_subnet_id = module.subnet.subnet_id
  service_cidr   = var.service_cidr
  dns_ip         = var.dns_ip
  docker_cidr    = var.docker_cidr
}

module "acr" {
  source = "../../azure/acr"

  acr_name               = var.acr_name
  enable_acr             = var.enable_acr
  resource_group_name    = data.azurerm_resource_group.cluster.name
  acr_pull_principal_ids = [module.aks-gitops.kubelet_identity.object_id]
}

module "aad-pod-identity" {
  source = "../../azure/aad-pod-identity"

  kubelet_identity_object_id                     = module.aks-gitops.kubelet_identity.object_id
  node_resource_group                            = module.aks-gitops.node_resource_group
  additional_managed_identity_resource_group_ids = [data.azurerm_resource_group.cluster.id]
}