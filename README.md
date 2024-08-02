# GCVE Terraform Cloud Integration Module

## Overview

This Terraform module is designed to streamline the onboarding process for Solution Engineers and Architects into a Google Cloud VMware Engine (GCVE) environment. By leveraging their own Terraform Cloud (TFC) organization and TFC agent, users can demonstrate seamless integration between various HashiCorp products including Packer, Terraform, Vault, and Boundary.

## Features

- **Vault Integration**: Obtain vSphere, NSX, and HCP credentials from Vault.
- **TFC Organization Configuration**: Set up Variable Sets, Agent Pools, Agent Tokens, Projects, and Workspaces.
- **TFC Agent Deployment**: Deploy the TFC Agent into the GCVE environment.
- **Vault JWT Auth Configuration**: Configure Vault with JWT auth method for Org/Projects.
- **Boundary Target Configuration**: Set up a Boundary target for your TFC Agent.