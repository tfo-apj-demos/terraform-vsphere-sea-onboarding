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

variable "TFC_WORKSPACE_ID" {}