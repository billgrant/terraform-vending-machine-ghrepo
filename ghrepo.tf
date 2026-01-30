resource "github_repository" "development" {
  name        = "${var.service_name}-dev"
  description = "Development repository for ${var.service_name}"
  visibility  = var.visibility
  template {
    owner                = var.gh_owner
    repository           = var.gh_template_repository
    include_all_branches = true
  }
}

resource "github_repository" "production" {
  name        = "${var.service_name}-prod"
  description = "Production repository for ${var.service_name}"
  visibility  = var.visibility
  template {
    owner                = var.gh_owner
    repository           = var.gh_template_repository
    include_all_branches = true
  }
}

resource "github_actions_secret" "tfc_token_dev" {
  repository      = github_repository.development.name
  secret_name     = "TFC_TOKEN"
  plaintext_value = var.tfc_token
}

resource "github_actions_secret" "tfc_token_prod" {
  repository      = github_repository.production.name
  secret_name     = "TFC_TOKEN"
  plaintext_value = var.tfc_token
}
