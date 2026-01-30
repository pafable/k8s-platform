module "jellyfin" {
  source = "../modules/jellyfin"
  controller_ips = [
    "10.0.50.71",
    "10.0.50.244"
  ]
}