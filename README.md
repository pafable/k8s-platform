# K8S Platform
___

This serves all the necessary apps to bootstrap a kubernetes cluster. At the moment this will only deploy to a local k8s cluster running on Docker Desktop.

### Apps to be deployed onto a cluster
1. ArgoCD
2. Cert Manager
3. Chaos Mesh
4. Kong Ingress
5. Kube Prometheus Stack
6. Metric Server
7. Postgresql
8. Pgadmin4
9. Trivy Operator
   
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

```shell

### Destroy
```shell
task destroy-apps-local
```
