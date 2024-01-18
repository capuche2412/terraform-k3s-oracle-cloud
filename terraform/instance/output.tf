output "cluster_server_ip" {
  description = "k3s cluser server IP"
  value       = oci_core_instance.arm.private_ip
  depends_on  = [oci_core_instance.arm]
}
