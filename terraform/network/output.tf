output "vcn" {
  description = "Created VCN"
  value       = oci_core_vcn.cluster_network
}

output "cluster_subnet" {
  description = "Subnet of the k3s cluser"
  value       = oci_core_subnet.cluster_subnet
  depends_on  = [oci_core_subnet.cluster_subnet]
}

output "allow_traffic" {
  description = "Network Security Group to allow SSGH, HTTP & HTTPS"
  value       = oci_core_network_security_group.allow_traffic
}
