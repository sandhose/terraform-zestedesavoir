resource "gandi_zone" "zestedesavoir_com" {
  name = "zestedesavoir.com"
}

resource "gandi_domainattachment" "zestedesavoir_com" {
  domain = "zestedesavoir.com"
  zone = "${gandi_zone.zestedesavoir_com.id}"
}
