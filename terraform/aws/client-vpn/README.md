# Client VPN

Setup AWS Client VPN to interact with EKS cluster securely.

## Prerequisites
Generate server and client certificates and keys using [EasyRSA](https://github.com/OpenVPN/easy-rsa).


AWS Instructions to generate keys and certificates: https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/mutual.html


Manually upload server's private key and CA cert to AWS Parameter Store. This will be used along with [server.crt](cert%2Fserver.crt) during the import of the cert into ACM.

## Create Client VPN Endpoint
```bash
task create-vpn
```

## Destroy Client VPN Endpoint
```bash
task destroy-vpn
```