locals {
  fleet_domain = "fleet.pafable.com." # DO NOT FORGET TO INCLUDE "." AT THE END FOR ALL ZONES!
  home_domain  = "home.pafable.com."  # DO NOT FORGET TO INCLUDE "." AT THE END FOR ALL ZONES!
}

resource "dns_a_record_set" "behemoth" {
  name = "behemoth"
  zone = local.fleet_domain

  addresses = [
    data.aws_ssm_parameter.behemoth_ip.value
  ]

  ttl = 300
}

resource "dns_a_record_set" "kraken" {
  name = "kraken"
  zone = local.fleet_domain

  addresses = [
    data.aws_ssm_parameter.kraken_ip.value
  ]

  ttl = 300
}

resource "dns_a_record_set" "hive" {
  name = "hive"
  zone = local.fleet_domain

  addresses = [
    data.aws_ssm_parameter.behemoth_ip.value,
    data.aws_ssm_parameter.kraken_ip.value
  ]

  ttl = 300
}

resource "dns_a_record_set" "jenkins" {
  name = "jenkins"
  zone = local.home_domain

  addresses = [
    data.aws_ssm_parameter.k3s_controller_ip.value
  ]
}

resource "dns_a_record_set" "prometheus" {
  name = "prometheus"
  zone = local.home_domain

  addresses = [
    data.aws_ssm_parameter.k3s_controller_ip.value
  ]
}

resource "dns_a_record_set" "grafana" {
  name = "grafana"
  zone = local.home_domain

  addresses = [
    data.aws_ssm_parameter.k3s_controller_ip.value
  ]
}

resource "dns_a_record_set" "pgadmin" {
  name = "pgadmin"
  zone = local.home_domain

  addresses = [
    data.aws_ssm_parameter.k3s_controller_ip.value
  ]
}