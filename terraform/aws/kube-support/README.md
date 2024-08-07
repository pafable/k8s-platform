# Kube Support
Install and configures applications needed to support a Kubernetes cluster.

Software that will be installed:
- [Ingress Nginx](https://kubernetes.github.io/ingress-nginx/) - needed for services living on the cluster to be accessible from the internet. If deploying in AWS a load balancer will be automatically created and will be the entrypoint for the service's UI.
- [Kong Ingress Controller](https://docs.konghq.com/kubernetes-ingress-controller/latest/get-started/) - Alternative to Ingress Nginx this will be installed along with Ingress Nginx.

## Create
```shell
task create-kube-support
```

## Destroy
```shell
task destroy-kube-support
```