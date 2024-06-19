resource "github_repository_webhook" "gh_webhook" {
  configuration {
    content_type = local.content_type
    insecure_ssl = local.insecure_ssl
    secret       = var.github_webhook_secret
    url          = "https://${var.atlantis_domain}/events" # change this to ngrok_endpoint, if you are using ngrok
  }
  events     = var.github_webhook_events
  repository = var.github_repo
}