variable "stage" {
  description = "Deployment stage"
  type        = string
}

variable "service" {
  description = "Service name"
  type        = string
}

variable "org_id" {
  type = string
}

variable "org_role" {
  type    = string
  default = "member"
}

variable "project_slug" {
  type = string
}

variable "role_slug" {
  type    = string
  default = "viewer"
}

variable "access_token_ttl" {
  description = "Access token time to live in seconds. Default is 30 days."
  type        = number
  default     = 2592000
}
