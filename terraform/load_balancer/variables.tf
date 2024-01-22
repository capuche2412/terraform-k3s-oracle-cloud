variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "lb_subnet_id" {
  description = "Load Balancer subnet ID"
}

variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type        = string
}

variable "backend_ip_address" {
  description = "Backend IP Adress"
  type        = string
}

variable "http_lb_port" {
  type    = number
  default = 80
}

variable "https_lb_port" {
  type    = number
  default = 443
}

variable "kube_api_port" {
  type    = number
  default = 6443
}
