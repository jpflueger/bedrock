# azure-managed-identity

The `azure-managed-identity` environment is a non-production ready template we provide that uses [managed identity](https://docs.microsoft.com/en-us/azure/aks/use-managed-identity) instead of service principals to deploy an azure kubernetes service. It also includes role assignments required for azure contanier registry and aad-pod-identity integration.

## Getting Started

1. Copy this template directory to a repo of its own. Bedrock environments remotely reference the Terraform modules that they need and do not need be housed in the Bedrock repo.
2. Follow the instructions on the [main Azure page](../../azure#Deploying-Azure-Cluster) in this repo to create your cluster and surrounding infrastructure.

## Resource Group Requirement

This environment requires a single resource group be created.  The requisite variable is `resource_group_name`.  To use the Azure CLI to create the resource group, see [here](../../azure/README.md).