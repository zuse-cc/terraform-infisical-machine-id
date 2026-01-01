terraform {
  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.15"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
