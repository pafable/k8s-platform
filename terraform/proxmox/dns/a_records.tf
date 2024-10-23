locals {
  fleet_domain = "fleet.pafable.com." # DO NOT FORGET TO INCLUDE "." AT THE END FOR ALL ZONES!
  home_domain  = "home.pafable.com."  # DO NOT FORGET TO INCLUDE "." AT THE END FOR ALL ZONES!

  fleet_domains = toset([
    {
      behemoth = { ipv4 = data.aws_ssm_parameter.behemoth_ip.value }
    },
    {
      kraken = { ipv4 = data.aws_ssm_parameter.kraken_ip.value }
    },
    {
      leviathan = { ipv4 = data.aws_ssm_parameter.leviathan_ip.value }
    }
  ])

  home_k3s_apps = toset([
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
resource "dns_a_record_set" "k3s_apps_host_records" {
  for_each = local.home_k3s_apps
  name     = each.value
  zone     = local.home_domain

  addresses = [
    data.aws_ssm_parameter.k3s_controller_ip.value,
    data.aws_ssm_parameter.k3s_agent1_ip.value,
    data.aws_ssm_parameter.k3s_agent2_ip.value
  ]

  ttl = 300
}