# Proxmox Packer Images
___

This will create a base image.

Current list of images being created.

|      OS      | Version |
|:------------:|:-------:|
| Oracle Linux |   9.4   |
| Rocky Linux  |   9.4   |


## Prerequistes:
- Install [Packer](https://developer.hashicorp.com/packer/install?ajs_aid=3da421b7-6e02-4a1e-a381-e2ee45cf2437&product_intent=packer)
- Add ISOs into your Proxmox server.

## Create a Vars File
Create a `vars.pkr.hcl` file and write in entries for proxmox user and password and ssh user and pass if required.

example vars.pkr.hcl
```
proxmox_password = "<PROXMOX_PASSWORD>"
proxmox_url      = "https://<YOUR_PROXMOX_URL>"
proxmox_username = "<PROXMOX_USER>"
ssh_password     = "<SSH_PASS>"
ssh_username     = "<SSH_USER>"
template_name    = "<TEMPLATE_NAME>"
```

## Create Oracle Linux Image:
```shell
task packer-ol-build
```

## Create Rocky Linux Image:
```shell
task packer-rl-build
```
