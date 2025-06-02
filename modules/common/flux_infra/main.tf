resource "terraform_data" "check_kustomization_file" {
  for_each = local.indexed_flux_conf

  provisioner "local-exec" {
    command = "bash ${path.root}/../scripts/create_kustomization.sh ${each.value.config.git_repo_url} ${each.value.config.kustomization_path}"
  }

  # Add depends_on dynamically if it's not the first item
  depends_on = each.value.index > 0 ? [
    terraform_data.check_kustomization_file[local.ordered_flux_conf_keys[each.value.index - 1]]
  ] : []
}
