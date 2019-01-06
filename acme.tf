resource "tls_private_key" "reg_private_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.reg_private_key.private_key_pem}"
  email_address   = "root@zestedesavoir.com"
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "tls_cert_request" "req" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.cert_private_key.private_key_pem}"
  dns_names       = ["zestedesavoir.com", "*.zestedesavoir.com"]

  subject {
    common_name  = "zestedesavoir.com"
    organization = "Zeste de Savoir"
    country      = "FR"
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  certificate_request_pem   = "${tls_cert_request.req.cert_request_pem}"

  dns_challenge {
    provider = "gandiv5"

    config {
      GANDIV5_API_KEY = "${var.gandi_key}"
    }
  }
}
