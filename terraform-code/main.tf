resource "null_resource" "check_file_exists" {
  provisioner "local-exec" {
    command = <<EOT
      gh api repos/${var.repository_full_name}/contents/clusters/${var.environment}/kustomization.yaml \
        --jq .sha 2>/dev/null || \
      gh api repos/${var.repository_full_name}/contents/clusters/${var.environment}/kustomization.yaml \
        --method PUT \
        --field message='Kustomization via TF' \
        --field content='$(echo -n "hello world" | base64)' \
        --field branch='main'
    EOT
  }

}

# resource "github_repository_file" "flux_kustomization" {
#   repository          = var.repository_full_name
#   branch              = "main"
#   file                = join("/", ["clusters", var.environment, "kustomization.yaml"])
#   content             = "hello world"
#   commit_message      = "Kustomization for via TF"
#   commit_author       = "Terraform GitHub Actions"
#   commit_email        = "terraform-gha@apollo.com"
#   overwrite_on_create = false
# }