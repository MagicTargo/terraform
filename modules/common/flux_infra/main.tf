# Loop through each flux configuration passed from the root module
resource "terraform_data" "check_kustomization_file" {
  for_each = var.flux_conf

  provisioner "local-exec" {
    command = "bash ${path.root}/../scripts/create_kustomization.sh ${each.value.git_repo_url} ${each.value.kustomization_path}"
  }

  depends_on = each.key != "bootstrap" ? [
    terraform_data.check_kustomization_file[lookup(var.flux_conf, each.key, null)]
  ] : []
}


