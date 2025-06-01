resource "terraform_data" "check_file_exists" {
  provisioner "local-exec" {
    command = "bash ${path.root}/../scripts/create_kustomization.sh ${var.repository_full_name} ${var.environment}"
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