# Proxmox Infrastructure

This will provision 3 instances for k3s usage. Make sure you have templates ready to go, if not go [here](../../../packer/proxmox) and deploy the images using packer.

## Prerequisites:
- Install [terraform](https://developer.hashicorp.com/terraform/install?ajs_aid=9107845d-e793-48fe-bf86-2f230db535f1&product_intent=terraform)
- Create Promxmox API token

## Deploy Infra:
Set Promox api token and k3s token as environment variables.
```shell
export PM_API_TOKEN_ID='<YOUR-PROXMOX-TOKEN-ID>' \
  && export PM_API_TOKEN_SECRET='<YOUR-PROXMOX-SECRET>'
```

Deploy K3S cluster
```shell
task k3s-infra-create
```

Destroy K3S cluster
Order of destroying matters. If you destroy controllers before agents, the agents will throw an error when being destroyed.
```shell
task k3s-infra-destroy
```