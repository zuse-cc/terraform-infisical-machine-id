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

variable "access_token_ttl" {
  description = "Access token time to live in seconds. Default is 30 days."
  type        = number
  default     = 2592000
}

variable "projects" {
  description = "Projects to assign the machine id to"
  default     = []

  type = list(object({
    id   = string
    role = optional(string, "viewer")
  }))
}

variable "token_num_uses_limit" {
  description = "Number of API calls the access token can be used for (leave empty for no limit)"
  default     = null
}
