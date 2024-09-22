# Proxmox Packer Images
___

This will create a base image.

Current list of images being created.

|      OS      | Version |
|:------------:|:-------:|
| Oracle Linux |   9.4   |


## Prerequistes:
- Install [Packer](https://developer.hashicorp.com/packer/install?ajs_aid=3da421b7-6e02-4a1e-a381-e2ee45cf2437&product_intent=packer)

## Create a Vars File
Create a `vars.pkr.hcl` file and write in entries for proxmox user and password and ssh user and pass if required.

example vars.pkr.hcl
```
password      = <PROXMOX_PASSWORD>
proxmox_url   = "https://<YOUR_PROXMOX_URL>"
username      = "<PROXMOX_USER>"
ssh_username  = "<SSH_USER>"
ssh_password  = "<SSH_PASS>"
template_name = "<TEMPLATE_NAME>"
```

## Create Image:
```shell
task packer-ol-build
```