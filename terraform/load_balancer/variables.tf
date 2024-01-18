variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "k3s_cluster_subnet" {
  description = "k3s cluser subnet"
}

variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type        = string
}

variable "backend_ip_address" {
  description = "Backend IP Adress"
  type        = string
}

