locals {
  suffix = random_string.suffix.result
  name   = "${var.stage}-${var.service}-${local.suffix}"
}

resource "random_string" "suffix" {
  length  = 3
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "infisical_identity" "i" {
  name   = local.name
  role   = var.org_role
  org_id = var.org_id

  metadata = [
    {
      key   = "service",
      value = var.service
    },
    {
      key   = "stage",
      value = var.stage
    },
    {
      key   = "managed-by",
      value = "terraform"
    }
  ]
}

resource "infisical_identity_universal_auth" "a" {
  identity_id                 = infisical_identity.i.id
  access_token_ttl            = var.access_token_ttl # 30 days
  access_token_max_ttl        = var.access_token_ttl * 2
  access_token_num_uses_limit = 3
}

resource "infisical_identity_universal_auth_client_secret" "s" {
  identity_id = infisical_identity.i.id
  depends_on  = [infisical_identity_universal_auth.a]
}

resource "infisical_project_identity" "p" {
  count       = length(var.projects)
  project_id  = var.projects[count.index].id
  identity_id = infisical_identity.i.id
  roles = [
    {
      role_slug = var.projects[count.index].role
    }
  ]
}
