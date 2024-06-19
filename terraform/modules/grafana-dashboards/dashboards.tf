resource "grafana_folder" "test_folder" {
  title = "Customer 360 Overview"
}

resource "grafana_dashboard" "test" {
  folder      = grafana_folder.test_folder.uid
  config_json = file("${path.module}/config/usage.json")
}