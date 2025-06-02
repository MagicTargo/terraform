#!/bin/bash

set -e

GIT_URL="$1"
KUSTOMIZATION_PATH="$2"
BRANCH="main"

# Converting Git URL to "owner/repo" format
REPO=$(basename "$GIT_URL")
OWNER=$(basename "$(dirname "$GIT_URL")")
REPO_NAME="${OWNER}/${REPO%.git}"

FILE="${KUSTOMIZATION_PATH}/kustomization.yaml"
CONTENT=$(echo -n "hello world" | base64)

# Define lock file based on the repo name to prevent simultaneous access
LOCKFILE="/tmp/$(basename "$GIT_URL").lock"

# Fetch latest commit SHA from the target branch before doing anything
LATEST_COMMIT_SHA=$(gh api repos/${REPO_NAME}/git/ref/heads/${BRANCH} --jq .object.sha)
echo "Using latest commit SHA: $LATEST_COMMIT_SHA"

echo "Checking for file: ${FILE} in repo: ${REPO_NAME}"

# Acquire the lock using flock to ensure only one script modifies the repo at a time
flock "$LOCKFILE" -c '
  # Checking if the file exists in the repo
  if gh api "repos/${REPO_NAME}/contents/${FILE}" --jq .sha > /dev/null 2>&1; then
    echo "File already exists: ${FILE}"
  else
    echo "Kustomization file not found. Creating file: ${FILE}"
    # Create the file using GitHub API with the base64 content
    gh api "repos/${REPO_NAME}/contents/${FILE}" \
      --method PUT \
      --field message="Kustomization created via TF" \
      --field content="${CONTENT}" \
      --field branch="${BRANCH}"
    echo "File created"
  fi
'