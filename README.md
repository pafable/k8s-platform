# K8S Platform
___

This serves all the necessary apps to bootstrap a kubernetes cluster.

### Apps to be deployed onto a cluster
1. [Argo CD](https://argo-cd.readthedocs.io/en/stable/)
2. [Cert Manager](https://cert-manager.io/)
3. [Chaos Mesh](https://chaos-mesh.org/)
5. [Kube-Prometheus-Stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
6. [Metric Server](https://github.com/kubernetes-sigs/metrics-server)
7. [Postgresql](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
8. [Pgadmin4](https://hub.docker.com/r/dpage/pgadmin4/)
9. [Trivy Operator](https://github.com/aquasecurity/trivy-operator)
10. [Jenkins](https://github.com/jenkinsci/helm-charts)
11. [Vault](https://developer.hashicorp.com/vault/docs/platform/k8s/helm)
12. [Envoy Gateway](https://gateway.envoyproxy.io/)
13. [MetalLB](https://metallb.io/)

### Prerequisites
You will need the following installed on your machine before deploying:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Talos](https://www.talos.dev/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Kubernetes cluster](https://docs.docker.com/desktop/kubernetes/) created from Docker Desktop
- [Packer](https://developer.hashicorp.com/packer/install?ajs_aid=e65b25ce-401d-4cf0-bb32-ebafbd96b908&product_intent=packer)
- [Podman](https://podman.io/)
- [Proxmox](https://www.proxmox.com/en/)
- [Taskfile](https://taskfile.dev/)
- [Terraform](https://developer.hashicorp.com/terraform/install)

---
## Local K8S Cluster
This deploys a kubernetes cluster to either k3s or talos.

## Cloud K8S Cluster
Creates a kubernetes cluster using AWS EKS.

---
## AWS EKS
Deploy an [EKS](https://aws.amazon.com/eks/) cluster on AWS.
### Deploy
```shell
task create-cluster
```

### Destroy
```shell
task destroy-cluster
```

---
## Creating Proxmox Images
See [proxmox readme](packer/proxmox/README.md).

___
## Creating K3S Cluster
This requires a Proxmox environment.

### Create
```shell
task k3s-infra-create
```

### Destroy
```shell
task k3s-infra-destroy
```

---
## Creating Talos Cluster
### Create
```shell
task talos-create
```

### Destroy
```shell
task talos-destroy
```
