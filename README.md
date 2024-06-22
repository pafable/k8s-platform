# K8S Platform
___

This serves all the necessary apps to bootstrap a kubernetes cluster. At the moment this will only deploy to a local k8s cluster running on Docker Desktop.

### Apps to be deployed onto a cluster
1. [Argo CD](https://argo-cd.readthedocs.io/en/stable/)
2. [Cert Manager](https://cert-manager.io/)
3. [Chaos Mesh](https://chaos-mesh.org/)
4. [Kong Ingress Controller](https://docs.konghq.com/kubernetes-ingress-controller/latest/)
5. [Kube-Prometheus-Stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
6. [Metric Server](https://github.com/kubernetes-sigs/metrics-server)
7. [Postgresql](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
8. [Pgadmin4](https://hub.docker.com/r/dpage/pgadmin4/)
9. [Trivy Operator](https://github.com/aquasecurity/trivy-operator)

### Prerequisites
You will need the following installed on your machine before deploying:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Kubernetes cluster](https://docs.docker.com/desktop/kubernetes/) created from Docker Desktop 
- [Taskfile](https://taskfile.dev/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://developer.hashicorp.com/terraform/install)

### Deploy
```shell
task create-apps-local
```

In order to access apps without port forwarding, you will need to add the following to your hosts file:
```shell
127.0.0.1  argocd.local
127.0.0.1  chaos.local
127.0.0.1  grafana.local
127.0.0.1  myhelmapp.dev.local
127.0.0.1  my-helm-chart.dev.local
127.0.0.1  pgadmin.local
127.0.0.1  prometheus.local
```

### Destroy
```shell
task destroy-apps-local
```
