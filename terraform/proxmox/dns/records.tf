resource "dns_a_record_set" "behemoth" {
  zone = "fleet.pafable.com." # DO NOT FORGET TO INCLUDE "." AT THE END FOR ALL ZONES!
  name = "behemoth"

  addresses = [
    data.aws_ssm_parameter.controller_ip.value
  ]

  ttl = 300
}

resource "dns_a_record_set" "kraken" {
  zone = "fleet.pafable.com."
  name = "kraken"

  addresses = [
    data.aws_ssm_parameter.agent1_ip.value
  ]

  ttl = 300
}