variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type        = string
}

variable "user_ocid" {
  description = "User OCID"
  type        = string
}

variable "private_key_path" {
  description = "Private key path to use for signing"
  type        = string
}

variable "private_key_password" {
  description = "Password for private key to use for signing"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region to connect to. Default: eu-paris-1"
  type        = string
  default     = "eu-paris-1"
}

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}



variable "fingerprint" {
  description = "The fingerprint of the key to use for signing"
  type        = string
}

variable "ssh_authorized_public_keys" {
  description = "List of authorized SSH public keys"
  type        = list(any)
}

locals {
  cidr_blocks = { vcn = "10.0.0.0/16"
    instances = "10.0.0.0/24"
  lb = "10.0.1.0/24" }
}
