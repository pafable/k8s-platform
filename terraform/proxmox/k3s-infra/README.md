# Proxmox Infrastructure

This will provision 3 instances for k3s usage. Make sure you have templates ready to go, if not go [here](../../../packer/proxmox) and deploy the images using packer.

## Prerequisites:
- Install [terraform](https://developer.hashicorp.com/terraform/install?ajs_aid=9107845d-e793-48fe-bf86-2f230db535f1&product_intent=terraform)

## Deploy Infra:
```shell
task proxmox-infra-create
```