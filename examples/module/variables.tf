variable "vault_address" {
  description = "The address of the Vault server"
  type        = string
}

variable "boundary_address" {
  description = "The address of the Boundary server"
  type        = string
}

variable "BOUNDARY_TOKEN" {
  description = "The token for the Boundary server"
  type        = string
}

variable "vsphere_server" {
  description = "The address of the vSphere server"
  type        = string
}

variable "nsxt_manager_host" {
  description = "The address of the NSX-T Manager"
  type        = string
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of the Terraform Cloud organization."
}

variable "github_username" {
  type        = string
  description = "The name of your GitHub Username."
}