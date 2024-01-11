variable "allow_ssh_nsg_id" {
  description = "SSH Network Security Group ID"
  type        = string
}

variable "cidr_blocks" {
  description = "CIDR blocks for instance private ips"
}

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "cluster_subnet_id" {
  description = "Subnet of the k3s cluser"
}

variable "ssh_authorized_public_keys" {
  description = "List of authorized SSH public keys"
  type        = list(any)
}

variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type        = string
}

locals {
  arm_instance_config = {
    shape_id = "VM.Standard.A1.Flex"
    ocpus    = 4
    ram      = 24

    // Canonical-Ubuntu-22.04-aarch64-2023.10.13-0 eu-paris-1
    // https://docs.oracle.com/en-us/iaas/images/image/8fad1e74-c5bf-4192-be09-96ee8ec18a17/
    source_id   = "ocid1.image.oc1.eu-paris-1.aaaaaaaaz2qulrfipgei652hvwg4473qpdqpny326zvtwxfnlhprfwhf3ddq"
    source_type = "image"

    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_public_keys)
    }
  }
  amd_instance_config = {
    shape_id = "VM.Standard.E2.1.Micro"
    ocpus    = 1
    ram      = 1

    // Canonical-Ubuntu-22.04-Minimal-2023.10.15-0 eu-paris-1
    // https://docs.oracle.com/en-us/iaas/images/image/baab32f0-7c31-46b6-a2d6-6d091253c4b2/
    source_id   = "ocid1.image.oc1.eu-paris-1.aaaaaaaaciufgcd65vc72ic4wm7ws4fxincpakxscroysfeajwiddzmda3ra"
    source_type = "image"

    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_public_keys)
    }
  }
}
