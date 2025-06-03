data "external" "check_file" {
  for_each = var.flux_conf

  program = [
    "bash",
    "${path.root}/../scripts/new_create_kus.sh",
    each.value.git_repo_url,
    each.value.kustomization_path
  ]
}

# resource "github_repository_file" "flux_file" {
#   for_each = {
#     for k, v in var.flux_conf :
#     k => v if data.external.check_file[k].result["file_exists"] == false
#   }

#   repository     = each.value.repo
#   branch         = each.value.branch
#   file           = each.value.file_path
#   content        = file("${path.module}/template/kustomization.yaml")
#   commit_message = "Add Flux kustomization.yaml"
# }

# output "created_flux_files" {
#   value = {
#     for repo_key, file_res in github_repository_file.flux_file :
#     repo_key => {
#       file_path   = file_res.file
#       repository  = file_res.repository
#       branch      = file_res.branch
#       content_sha = file_res.sha
#     }
#   }
# }

output "skipped_flux_files" {
  value = {
    for k, v in var.flux_conf :
    k => v.file_path
    if data.external.check_file[k].result["file_exists"] == true
  }
}