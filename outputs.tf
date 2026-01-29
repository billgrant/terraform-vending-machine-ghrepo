
output "development_repository" {
  value = github_repository.development.html_url
}

output "production_repository" {
  value = github_repository.production.html_url
}
