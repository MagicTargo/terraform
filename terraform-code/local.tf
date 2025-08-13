locals {
  team_flux_conf = {
    team = {
      https_user_kv   = "flux-auth-username"
      https_token_kv  = "flux-auth-token"
      namespace       = "cluster-config"
      reference_type  = "branch"
      reference_value = "main"
      git_repo_url    = "https://github.com/MagicTargo/terraform.git"
      scope           = "cluster"
      kustomizations = {
        app1 = {
          path = "clusters/dev/app1"
        }
        app2 = {
          path = "clusters/dev/app2"
        }
      }
    }
  }
}