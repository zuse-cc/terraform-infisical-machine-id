mock_provider "infisical" {
  override_resource {
    target = infisical_identity_universal_auth_client_secret.s
    values = {
      client_id     = "mock-client-id-123"
      client_secret = "mock-client-secret-abc"
    }
  }
}

mock_provider "random" {
  override_resource {
    target = random_string.suffix

    values = {
      result = "a7c"
    }
  }
}

variables {
  stage        = "tst"
  service      = "bucket"
  org_id       = "99d438ec-e6de-11f0-9c94-f2bb0a58e59e"
  project_slug = "t3st-pr0ject"
}

run "name_is_generated" {
  assert {
    condition     = infisical_identity.i.name == "${var.stage}-${var.service}-a7c"
    error_message = "incorrect identity name"
  }

  assert {
    condition     = infisical_identity.i.role == "member"
    error_message = "default role is not 'member'"
  }
}

run "required_metadata_is_assigned" {
  assert {
    condition     = anytrue([for i in infisical_identity.i.metadata : i["key"] == "service" && i["value"] == var.service])
    error_message = "service metadata is not set correctly"
  }

  assert {
    condition     = anytrue([for i in infisical_identity.i.metadata : i["key"] == "stage" && i["value"] == var.stage])
    error_message = "stage metadata is not set correctly"
  }

  assert {
    condition     = anytrue([for i in infisical_identity.i.metadata : i["key"] == "managed-by" && i["value"] == "terraform"])
    error_message = "managed-by metadata is not set correctly"
  }
}

run "universal_auth_is_created" {
  variables {
    access_token_ttl = 10 * 24 * 3600
  }

  assert {
    condition     = infisical_identity_universal_auth.a.identity_id == infisical_identity.i.id
    error_message = "universal auth identity_id does not match"
  }

  assert {
    condition     = infisical_identity_universal_auth.a.access_token_ttl == 10 * 24 * 3600 # 30 days
    error_message = "access_token_ttl is incorrect"
  }

  assert {
    condition     = infisical_identity_universal_auth.a.access_token_max_ttl == 2 * 10 * 24 * 3600
    error_message = "access_token_max_ttl should be 2x access_token_ttl"
  }

  assert {
    condition     = infisical_identity_universal_auth.a.access_token_num_uses_limit == 3
    error_message = "access_token_num_uses_limit is incorrect"
  }
}

run "client_secret_is_created" {
  assert {
    condition     = output.client_id == "mock-client-id-123"
    error_message = "client_id does not match mocked value"
  }

  assert {
    condition     = output.client_secret == "mock-client-secret-abc"
    error_message = "client_secret does not match mocked value"
  }
}

run "no_project_identities_created_when_no_projects_given" {
  assert {
    condition     = length(infisical_project_identity.p) == 0
    error_message = "expected no project identities to be created when no projects are given"
  }
}

run "project_identities_created_when_projects_given" {
  variables {
    projects = [
      {
        id   = "project-1-id"
        role = "editor"
      },
      {
        id   = "project-2-id"
      }
    ]
  }

  assert {
    condition     = length(infisical_project_identity.p) == 2
    error_message = "expected 2 project identities to be created"
  }

  assert {
    condition     = infisical_project_identity.p["project-1-id"].roles[0].role_slug == "editor"
    error_message = "role for project-1-id is incorrect"
  }

  assert {
    condition     = infisical_project_identity.p["project-2-id"].roles[0].role_slug == "viewer"
    error_message = "default role for project-2-id should be 'viewer'"
  }
}
