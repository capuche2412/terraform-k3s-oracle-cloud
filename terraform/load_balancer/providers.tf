terraform {
  required_version = ">= 1.3.9"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.24.0"
    }
  }
}
