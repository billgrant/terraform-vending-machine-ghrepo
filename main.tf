terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8.1"
    }
  }
}

provider "github" { }

resource "random_integer" "suffix" {
  min = 100
  max = 199
}