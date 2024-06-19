output "manager_token" {
  value = nonsensitive(kubernetes_token_request_v1.manager_token.token)
}