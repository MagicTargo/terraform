terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
}