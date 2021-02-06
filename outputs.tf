output "deploy_namespace" {
  value = data.kubernetes_secret.deploy.data.namespace
}

output "deploy_ca_certifiate" {
  value = data.kubernetes_secret.deploy.data["ca.crt"]
}

output "deploy_token" {
  value = data.kubernetes_secret.deploy.data.token
  sensitive = true
}
