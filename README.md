# K8S Platform
___

This serves all of the necessary apps to bootstrap a kubernetes cluster. At the moment this will only deploy to a local k8s cluster running on Docker Desktop.

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
- Docker Desktop
- A [kubernetes cluster](https://docs.docker.com/desktop/kubernetes/) created from Docker Desktop 

### Deploy
```shell
task create-apps-local
```

### Destroy
```shell
task destroy-apps-local
```
