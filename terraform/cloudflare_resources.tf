resource "cloudflare_record" "arm_dns_record" {
  count = 2
  name  = "arm-${count.index}"
  # used for SSH - dont proxy
  proxied = false
  ttl     = 1
  type    = "A"
  value   = oci_core_public_ip.arm_public-ip-addresses[count.index].ip_address
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_record" "amd_dns_record" {
  count = 2
  name  = "amd-${count.index}"
  # used for SSH - dont proxy
  proxied = false
  ttl     = 1
  type    = "A"
  value   = oci_core_public_ip.amd_public-ip-addresses[count.index].ip_address
  zone_id = var.cloudflare_zone_id
}
