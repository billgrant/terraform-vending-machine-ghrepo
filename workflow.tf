# Trigger GitHub Actions workflow after secrets are created
# This ensures the workflow runs after TFC_TOKEN is available

resource "null_resource" "trigger_workflow_dev" {
  depends_on = [github_actions_secret.tfc_token_dev]

  provisioner "local-exec" {
    command = <<-EOT
      curl -s -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/${var.gh_owner}/${github_repository.development.name}/actions/workflows/update-readme.yml/dispatches" \
        -d '{"ref":"main"}'
    EOT
  }
}

resource "null_resource" "trigger_workflow_prod" {
  depends_on = [github_actions_secret.tfc_token_prod]

  provisioner "local-exec" {
    command = <<-EOT
      curl -s -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/${var.gh_owner}/${github_repository.production.name}/actions/workflows/update-readme.yml/dispatches" \
        -d '{"ref":"main"}'
    EOT
  }
}
