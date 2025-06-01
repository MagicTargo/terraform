resource "null_resource" "check_file_exists" {
  provisioner "local-exec" {
    command = <<EOT
      FILE="clusters/${var.environment}/kustomization.yaml"
      REPO="${var.repository_full_name}"
      BRANCH="main"
      CONTENT=$(echo -n "hello world" | base64)

      # Check if file exists
      if gh api repos/${REPO}/contents/${FILE} --jq .sha > /dev/null 2>&1; then
        echo "File already exists. Skipping creation."
      else
        echo "Creating file..."
        gh api repos/${REPO}/contents/${FILE} \
          --method PUT \
          --field message="Kustomization via TF" \
          --field content="${CONTENT}" \
          --field branch="${BRANCH}"
      fi
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