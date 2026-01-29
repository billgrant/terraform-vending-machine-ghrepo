resource "github_repository" "development" {
  name        = "${var.service_name}-dev"
  description = "Development repository for ${var.service_name}"
  visibility  = "public"
  template {
    owner                = var.gh_owner
    repository           = var.gh_template_repository
    include_all_branches = true
  }
}

resource "github_repository" "production" {
  name        = "${var.service_name}-prod"
  description = "Production repository for ${var.service_name}"
  visibility  = "public"
  template {
    owner                = var.gh_owner
    repository           = var.gh_template_repository
    include_all_branches = true
  }
}