# resource "terraform_data" "check_kustomization_file" {
#   for_each = var.flux_conf

#   provisioner "local-exec" {
#     command = "bash ${path.root}/../scripts/create_kustomization.sh ${each.value.git_repo_url} ${each.value.kustomization_path}"
#   }

#   # Dynamically reference earlier terraform_data resources
#   depends_on = [for dep_key in var.flux_depends_on[each.key] : terraform_data.check_kustomization_file[dep_key]]
# }


resource "terraform_data" "check_kustomization_file" {
  for_each = var.flux_conf

  provisioner "local-exec" {
    command = "bash ${path.root}/../scripts/create_kustomization.sh ${each.value.git_repo_url} ${each.value.kustomization_path}"
  }
}

data "local_file" "status" {
  filename = "/tmp/.output.txt"
  depends_on = [ terraform_data.check_kustomization_file ]
}

output "status" {
  value = data.local_file.status.content
}