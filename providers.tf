provider "gandi" {
  key = "${var.gandi_key}"
}

provider "consul" {
  address    = "consul.sandhose.fr:443"
  scheme     = "https"
  datacenter = "dc1"
  token      = "${var.consul_token}"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "scaleway" {
  organization = "${var.scaleway_organization_id}"
  token        = "${var.scaleway_token}"
  region       = "par1"
}
