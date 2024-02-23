terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "~> 0"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.5"
    }
  }
}

provider "tfe" {
  organization = var.tfc_organization_name
}