resource "tls_private_key" "dkim_key" {
  algorithm = "RSA"
  rsa_bits = 1024
}

data "template_file" "dkim_record" {
  template = "v=$${v}; k=$${k}; p=$${p}"

  vars {
    v = "DKIM1"
    k = "rsa"
    p = "${replace(tls_private_key.dkim_key.private_key_pem, "/-----(BEGIN|END) RSA PRIVATE KEY-----|\n/", "")}"
  }
}

resource "gandi_zonerecord" "dkim" {
  zone = "${gandi_zone.zestedesavoir_com.id}"
  name = "test._domainkey"
  type = "TXT"
  ttl = 3600
  values = [
    "\"${data.template_file.dkim_record.rendered}\""
  ]
}

output "pubkey" {
  value = "${data.template_file.dkim_record.rendered}"
}
