variable "service_name" {
  description = "The name of the service being deployed"
  type        = string
}

variable "gh_owner" {
  description = "GitHub owner for the repository"
  type        = string
  default     = ""
}

variable "gh_template_repository" {
  description = "GitHub template repository to use for the new repository"
  type        = string
}

variable "tfc_token" {
  description = "HCP Terraform API token for GitHub Actions integration"
  type        = string
  sensitive   = true
}

