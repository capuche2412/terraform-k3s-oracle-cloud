terraform {
  required_version = ">= 1.3.9"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.24.0"
    }
  }
}

provider "oci" {
  auth             = "APIKey"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}

module "network" {
  source = "./network"

  tenancy_ocid   = var.tenancy_ocid
  cidr_blocks    = local.cidr_blocks
  compartment_id = var.compartment_id
}

module "instance" {
  source     = "./instance"
  depends_on = [module.network]

  compartment_id             = var.compartment_id
  tenancy_ocid               = var.tenancy_ocid
  cluster_subnet_id          = module.network.cluster_subnet.id
  allow_ssh_nsg_id           = module.network.allow_ssh.id
  ssh_authorized_public_keys = var.ssh_authorized_public_keys

  cidr_blocks = local.cidr_blocks
}
