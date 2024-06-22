locals {
  argo_labels = {
    "app.kubernetes.io/name"       = "argo-example-app"
    "app.kubernetes.io/owner"      = var.owner
    "app.kubernetes.io/managed-by" = "ArgoCD"
  }
}

# argo example app
resource "kubernetes_manifest" "argo_example_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name      = "argo-example-app-dev"
      namespace = local.app_name
      labels    = local.argo_labels
    }

    spec = {
      destination = {
        namespace = "argo-example-app"
        server    = "https://kubernetes.default.svc"
      }

      source = {
        path           = "helm-webapp"
        repoURL        = "https://github.com/pafable/argo-examples"
        targetRevision = "HEAD"

        helm = {
          valueFiles = [
            "values-dev.yaml"
          ]
        }
      }

      sources = []
      project = "default"

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = false
        }

        syncOptions = [
          "CreateNamespace=true",
          "PruneLast=true",
          "Replace=true"
        ]

        retry = {
          limit = 3
          backoff = {
            duration    = "5s"
            maxDuration = "3m"
            factor      = 2
          }
        }
      }
    }
  }
}

# my app
resource "kubernetes_manifest" "my_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name      = "my-app-dev"
      namespace = local.app_name
      labels    = local.argo_labels
    }

    spec = {
      destination = {
        namespace = "my-app-dev"
        server    = "https://kubernetes.default.svc"
      }

      source = {
        path           = "charts/my-helm-chart"
        repoURL        = "https://github.com/pafable/argo-examples"
        targetRevision = "HEAD"

        helm = {
          valueFiles = [
            "values.yaml"
          ]
        }
      }

      sources = []
      project = "default"

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = false
        }

        syncOptions = [
          "CreateNamespace=true",
          "PruneLast=true",
          "Replace=true"
        ]

        retry = {
          limit = 3
          backoff = {
            duration    = "5s"
            maxDuration = "3m"
            factor      = 2
          }
        }
      }
    }
  }
}