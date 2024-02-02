resource "oci_identity_compartment" "road-to-k8s" {
  compartment_id = var.oracle_root_compartment_id
  description    = "A compartment for my Road to K8s vms"
  name           = "RoadToKubernets"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = oci_identity_compartment.road-to-k8s.id
}

resource "oci_core_vcn" "road-to-k8s-vcn" {
  display_name   = "road-to-k8s-vcn"
  cidr_block     = "10.0.0.0/16"
  compartment_id = oci_identity_compartment.road-to-k8s.id
  dns_label      = "roadtok8s"
}

resource "oci_core_subnet" "road-to-k8s-subnet" {
  cidr_block          = "10.0.0.0/24"
  display_name        = "road-to-k8s-subnet"
  compartment_id      = oci_identity_compartment.road-to-k8s.id
  vcn_id              = oci_core_vcn.road-to-k8s-vcn.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  dns_label           = "main"
  route_table_id      = oci_core_vcn.road-to-k8s-vcn.default_route_table_id
}

resource "oci_core_internet_gateway" "road-to-k8s-gateway" {
  compartment_id = oci_identity_compartment.road-to-k8s.id
  display_name   = "Internet Gateway vcn-road-to-k8s"
  vcn_id         = oci_core_vcn.road-to-k8s-vcn.id
}

resource "oci_core_default_route_table" "road-to-k8s-routes" {
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.road-to-k8s-gateway.id
  }
  manage_default_resource_id = oci_core_vcn.road-to-k8s-vcn.default_route_table_id
}

resource "oci_core_default_security_list" "road-to-k8s-security_list" {
  ingress_security_rules {
    description = "allow all ingress"
    source      = "0.0.0.0/0"
    protocol    = "all"
  }
  egress_security_rules {
    description = "allow all egress"
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  manage_default_resource_id = oci_core_vcn.road-to-k8s-vcn.default_security_list_id
}
