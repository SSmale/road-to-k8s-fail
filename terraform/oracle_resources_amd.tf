
resource "oci_core_instance" "amd" {
  count          = 2
  display_name   = "road-to-kubernets-amd-${count.index}"
  compartment_id = oci_identity_compartment.road-to-k8s.id

  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  shape = data.oci_core_images.amd-ubuntu-images.shape
  shape_config {
    memory_in_gbs = 1
    ocpus         = 1
  }

  metadata = {
    "ssh_authorized_keys" = var.oracle_public_key
  }

  source_details {
    boot_volume_size_in_gbs = "50"
    source_id               = data.oci_core_images.amd-ubuntu-images.images[0].id
    source_type             = "image"
  }

  create_vnic_details {
    display_name              = "road-to-kubernets-amd-${count.index}"
    assign_private_dns_record = "true"
    assign_public_ip          = "false"
    hostname_label            = "amd-${count.index}"
    subnet_id                 = oci_core_subnet.road-to-k8s-subnet.id
  }
}

data "oci_core_images" "amd-ubuntu-images" {
  compartment_id           = oci_identity_compartment.road-to-k8s.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.04"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_vnic_attachments" "amd_vnic_attachment" {
  count          = 2
  compartment_id = oci_identity_compartment.road-to-k8s.id
  instance_id    = oci_core_instance.amd[count.index].id

  depends_on = [
    oci_core_instance.amd
  ]
}

data "oci_core_private_ips" "amd_private_ips" {
  count   = 2
  vnic_id = data.oci_core_vnic_attachments.amd_vnic_attachment[count.index].vnic_attachments[0].vnic_id

  depends_on = [
    oci_core_instance.amd
  ]
}

resource "oci_core_public_ip" "amd_public-ip-addresses" {
  count          = 2
  compartment_id = oci_identity_compartment.road-to-k8s.id
  lifetime       = "RESERVED"
  display_name   = "road-to-k8s-public-ip-${count.index}"
  private_ip_id  = data.oci_core_private_ips.amd_private_ips[count.index].private_ips[0].id
}

output "amd_public_ip_addresses" {
  value = oci_core_public_ip.amd_public-ip-addresses.*.ip_address
}
