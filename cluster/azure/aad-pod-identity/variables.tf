variable "kubelet_identity_object_id" {
  type        = string
  description = "(Required) The AKS kubelet_identity's object_id, used to assign necessary roles for aad-pod-identity."
}

variable "node_resource_group" {
  type        = string
  description = "(Required) The name of the AKS node_resource_group."
}

variable "additional_managed_identity_resource_group_ids" {
  type        = list(string)
  description = "(Optional) Additional resource groups that contain managed identities."
  default     = []
}