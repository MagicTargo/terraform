resource "terraform_data" "check_kustomization_file" {
  for_each = var.flux_conf

  provisioner "local-exec" {
    command = "bash ${path.root}/../scripts/create_kustomization.sh ${each.value.git_repo_url} ${each.value.kustomization_path}"
  }

  # Dynamically depend on previous execution in the loop (if applicable)
  depends_on = each.key != "bootstrap" ? [
    terraform_data.check_kustomization_file[local.flux_conf_keys[lookup(local.flux_conf, each.key) - 1]]
  ] : []
}
