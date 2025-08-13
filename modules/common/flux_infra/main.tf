# resource "terraform_data" "check_kustomization_file" {
#   for_each = var.flux_conf

#   provisioner "local-exec" {
#     command = "bash ${path.root}/../scripts/create_kustomization.sh ${each.value.git_repo_url} ${each.value.kustomization_path}"
#   }

#   # Dynamically reference earlier terraform_data resources
#   depends_on = [for dep_key in var.flux_depends_on[each.key] : terraform_data.check_kustomization_file[dep_key]]
# }


# resource "terraform_data" "check_kustomization_file" {
#   for_each = var.flux_conf

#   provisioner "local-exec" {
#     command = "bash ${path.root}/../scripts/create_kustomization.sh ${each.value.git_repo_url} ${each.value.kustomization_path}"
#   }
# }


data "github_repository_file" "fetch_kustomization" {
  for_each = var.team_flux_conf.team.kustomizations

  repository = regex("github.com/([^/]+/[^\\.]+)", var.team_flux_conf.team.git_repo_url)[0]
  file       = "${each.value.path}/kustomization.yaml"
  branch     = "main"
}


resource "github_repository_file" "create_kustomization" {
  for_each = {
    for k, v in var.team_flux_conf.team.kustomizations :
    k => v
    if try(data.github_repository_file.fetch_kustomization[k].content, null) == null
  }

  repository          = regex("github.com/[^/]+/([^\\.]+)", var.team_flux_conf.team.git_repo_url)[0]
  file                = "${each.value.path}/kustomization.yaml"
  branch              = "main"
  content             = "hello"
  commit_message      = "Create kustomization.yaml for ${each.key} via TF"
  commit_author       = "Terraform GitHub Actions"
  commit_email        = "terraform-gha@apollo.com"
  overwrite_on_create = true
}

output "fetch_kustomization_debug" {
  value = {
    for k, v in data.github_repository_file.fetch_kustomization :
    k => {
      repo    = regex("github.com/([^/]+/[^\\.]+)", var.team_flux_conf.team.git_repo_url)[0]
      file    = "${var.team_flux_conf.team.kustomizations[k].path}/kustomization.yaml"
      branch  = "main"
      content = try(v.content, "NOT FOUND")
    }
  }
}