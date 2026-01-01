output "identity_name" {
  value = infisical_identity.i.name
}

output "identity_id" {
  value = infisical_identity.i.id
}

output "client_id" {
  value = infisical_identity_universal_auth_client_secret.s.client_id
}

output "client_secret" {
  sensitive = true
  value     = infisical_identity_universal_auth_client_secret.s.client_secret
}
