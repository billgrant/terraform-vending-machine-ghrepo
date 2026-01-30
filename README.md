# GitHub Repository Vending Machine

A reusable Terraform module for HCP Terraform (No-Code) that automatically provisions paired development and production GitHub repositories from a template repository.

## Overview

This module is designed as a **No-Code module for HCP Terraform**, enabling teams to provision GitHub repositories through the HCP Terraform UI without writing any Terraform code. It creates two public GitHub repositories (development and production) for a given service, automatically bootstrapping them from a template repository. The module also configures GitHub Actions secrets for HCP Terraform integration.

## Features

- **No-Code Provisioning**: Use HCP Terraform UI to provision repositories without writing Terraform
- **Automated Repository Creation**: Provisions both dev and prod repositories in a single workspace run
- **Template-Based**: Clones all branches from a specified template repository
- **Public Repositories**: Both repositories are created as public by default
- **Consistent Naming**: Uses a predictable naming pattern: `{service-name}-{env}`
- **GitHub Actions Integration**: Automatically configures TFC_TOKEN secret for HCP Terraform workflows
- **Workflow Automation**: Triggers update-readme.yml workflow after repository creation
- **HCP Terraform Native**: Designed for integration with HCP Terraform's module registry

## Requirements

- Terraform >= 1.0
- GitHub provider ~> 6.10.0

## Usage

### In HCP Terraform (No-Code)

1. **Add this module to your organization's Private Registry**:
   - Navigate to **Registry** → **Modules** in HCP Terraform
   - Click **Publish** → **Module**
   - Connect this GitHub repository
   - Tag version and publish

2. **Create a Workspace from this Module**:
   - Navigate to **Registry** → **Modules**
   - Find **GitHub Repository Vending Machine**
   - Click **Create workspace**

3. **Configure Module Variables** (via UI):
   - `service_name`: Name of your service (e.g., "api-gateway")
   - `gh_owner`: GitHub organization name
   - `gh_template_repository`: Template repo name to clone from
   - `tfc_token`: HCP Terraform API token for GitHub Actions integration (set as sensitive variable)

4. **Apply**:
   - Click **Create and apply** in the UI
   - HCP Terraform provisions your repositories automatically

### Terraform Code (Reference)

For reference, the module can also be used in code-based workflows:

```hcl
module "github_repos" {
  source  = "app.terraform.io/YOUR-ORG/github-repo-vending-machine/github"
  version = "~> 1.0"

  service_name           = "my-service"
  gh_owner               = "my-github-org"
  gh_template_repository = "my-template-repo"
  tfc_token              = var.tfc_token
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `service_name` | The name of the service being deployed | `string` | | yes |
| `gh_owner` | GitHub owner (user or organization) for the repository | `string` | `""` | no |
| `gh_template_repository` | GitHub template repository to use for the new repository | `string` | | yes |
| `tfc_token` | HCP Terraform API token for GitHub Actions integration | `string` | | yes |

### Required Environment Variables

The `GITHUB_TOKEN` environment variable must be set for GitHub provider authentication:

```bash
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
```

## Outputs

| Name | Description |
|------|-------------|
| `development_repository` | The HTTPS URL of the development repository |
| `production_repository` | The HTTPS URL of the production repository |

## Example Outputs

```
development_repository = "https://github.com/my-org/my-service-dev"
production_repository = "https://github.com/my-org/my-service-prod"
```

## How It Works

1. **Development Repository**: Created with name pattern `{service_name}-dev` from the template
2. **Production Repository**: Created with name pattern `{service_name}-prod` from the template
3. **Template Cloning**: All branches from the template repository are included in the new repositories
4. **GitHub Actions Secrets**: TFC_TOKEN secret is automatically configured in both repositories
5. **Workflow Trigger**: The update-readme.yml workflow is triggered in both repositories after creation

## Prerequisites

1. **HCP Terraform Account**: Organization with appropriate permissions
2. **GitHub Personal Access Token**: With `repo` and `admin:repo_hook` scopes (set as GITHUB_TOKEN environment variable)
3. **HCP Terraform API Token**: For GitHub Actions integration (set as tfc_token variable)
4. **Existing Template Repository**: A GitHub repository to clone from with update-readme.yml workflow
5. **GitHub App or Token**: Configured with HCP Terraform for VCS integration (optional, for automatic runs)

## Example

### In HCP Terraform UI

1. Search for "GitHub Repository Vending Machine" in Private Registry
2. Click **Create workspace**
3. Fill in the variables:
   - **service_name**: `api-gateway`
   - **gh_owner**: `my-organization`
   - **gh_template_repository**: `service-template`
   - **tfc_token**: `your-hcp-terraform-api-token` (marked as sensitive)
4. Click **Create and apply**

This will create:
- `api-gateway-dev` - Development repository
- `api-gateway-prod` - Production repository

Both repositories are initialized with all branches from `my-organization/service-template` and configured with TFC_TOKEN secret.

### Output

After the run completes successfully:
- **development_repository**: `https://github.com/my-org/api-gateway-dev`
- **production_repository**: `https://github.com/my-org/api-gateway-prod`

Copy these URLs to access your new repositories. Both repositories will have the TFC_TOKEN secret configured and the update-readme.yml workflow will be triggered automatically.

## Cleanup

To destroy the created repositories using HCP Terraform:

1. Navigate to your workspace in HCP Terraform
2. Click **Destroy** and confirm
3. HCP Terraform will remove both development and production repositories

Alternatively, if using Terraform CLI:

```bash
terraform destroy
```

## Notes

- **No Terraform Code Required**: Team members provision repositories using the HCP Terraform UI
- Repository names follow the pattern `{service_name}-dev` and `{service_name}-prod`
- Both repositories are created as **public** by default
- The template repository's all branches are included in the new repositories
- **Sensitive Variables**: TFC token must be marked as sensitive in the workspace
- **GitHub Actions Integration**: TFC_TOKEN secret is automatically configured for workflow integration
- **Workflow Automation**: The update-readme.yml workflow is triggered after repository creation
- **Environment Variables**: GITHUB_TOKEN must be set for provider authentication
- **Destroy Protection**: Consider enabling destroy protection in HCP Terraform to prevent accidental deletion

## HCP Terraform Setup Guide

### Publishing the Module

1. Create a GitHub repository: `terraform-hcp-github-repo-vending-machine`
2. Push this code to the repository
3. In HCP Terraform:
   - Go to **Registry** → **Modules** → **Publish**
   - Select **GitHub** as the VCS
   - Select the repository
   - Choose version tag (e.g., `v1.0.0`)
   - Click **Publish module**

### Using the Module

1. Go to **Registry** → **Modules**
2. Search for "github-repo-vending-machine"
3. Click on the module
4. Click **Create workspace**
5. HCP Terraform will create a workspace pre-configured to use this module
6. Set the required variables and apply

### Setting Required Tokens

For security, always use **sensitive variables** and **environment variables**:

**HCP Terraform API Token (Variable):**
1. In the workspace, go to **Variables**
2. Click **Add variable**
3. Name: `tfc_token`
4. Value: Your HCP Terraform API token
5. **Check "Sensitive"** to prevent display in logs
6. Save

**GitHub Token (Environment Variable):**
1. In the workspace, go to **Variables**
2. Click **Add variable**
3. Select **Environment variable**
4. Name: `GITHUB_TOKEN`
5. Value: Your GitHub PAT
6. **Check "Sensitive"** to prevent display in logs
7. Save

## Support

For issues or questions about using this module in HCP Terraform, refer to:
- [HCP Terraform Documentation](https://developer.hashicorp.com/terraform/cloud-docs)
- [GitHub Terraform Provider Documentation](https://registry.terraform.io/providers/integrations/github/latest/docs)
