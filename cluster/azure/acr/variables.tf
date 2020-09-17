variable "resource_group_name" {
  type = string
}

variable "enable_acr" {
  type    = string
  default = "false"
}

variable "acr_name" {
  type = string
}

variable "acr_pull_principal_ids" {
  type    = list(string)
  default = []
}

variable "acr_push_principal_ids" {
  type    = list(string)
  default = []
}

variable "tags" {
  description = "The tags to associate with ACR"
  type        = map

  default = {}
}
