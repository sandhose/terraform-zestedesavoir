data "consul_key_prefix" "instances" {
  path_prefix = "zestedesavoir/instances/"
}

locals {
  hosts = "${keys(data.consul_key_prefix.instances.subkeys)}"
  images = "${data.consul_key_prefix.instances.subkeys}"
}

resource "scaleway_server" "instances" {
  count               = "${length(local.hosts)}"
  name                = "zds-${local.hosts[count.index]}"
  image               = "${lookup(local.images, local.hosts[count.index])}"
  type                = "START1-S"
  enable_ipv6         = "true"
  dynamic_ip_required = "true"
  tags                = ["zds"]
}

resource "gandi_zonerecord" "instances_ipv4" {
  count = "${length(local.hosts)}"
  zone  = "${gandi_zone.zestedesavoir_com.id}"
  name  = "${local.hosts[count.index]}"
  type  = "A"
  ttl   = 300
  values = ["${scaleway_server.instances.*.public_ip[count.index]}"]
}

resource "gandi_zonerecord" "instances_ipv6" {
  count = "${length(local.hosts)}"
  zone  = "${gandi_zone.zestedesavoir_com.id}"
  name  = "${local.hosts[count.index]}"
  type  = "AAAA"
  ttl   = 300
  values = ["${scaleway_server.instances.*.public_ipv6[count.index]}"]
}
