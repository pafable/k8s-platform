# Atlantis Proof of Concept

This repository contains the code for the Atlantis Proof of Concept. 
Atlantis is a tool that allows you to manage your Terraform workflows via Pull Requests. 
Atlantis is a self-hosted application that listens for webhooks from your Git provider (GitHub) and executes Terraform commands in response.

A side objective of this proof on concept is to learn how Nginx Ingress works. I deployed Atlantis and Ghost to the cluster and expose them to the internet by using nginx ingress.

I created/deployed the following:

- Nginx Ingress Controller
- Ingress resource


## Requirements
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Launch kubernetes from Docker Desktop
- Install [Taskfile CLI](https://taskfile.dev/installation/)
- Create an account at [Ngrok](https://ngrok.com/) and get your authtoken


## Setup
Create a `terraform.tfvars` file in the `terraform/atlantis` directory and add the following entries:
```shell
atlantis_domain  = "YOUR_ATLANTIS_DOMAIN_NAME"
ghost-domain     = "YOU_GHOST_DOMAIN_NAME"
eks_cluster_name = "YOUR_EKS_CLUSTER_NAME"
github_user      = "YOUR_GITHUB_USERNAME"
ngrok_endpoint   = "YOUR_NGROK_ENDPOINT"
```
In Github repo, create an actions secret for the github token and webhook secret using the following names:
- GH_TOKEN
- GH_WEBHOOK_SECRET


## GITHUB ACTIONS DEPLOYMENT
This deployment method is intended to deploy to AWS using an EKS cluster.
1. Navigate to Actions and run the `Create Dev EKS Cluster` workflow/pipeline. (wait until this completes successfully)
2. Once `Create Dev EKS Cluster` has completed successfully, run `Create Dev Atlantis` pipeline.


## Access UI
Open your browser and go to `atlantis.pafable.com`.

You will need to edit Route 53 entry in the prod account to use the ELB created by the ingress nginx controller. 


## MANUAL DEPLOYMENT (FOR LOCAL TESTING ONLY)
## Deploy Atlantis
```shell
task create-atlantis
```


## Create an Ngrok Edge 
Log into the Ngrok dashboard and go into the Cloud Edge section. Create a new edge and copy the command to start a new tunnel.


It will look something like this:
```shell
ngrok tunnel --label edge=xxxxxxxxxxxxxxxxxxxxxxxxx http://localhost:80
```

Replace the port number (`80`) with `30000`.

Replace this [line](https://github.com/pafable/atlantis-poc/blob/master/Taskfile.yml#L31) with yours.

## Access Atlantis UI
Open your browser and navigate to `http://localhost:30000`


## Test Atlantis
Create a PR in your repo and it should trigger Atlantis automatically.

If it does not try creating a comment with the text `atlantis plan`


## Create
```shell
task create-atlantis
```

## Destroy
```shell
task destroy-atlantis
```

## Generating a self-signed certificate
```shell
openssl genrsa -des3 -out CAPrivate.key 2048


openssl req -x509 -new -nodes -key CAPrivate.key -sha256 -days 365 -out CAPrivate.pem


openssl genrsa -out MyPrivate.key 2048


openssl req -new -key MyPrivate.key -out MyRequest.csr


openssl x509 -req -in MyRequest.csr -CA CAPrivate.pem -CAkey CAPrivate.key -CAcreateserial -extfile openssl.ss.cnf -out MyCert.crt -days 365 -sha256


kubectl create secret tls my-tls-secret \
  --key MyPrivate.key \
  --cert MyCert.crt \
  --namespace atlantis
```