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
}

variable "cluster" {
  description = "The cluster in which the VM will be deployed."
  type        = string
}

variable "primary_datastore" {
  description = "The primary datastore for the VM."
  type        = string
}

variable "folder_path" {
  description = "The folder path where the VM will be located."
  type        = string
}

variable "networks" {
  description = "Network configuration for the VM."
  type        = map(string)
}

variable "agent_token" {
  description = "The token for the Terraform Cloud agent."
  type        = string
}

variable "tags" {
  description = "Tags to assign to the VM."
  type        = map(string)
  default     = {
    "application" = "tfc-agent"
  }
}

variable "instance_count" {
  description = "The number of instances to create."
  type        = number
  default     = 1
}
