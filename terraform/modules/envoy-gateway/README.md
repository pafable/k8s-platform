# Envoy Gateway

See this on how to install
https://gateway.envoyproxy.io/docs/install/install-helm/

### Install Command
```commandline
helm install envoy oci://docker.io/envoyproxy/gateway-helm --version v1.6.1 -n envoy-gateway-system --create-namespace
```