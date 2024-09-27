variable "vault_address" {
  description = "The address of the Vault server"
  type        = string
}

variable "boundary_address" {
  description = "The address of the Boundary server"
  type        = string
}
variable "github_username" {
  type        = string
  description = "The name of your GitHub Username."
}

variable "vm_tag_application" {
  type        = string
  description = "The application tag for the VM."
}

variable "hostname_suffix" {
  type        = string
  description = "The suffix for the hostname of the VM."
}

variable "TFC_WORKSPACE_ID" {}