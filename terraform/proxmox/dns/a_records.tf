locals {
  fleet_domain = "fleet.pafable.com." # DO NOT FORGET TO INCLUDE "." AT THE END FOR ALL ZONES!
  home_domain  = "home.pafable.com."  # DO NOT FORGET TO INCLUDE "." AT THE END FOR ALL ZONES!

  fleet_domains = toset([
    {
      ipv4 = [
        nonsensitive(data.aws_ssm_parameter.behemoth_ip.value)
      ]
      name = "behemoth"
    },
    {
      ipv4 = [
        nonsensitive(data.aws_ssm_parameter.kraken_ip.value)
      ]
      name = "kraken"
    },
    {
      ipv4 = [
        nonsensitive(data.aws_ssm_parameter.leviathan_ip.value)
      ]
      name = "leviathan"
    }
  ])

  home_k3s_apps = toset([
    "argocd",
    "grafana",
    "jenkins",
    "loki",
    "pgadmin",
    "prometheus",
    "vault"
  ])
}

# fleet domains
resource "dns_a_record_set" "fleet_domains" {
  for_each = {
    for v in local.fleet_domains : v.name => { ipv4 = v.ipv4 }
  }

  addresses = each.value.ipv4
  name      = each.key
  ttl       = 300
  zone      = local.fleet_domain
}

resource "dns_a_record_set" "hive" {
  name = "hive"
  ttl  = 300
  zone = local.fleet_domain

  addresses = [
    data.aws_ssm_parameter.behemoth_ip.value,
    data.aws_ssm_parameter.kraken_ip.value,
    data.aws_ssm_parameter.leviathan_ip.value
  ]
}

# home domains
resource "dns_a_record_set" "k3s_apps_host_records" {
  for_each = local.home_k3s_apps
  name     = each.value
  ttl      = 300
  zone     = local.home_domain

  addresses = [
    data.aws_ssm_parameter.k3s_controller_ip.value,
    data.aws_ssm_parameter.k3s_agent1_ip.value,
    data.aws_ssm_parameter.k3s_agent2_ip.value
  ]
}

# rpm server
resource "dns_a_record_set" "dnf_srv_record" {
  name = "rpm-srv"
  ttl  = 300
  zone = local.home_domain

  addresses = [
    data.aws_ssm_parameter.rpm_server_ip.value
  ]
}