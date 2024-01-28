resource "oci_core_public_ip" "load_balancer_public_ip" {
  #Required
  compartment_id = var.compartment_id
  lifetime       = "RESERVED"

  display_name = "load_balancer_public_ip"
  lifecycle { // Workaround : https://github.com/oracle/terraform-provider-oci/issues/1893
    ignore_changes = [
      private_ip_id
    ]
  }
}

resource "oci_network_load_balancer_network_load_balancer" "lb_k3s_cluster" {
  compartment_id                 = var.compartment_id
  display_name                   = "network_load_balancer_k3s_cluster"
  subnet_id                      = var.lb_subnet_id
  is_preserve_source_destination = false
  is_private                     = false
  reserved_ips {
    id = oci_core_public_ip.load_balancer_public_ip.id
  }
}

# HTTP
resource "oci_network_load_balancer_listener" "k3s_http_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.k3s_http_backend_set.name
  name                     = "k3s_http_listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.lb_k3s_cluster.id
  port                     = var.http_lb_port
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend_set" "k3s_http_backend_set" {
  depends_on = [oci_network_load_balancer_network_load_balancer.lb_k3s_cluster]

  health_checker {
    protocol = "TCP"
    port     = var.http_lb_port
  }
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.lb_k3s_cluster.id
  name                     = "k3s_http_backend_set"
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = false
}

resource "oci_network_load_balancer_backend" "k3s_http_server_backend" {
  depends_on = [oci_network_load_balancer_backend_set.k3s_http_backend_set]

  backend_set_name         = oci_network_load_balancer_backend_set.k3s_http_backend_set.name
  ip_address               = var.backend_ip_address
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.lb_k3s_cluster.id
  port                     = var.http_lb_port
  weight                   = 1
}


# HTTPS
resource "oci_network_load_balancer_listener" "k3s_https_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.k3s_https_backend_set.name
  name                     = "k3s_https_listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.lb_k3s_cluster.id
  port                     = var.https_lb_port
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend_set" "k3s_https_backend_set" {
  depends_on = [oci_network_load_balancer_network_load_balancer.lb_k3s_cluster]

  health_checker {
    protocol = "TCP"
    port     = var.https_lb_port
  }
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.lb_k3s_cluster.id
  name                     = "k3s_https_backend_set"
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = false
}

resource "oci_network_load_balancer_backend" "k3s_https_server_backend" {
  depends_on = [oci_network_load_balancer_backend_set.k3s_https_backend_set]

  backend_set_name         = oci_network_load_balancer_backend_set.k3s_https_backend_set.name
  ip_address               = var.backend_ip_address
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.lb_k3s_cluster.id
  port                     = var.https_lb_port
  weight                   = 1
}

