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
  # Get the list of keys in order
  flux_keys = keys(local.flux_conf)

  # Build a map of key -> list of dependency keys (simulate sequence)
  flux_depends_on = {
    for i, key in local.flux_keys :
    key => i == 0 ? [] : [local.flux_keys[i - 1]]
  }
}