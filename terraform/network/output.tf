output "vcn" {
  description = "Created VCN"
  value       = oci_core_vcn.cluster_network
}

output "cluster_subnet" {
  description = "Subnet of the k3s cluster"
  value       = oci_core_subnet.cluster_subnet
  depends_on  = [oci_core_subnet.cluster_subnet]
}

output "lb_subnet" {
  description = "Subnet of the LB"
  value       = oci_core_subnet.lb_subnet
  depends_on  = [oci_core_subnet.lb_subnet]
}

output "cluster_internal_nsg" {
  description = "Network Security Group for internal cluster subnet"
  value       = oci_core_network_security_group.cluster_internal_nsg
}

output "public_lb_nsg" {
  description = "Network Security Group for load balancer subnet"
  value       = oci_core_network_security_group.public_lb_nsg
}
