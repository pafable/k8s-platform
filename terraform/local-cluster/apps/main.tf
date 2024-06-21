module "argocd" {
  source   = "../../modules/argocd"
  app_repo = "https://github.com/pafable/argo-examples"
  depends_on = [
    module.cert_manager,
    module.kong_ingress
  ]
}

module "cert_manager" {
  source = "../../modules/cert-manager"
}

module "chaos_mesh" {
  source                        = "../../modules/chaos-mesh"
  is_dashboard_security_enabled = false
}

# module "grafana_dashboards" {
#   source         = "../../modules/grafana-dashboards"
#   svc_acct_token = var.svc_acct_token
#   depends_on     = [module.kube_prom_stack]
# }

module "kong_ingress" {
  source  = "../../modules/kong-ingress"
  timeout = 500
}

# module "kong_mesh" {
#   source = "../../modules/kong-mesh"
# }

module "kube_prom_stack" {
  source   = "../../modules/kube-prom-stack"
  is_cloud = false
}

module "metrics_server" {
  source   = "../../modules/metrics-server"
  is_cloud = false
}

module "postgresql_db_01" {
  source      = "../../modules/postgresql"
  admin_email = "test100@test.local"
}

module "trivy_operator" {
  source = "../../modules/trivy-operator"
}

## this is testing how to deploy a helm chart
# resource "kubernetes_namespace_v1" "my_app_ns" {
#   metadata {
#     name = "my-app-ns"
#   }
# }
#
# resource "helm_release" "my_app" {
#   chart            = "../../../charts/my-helm-chart"
#   create_namespace = false
#   name             = "my-app"
#   namespace        = kubernetes_namespace_v1.my_app_ns.metadata.0.name
#   version          = "0.1.0"
#
#   values = [
#     yamlencode({
#       app = {
#         replicas = 2
#       }
#     })
#   ]
# }