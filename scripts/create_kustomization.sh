#!/bin/bash

set -e

GIT_URL="$1"                              
KUSTOMIZATION_PATH="$2"
BRANCH="main"

REPO_NAME=$(basename "$GIT_URL")
CLONE_DIR="/tmp/${REPO_NAME}"
FILE="${KUSTOMIZATION_PATH}/kustomization.yaml"
CONTENT="hello world"

# Configure git
git config user.email "terraform-gha@apollo.com"
git config user.name "Terraform GitHub Actions"
# Clone the repo
sudo rm -rf $CLONE_DIR
git clone "$GIT_URL" "$CLONE_DIR"

# Change to repo directory
cd "$CLONE_DIR"

# Checkout to the desired branch
git checkout "$BRANCH"

# Check if file exists and create accordingly.
if [ -f "$FILE" ]; then
  echo "File already exists: $FILE"
else
  echo "Creating new file: $FILE"
  mkdir -p "$(dirname "$FILE")"
  echo "$CONTENT" > "$FILE"
  git add "$FILE"
  git commit -m "Added $FILE"
  git pull
  git push origin "$BRANCH"
  echo "File created and pushed successfully"
  sudo rm -rf $CLONE_DIR
fi
