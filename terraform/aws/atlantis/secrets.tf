resource "kubernetes_secret_v1" "github_token" {
  metadata {
    name      = "github-token"
    namespace = kubernetes_namespace_v1.atlantis_namespace.id
  }

  data = {
    user  = var.github_user
    token = var.github_token
  }

  type = "Opaque"
}

resource "kubernetes_secret_v1" "github_webhook_secret" {
  metadata {
    name      = "github-webhook-secret"
    namespace = kubernetes_namespace_v1.atlantis_namespace.id
  }

  data = {
    secret = var.github_webhook_secret
  }

  type = "Opaque"
}

# creates secret for tls certificate used by atlantis.YOUR_DOMAIN.com
resource "kubernetes_secret_v1" "atlantis_tls_secret" {
  metadata {
    name      = "atlantis-tls-secret"
    namespace = kubernetes_namespace_v1.atlantis_namespace.id
  }

  data = {
    "tls.crt" = file("${path.module}/certs/atlantis/cert.crt")
    "tls.key" = file("${path.module}/certs/atlantis/private.key")
  }

  type = "kubernetes.io/tls"
}