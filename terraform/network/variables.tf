variable "cidr_blocks" {
  description = "CIDRs of the network"
}

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type        = string
}
