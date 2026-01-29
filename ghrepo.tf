resource "github_repository" "development" {
  name        = "${var.service_name}-dev-${random_integer.suffix.result}"
  description = "Development repository for ${var.service_name}"
  visibility  = "public"
  template {
    owner                = var.gh_owner
    repository           = var.gh_template_repository
    include_all_branches = true
  }
}

# resource "github_branch" "cli" {
#   repository = github_repository.development.name
#   branch     = "cli"
# }

resource "github_repository" "production" {
  name        = "${var.service_name}-prod-${random_integer.suffix.result}"
  description = "Production repository for ${var.service_name}"
  visibility  = "public"
  template {
    owner                = var.gh_owner
    repository           = var.gh_template_repository
    include_all_branches = true
  }
}