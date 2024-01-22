resource "oci_core_instance" "arm" {
  lifecycle {
    ignore_changes = [
      availability_domain
    ]
  }

  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.ad_1.name
  display_name        = "k3s-arm-instance"
  shape               = local.arm_instance_config.shape_id
  source_details {
    source_id   = local.arm_instance_config.source_id
    source_type = local.arm_instance_config.source_type
  }
  shape_config {
    memory_in_gbs = local.arm_instance_config.ram
    ocpus         = local.arm_instance_config.ocpus
  }
  create_vnic_details {
    subnet_id  = var.cluster_subnet_id
    private_ip = cidrhost(var.cidr_blocks["instances"], 10)
    nsg_ids    = [var.internal_cluster_nsg_id]
  }
  metadata = {
    "ssh_authorized_keys" = local.arm_instance_config.metadata.ssh_authorized_keys
  }
}

resource "oci_core_instance" "amd" {
  lifecycle {
    ignore_changes = [
      availability_domain
    ]
  }

  count               = 1
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.ad_1.name
  display_name        = "k3s_amd_instance_${count.index}"
  shape               = local.amd_instance_config.shape_id
  source_details {
    source_id   = local.amd_instance_config.source_id
    source_type = local.amd_instance_config.source_type
  }
  shape_config {
    memory_in_gbs = local.amd_instance_config.ram
    ocpus         = local.amd_instance_config.ocpus
  }
  create_vnic_details {
    subnet_id  = var.cluster_subnet_id
    private_ip = cidrhost(var.cidr_blocks["instances"], count.index + 20)
    nsg_ids    = [var.internal_cluster_nsg_id]
  }
  metadata = {
    "ssh_authorized_keys" = local.amd_instance_config.metadata.ssh_authorized_keys
  }
  depends_on = [oci_core_instance.arm]
}
