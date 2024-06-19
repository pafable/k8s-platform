# DNS Update
Updates Route 53 in Prod Account

### Apps to be added to Route 53:
- [Atlantis](atlantis.pafable.com)
- [Ghost](ghost.pafable.com)


## Usage
The EKS cluster lives in the dev environment, but DNS records are updated in the prod environment.
The [Create Dev Atlantis](..%2F..%2F.github%2Fworkflows%2Fcreate-dev-atlantis.yml) workflow is used to deploy the changes.
The [Destroy Dev Atlantis](..%2F..%2F.github%2Fworkflows%2Fdestroy-dev-atlantis.yml) workflow is used to destroy the changes.

## Create
```shell
task create-dns
```

## Destroy
```shell
task destroy-dns
```