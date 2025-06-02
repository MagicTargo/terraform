locals {
  flux_conf = {
    app1 = {
      git_repo_url       = "https://github.com/MagicTargo/terraform.git"
      kustomization_path = join("/", ["clusters", "dev", "app1"])
    }
    app2 = {
      git_repo_url       = "https://github.com/MagicTargo/terraform.git"
      kustomization_path = join("/", ["clusters", "dev", "app2"])
    }
    app3 = {
      git_repo_url       = "https://github.com/MagicTargo/FirstRepo.git"
      kustomization_path = join("/", ["clusters", "dev", "app3"])
    }
    app4 = {
      git_repo_url       = "https://github.com/MagicTargo/FirstRepo.git"
      kustomization_path = join("/", ["clusters", "stg", "app4"])
    }
  }
}