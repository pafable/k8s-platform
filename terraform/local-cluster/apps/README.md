# Kube Apps
___
### Pre-requisites
CRDs must be installed before running terraform.

__Cert-Manager CRD, v1.15.0__

This is needed because cert-manager crd is needed to create issuer.
```shell
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.crds.yaml 
```


__Gateway-API CRD, v1.0.0__

This is needed because gateway crd is needed to create kong-ingress and kong-mesh
```shell
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
```

__Argocd CRDs__
```shell
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/application-crd.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/applicationset-crd.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/appproject-crd.yaml
```

## Resources that will be deployed

### 1. ArgoCD
https://argo-cd.readthedocs.io/en/stable/

### 2. Cert Manager

[Cert-manager](https://cert-manager.io/) will be deployed in a local Kubernetes cluster. To deploy to AWS use the module in `terraform/aws-cluster/cert-manager`.

Then create a certificate object like this [cert.tf](..%2F..%2Fmodules%2Fchaos-mesh%2Fcert.tf). 

Next in your ingress object, reference the certificate like this [ingress.tf](..%2F..%2Fmodules%2Fchaos-mesh%2Fingress.tf):
```terraform
    tls {
      hosts       = [local.domain_name]
      secret_name = kubernetes_manifest.cert.manifest.spec.secretName
    }
```

### 3. Chaos Mesh
https://chaos-mesh.org/

### 4. Kong Ingress
https://docs.konghq.com/kubernetes-ingress-controller/latest/

### 5. Kubernetes Prometheus Stack
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

### 6. Metrics Server
https://github.com/kubernetes-sigs/metrics-server

### 7. Postgresql and PgAdmin 4
https://charts.bitnami.com/bitnami  
https://hub.docker.com/r/dpage/pgadmin4/

### 8. Trivy Operator
https://github.com/aquasecurity/trivy-operator