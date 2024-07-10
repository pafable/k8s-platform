# EKS

Creates an EKS cluster to deploy applications on.

## Create
```shell
task create-eks
```

## Destroy
```shell
task destroy-eks
```

## Common Errors
If you get this error, this is because you're using an SSO user. Create a non-sso user and try again. 
```shell
│ Error: creating EKS Access Entry (xyz:arn:aws:iam::1234567890:role/aws-reserved/sso.amazonaws.com/us-east-1/AWSReservedSSO_SomeThing): operation error EKS: CreateAccessEntry, https response error StatusCode: 409, RequestID: 67afd519-0cfa-4176-b005-82461fe17a06, ResourceInUseException: The specified access entry resource is already in use on this cluster.
│ 
│   with module.eks.aws_eks_access_entry.this["sso_users"],
│   on .terraform/modules/eks/main.tf line 185, in resource "aws_eks_access_entry" "this":
│  185: resource "aws_eks_access_entry" "this" {
```