resource "oci_core_subnet" "lb_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.cluster_network.id
  cidr_block        = var.cidr_blocks["lb"]
  display_name      = "Load Balancer subnet"
  security_list_ids = [oci_core_security_list.accept_connections_from_outside.id]
}


resource "oci_core_subnet" "cluster_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.cluster_network.id
  cidr_block        = var.cidr_blocks["instances"]
  display_name      = "Internal cluster subnet"
  security_list_ids = [oci_core_vcn.cluster_network.default_security_list_id]
}
