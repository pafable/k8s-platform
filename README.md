# K8S Platform
___

## Automated Deployment 
This is the preferred deployment method!

To deploy use this [pipeline](.github%2Fworkflows%2Fcreate-dev-eks.yml).

## Manual Deployment
Deploy the following in this orders:
1. eks
2. kube-support
3. karpenter-manifests
4. monitoring
5. atlantis
6. Update DNS

### Deployment Commands
**Create Everything**
```shell
task create-all
```

**Individual commands**
1. VPC
```shell
task create-vpc
```

2. EKS
```shell
task create-eks
```

3. Kubernetes Support
```shell
task create-kube-support
```

4. Monitoring
```shell
task create-monitoring
```

5. Atlantis
```shell
task create-atlantis
```

6. Update DNS
This will require using cli creds for dev and prod

Use dev creds to retrieve the alb DNS name.
```shell
task retrieve-elb
```

Use prod creds to update DNS in the prod account.
```shell
task create-dns
```

Create Chaos Mesh
```shell
task create-chaos-mesh
```

**Destroy Everything**
```shell
task destroy-all
```

**Create an EKS Cluster**
This will create anything inside eks, kube-support, and monitoring folders.
```shell
task create-cluster
```