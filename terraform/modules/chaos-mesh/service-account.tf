# admin/manager service account
resource "kubernetes_service_account_v1" "chaos_manager_service_account" {
  metadata {
    name      = "${local.app_name}-manager-service-account"
    namespace = kubernetes_namespace_v1.chaos_ns.metadata.0.name
  }
}

resource "kubernetes_role_v1" "chaos_manager_role" {
  metadata {
    name      = "${local.app_name}-manager-role"
    namespace = kubernetes_namespace_v1.chaos_ns.metadata.0.name
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["chaos-mesh.org"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "delete", "patch", "update"]
  }
}

resource "kubernetes_role_binding_v1" "chaos_manager_role_binding" {
  metadata {
    name      = "${local.app_name}-manager-role-binding"
    namespace = kubernetes_namespace_v1.chaos_ns.metadata.0.name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.chaos_manager_role.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.chaos_manager_service_account.metadata.0.name
    namespace = kubernetes_namespace_v1.chaos_ns.metadata.0.name
  }
}

resource "kubernetes_token_request_v1" "manager_token" {
  metadata {
    name      = kubernetes_service_account_v1.chaos_manager_service_account.metadata.0.name
    namespace = kubernetes_namespace_v1.chaos_ns.metadata.0.name
  }

  spec {
    expiration_seconds = 3600
  }
}