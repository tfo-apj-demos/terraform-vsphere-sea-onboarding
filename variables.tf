variable "vault_address" {
  description = "GCVE Vault"
  default     = "https://vault.hashicorp.local:8200"
}

variable "boundary_address" {
  type        = string
  description = "HCP Boundary Address"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of the Terraform Cloud organization."
}

variable "github_username" {
  type        = string
  description = "The name of your GitHub Username."
}

variable "datacenter" {
  description = "The datacenter in which the VM will be deployed."
  type        = string
  default     = "Datacenter"
}

variable "cluster" {
  description = "The cluster in which the VM will be deployed."
  type        = string
  default     = "cluster"
}

variable "primary_datastore" {
  description = "The primary datastore for the VM."
  type        = string
  default     = "vsanDatastore"
}

variable "folder_path" {
  description = "The folder path where the VM will be located."
  type        = string
  default     = "sea-tfc-agents"
}

variable "tags" {
  description = "Tags to assign to the VM."
  type        = map(string)
  default = {
    "application" = "tfc-agent"
  }
}

variable "dns_server_list" {
  description = "List of DNS servers to use."
  type        = list(string)
  default     = ["172.21.15.150", "10.10.0.8"]
}

variable "gateway" {
  description = "The gateway for the VM."
  type        = string
  default     = "172.21.12.1"
}

variable "dns_suffix_list" {
  description = "List of DNS suffixes to use."
  type        = list(string)
  default     = ["hashicorp.local"]
}

variable "tfc_project_name" {
  description = "The name of the Terraform Cloud project."
  type        = string
  default     = "VMware-Project"
}

variable "BOUNDARY_TOKEN" {
  description = "Boundary token"
  type        = string
}

variable "BOUNDARY_ADDR" {
  description = "Boundary address"
  type        = string
}