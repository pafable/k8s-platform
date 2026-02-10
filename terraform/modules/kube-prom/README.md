# Kube Prometheus Stack
https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

Deploys kube prometheus stack.
Components deployed are:
- Prometheus
- Grafana

This is intended to be used with gateway api, prometheus is protected by a username and password.
To set the username and password create an `.htpasswd` file.
```commandline
htpasswd -bcs .htpasswd YOUR_USER YOUR_PASSWD
```