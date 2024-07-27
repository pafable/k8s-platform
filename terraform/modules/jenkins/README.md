# Jenkins

This uses a helm chart to deploy jenkins on a kubernetes cluster.
It uses this [chart](https://github.com/jenkinsci/helm-charts).

### Adding Credentials
Store credentials in AWS SSM Parameter Store and feed it into jcasc.
see [main.tf](..%2F..%2Flocal-cluster%2Fapps%2Fmain.tf) & [jcasc.tf](jcasc.tf)