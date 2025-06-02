locals {
  flux_conf = {
    bootstrap = {
      git_repo_url       = "https://github.com/MagicTargo/FirstRepo.git"
      kustomization_path = join("/", ["clusters", "dev", "bootstrap"])
    }
    core = {
      git_repo_url       = "https://github.com/MagicTargo/FirstRepo.git"
      kustomization_path = join("/", ["clusters", "stg", "main"])
    }
  }
}