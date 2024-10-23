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
Create a `roc-vars.pkr.hcl` for Rocky Linux and `orc-vars.pkr.hcl` for Oracle Linux. File and write in entries for proxmox user and password and ssh user and pass if required.

example vars.pkr.hcl
```
http_directory       = "<DIRECTORY FOR KICKSTART FILES>"
iso_name             = "<ISO NAME>"
proxmox_node         = "<PROXMOX_NODE>"
proxmox_token        = "<PROXMOX_TOKEN>"
proxmox_url          = "https://<YOUR_PROXMOX_URL>"
proxmox_username     = "<PROXMOX_USER_OR_TOKEN_ID>"
ssh_password         = "<SSH_PASS>"
ssh_username         = "<SSH_USER>"
template_description = "<SOME DESCRIPTION>"
template_name        = "<TEMPLATE_NAME>"
```

## Create Oracle Linux Image:
```shell
task packer-ol-build
```

## Create Rocky Linux Image:
```shell
task packer-rl-build
```
