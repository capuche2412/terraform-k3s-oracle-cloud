resource "oci_core_vcn" "cluster_network" {
  compartment_id = var.compartment_id

  cidr_blocks = [var.cidr_blocks["vcn"]]

  display_name = "galdren-vcn"
  dns_label    = "galdrenvcn"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  enabled        = true
}

resource "oci_core_default_route_table" "internet_route_table" {
  compartment_id             = var.compartment_id
  manage_default_resource_id = oci_core_vcn.cluster_network.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_default_security_list" "default_list" {
  manage_default_resource_id = oci_core_vcn.cluster_network.default_security_list_id

  display_name = "Outbound only (default)"

  # Egress rules

  egress_security_rules {
    protocol    = "all" // TCP
    description = "Allow outbound"
    destination = "0.0.0.0/0"
  }

  # Ingress rules

  ingress_security_rules {
    protocol    = "all"
    description = "Allow inter-subnet traffic"
    source      = var.cidr_blocks["vcn"]
  }
  ingress_security_rules {
    protocol    = "6" // TCP
    description = "Allow SSH traffic"
    source      = "0.0.0.0/0"

    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol    = "6" // TCP
    description = "Allow SSH traffic"
    source      = "0.0.0.0/0"

    tcp_options {
      max = 6443
      min = 6443
    }
  }
}

resource "oci_core_security_list" "accept_connections_from_outside" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id

  display_name = "Accept HTTP,HTTPS from outside"

  # Egress rules

  egress_security_rules {
    protocol    = "all"
    description = "Allow outbound"
    destination = "0.0.0.0/0"
  }

  # Ingress rules

  ingress_security_rules {
    protocol    = "all"
    description = "Allow inter-subnet traffic"
    source      = var.cidr_blocks["vcn"]
  }
  ingress_security_rules {
    protocol    = "6" // TCP
    description = "Allow HTTP traffic"
    source      = "0.0.0.0/0"

    tcp_options {
      max = 80
      min = 80
    }
  }
  ingress_security_rules {
    protocol    = "6" // TCP
    description = "Allow HTTPS traffic"
    source      = "0.0.0.0/0"

    tcp_options {
      max = 443
      min = 443
    }
  }
}
