# Cluster NSG

resource "oci_core_network_security_group" "cluster_internal_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  display_name   = "Allow k3s networking"
}

# resource "oci_core_network_security_group_security_rule" "allow_ssh_from_vcn" {
#   network_security_group_id = oci_core_network_security_group.cluster_internal_nsg.id
#   protocol                  = "6" // TCP
#   source                    = "0.0.0.0/0"
#   source_type               = "CIDR_BLOCK"
#   tcp_options {
#     destination_port_range {
#       max = 22
#       min = 22
#     }
#   }
#   direction = "INGRESS"
# }

# resource "oci_core_network_security_group_security_rule" "allow_http_from_vcn" {
#   network_security_group_id = oci_core_network_security_group.cluster_internal_nsg.id
#   protocol                  = "6" // TCP
#   source                    = oci_core_network_security_group.public_lb_nsg.id
#   source_type               = "NETWORK_SECURITY_GROUP"
#   tcp_options {
#     destination_port_range {
#       max = 80
#       min = 80
#     }
#   }
#   direction = "INGRESS"
# }

# resource "oci_core_network_security_group_security_rule" "allow_https_from_vcn" {
#   network_security_group_id = oci_core_network_security_group.cluster_internal_nsg.id
#   protocol                  = "6" // TCP
#   source                    = oci_core_network_security_group.public_lb_nsg.id
#   source_type               = "NETWORK_SECURITY_GROUP"
#   tcp_options {
#     destination_port_range {
#       max = 443
#       min = 443
#     }
#   }
#   direction = "INGRESS"
# }

# resource "oci_core_network_security_group_security_rule" "allow_kubeAPI_from_vcn" {
#   network_security_group_id = oci_core_network_security_group.cluster_internal_nsg.id
#   protocol                  = "6" // TCP
#   source                    = oci_core_network_security_group.public_lb_nsg.id
#   source_type               = "NETWORK_SECURITY_GROUP"
#   tcp_options {
#     destination_port_range {
#       max = 6443
#       min = 6443
#     }
#   }
#   direction = "INGRESS"
# }

resource "oci_core_network_security_group_security_rule" "allow_traffic_from_vcn" {
  network_security_group_id = oci_core_network_security_group.cluster_internal_nsg.id
  protocol                  = "all"
  source                    = "10.0.0.0/8"
  source_type               = "CIDR_BLOCK"

  direction = "INGRESS"
}

# LB NSG

resource "oci_core_network_security_group" "public_lb_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cluster_network.id
  display_name   = "K3s public LB nsg"
}

resource "oci_core_network_security_group_security_rule" "allow_http_from_all" {
  network_security_group_id = oci_core_network_security_group.public_lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow HTTP from all"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_https_from_all" {
  network_security_group_id = oci_core_network_security_group.public_lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # tcp

  description = "Allow HTTPS from all"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_kubeapi_from_all" {
  network_security_group_id = oci_core_network_security_group.public_lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # tcp

  description = "Allow Kube API from all"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 6443
      min = 6443
    }
  }
}
