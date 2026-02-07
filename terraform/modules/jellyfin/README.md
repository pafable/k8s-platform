# Jellyfin on Kubernetes
Deploys [Jellyfin](https://jellyfin.org/) on a kubernetes cluster. Uses the [jellyfin container image](https://hub.docker.com/r/jellyfin/jellyfin).

This implementation uses an NFS share to store media content for Jellyfin and retain config and cache data. Designed with K3S and Talos in mind. 

## Prerequisites
- Gateway API controller (I'm using Envoy Gateway)
- NFS server
- Worker node with 8gb of memory and 4 core CPU

## Creating the tfvars file
Create a tfvars file that contains the follwing.
```commandline
config_path          = "/path/to/kubeconfig/file"
config_context       = "KUBERNETES CONTEXT TO USE"
controller_ips       = ["IP OF CONTROLLER(S)"]
domain               = "YOUR URL"
jellyfin_cache_path  = "/path/to/jellyfin/cache/on/nfs"
jellyfin_config_path = "/path/to/jellyfin/config/on/nfs"
jellyfin_media_path  = "/path/to/jellyfin/media/on/nfs"
nfs_ipv4             = "IP OF NFS SERVER"
node_name            = "NAME K8S NODE TO RUN JELLYFIN POD"
```

## Deploying to a kubernetes cluster
```commandline
terraform init
```

```commandline
terraform apply -var-file <YOUR_VARS_FILE>.tfvars
```

Once you have successfully deployed to your kubernetes cluster. Point your jellyfin domain name specified in the tfvars file to the IP of your k8s controller. 
You can also edit your client's host file to resolve the domain name to the controller's IP if making DNS entries is not possible.

## Removing from a kubernetes cluster
```commandline
terraform destroy -var-file <YOUR_VARS_FILE>.tfvars
```