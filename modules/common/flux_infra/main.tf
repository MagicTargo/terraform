resource "terraform_data" "check_kustomization_file" {
  for_each = var.flux_conf

  provisioner "local-exec" {
    command = "bash ${path.module}/../scripts/create_kustomization.sh ${each.value.git_repo_url} ${each.value.kustomization_path}"
  }
}
