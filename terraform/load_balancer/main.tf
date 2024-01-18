resource "oci_core_public_ip" "load_balancer_public_ip" {
  #Required
  compartment_id = var.compartment_id
  lifetime       = "RESERVED"

  display_name = "load_balancer_public_ip"
}

resource "oci_network_load_balancer_network_load_balancer" "network_load_balancer_k3s_cluster" {
  compartment_id                 = var.compartment_id
  display_name                   = "network_load_balancer_k3s_cluster"
  subnet_id                      = var.k3s_cluster_subnet.id
  is_preserve_source_destination = true
  is_private                     = false
  reserved_ips {
    id = oci_core_public_ip.load_balancer_public_ip.id
  }
}

resource "oci_network_load_balancer_backend_set" "network_load_balancer_k3s_cluster_backend_set" {
  depends_on = [oci_network_load_balancer_network_load_balancer.network_load_balancer_k3s_cluster]

  health_checker {

    protocol           = "HTTP"
    interval_in_millis = 10000
    retries            = 3
    return_code        = 200
    timeout_in_millis  = 3000
    url_path           = "/"
  }
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.network_load_balancer_k3s_cluster.id
  name                     = "load_balancer_k3s_cluster_backend_set"
  policy                   = "FIVE_TUPLE"
}

resource "oci_network_load_balancer_backend" "k3s_server_backend" {
  depends_on = [oci_network_load_balancer_backend_set.network_load_balancer_k3s_cluster_backend_set]

  backend_set_name         = oci_network_load_balancer_backend_set.network_load_balancer_k3s_cluster_backend_set.name
  ip_address               = var.backend_ip_address
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.network_load_balancer_k3s_cluster.id
  port                     = 80
  weight                   = 1
}
