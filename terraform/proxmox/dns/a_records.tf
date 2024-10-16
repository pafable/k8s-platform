locals {
  fleet_domain = "fleet.pafable.com." # DO NOT FORGET TO INCLUDE "." AT THE END FOR ALL ZONES!
  home_domain  = "home.pafable.com."  # DO NOT FORGET TO INCLUDE "." AT THE END FOR ALL ZONES!

  home_hosts = toset([
    "argocd",
    "grafana",
    "jenkins",
    "pgadmin",
    "prometheus",
    "vault"
  ])
}

# fleet domains
resource "dns_a_record_set" "behemoth" {
  name = "behemoth"
  zone = local.fleet_domain

  addresses = [
    data.aws_ssm_parameter.behemoth_ip.value
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

resource "dns_a_record_set" "kraken" {
  name = "kraken"
  zone = local.fleet_domain

  addresses = [
    data.aws_ssm_parameter.kraken_ip.value
  ]

  ttl = 300
}

# home domains
resource "dns_a_record_set" "host_records" {
  for_each = local.home_hosts
  name     = each.value
  zone     = local.home_domain

  addresses = [
    data.aws_ssm_parameter.k3s_controller_ip.value,
    data.aws_ssm_parameter.k3s_agent1_ip.value
  ]

  ttl = 300
}