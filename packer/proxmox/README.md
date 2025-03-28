# Proxmox Packer Images
___

This will create a base image.

Current list of images being created.

|      OS      | Version |
|:------------:|:-------:|
|   Almalinux  |   9.5   |
| Oracle Linux |   9.4   |
| Rocky Linux  |   9.4   |
|    Ubuntu    | 24.04.1 | 


## Prerequistes:
- Install [Packer](https://developer.hashicorp.com/packer/install?ajs_aid=3da421b7-6e02-4a1e-a381-e2ee45cf2437&product_intent=packer)
- Add ISOs into your Proxmox server.
- Upload contents of `auto-ks` to a http server.

## Setup HTTP Server
Move `ks-srv.service` file to a server and start the service for a HTTP server. The web server can be accessed at `<ip address>:8080` on your browser.

## Create a Vars File
Create a `ubu-vars.pkr.hcl` for Ubuntu, `roc-vars.pkr.hcl` for Rocky and `orc-vars.pkr.hcl` for Oracle in the linux folder. Write in entries for proxmox user and password and ssh user and pass if required.

example vars.pkr.hcl
```
distro               = "<LINUX DISTRIBUTION>"
http_directory       = "<DIRECTORY FOR KICKSTART FILES>"
http_server          = "<HTTP SERVER THAT WILL SERVER KICKSTART OR AUTOINSTALL FILES>"
is_local             = "<SET THIS TO FALSE IF YOU'RE RUNNING AN HTTP SERVER ON A DIFFERENT MACHINE>"
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

## Create Images From Your Local Machine:
Almalinux
```shell
task packer-alma-build
```

Oracle 
```shell
task packer-oracle-build
```

Rocky
```shell
task packer-rocky-build
```

Ubuntu
```shell
task packer-ubuntu-build
```

## Create Images From Jenkins:
Execute the following pipeline: [Jenkinsfile](../../cicd/packy/Jenkinsfile)