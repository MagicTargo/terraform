#!/bin/bash

set -e

GIT_URL="$1"
KUSTOMIZATION_PATH="$2"
TEMP_OUTPUT_FILE="/tmp/output.txt"
BRANCH="main"

# Converting Git URL to "owner/repo" format
REPO=$(basename "$GIT_URL")
OWNER=$(basename "$(dirname "$GIT_URL")")
REPO_NAME="${OWNER}/${REPO%.git}"


FILE="${KUSTOMIZATION_PATH}/kustomization.yaml"
CONTENT=$(echo -n "hello world" | base64)

# using lockfile to prevent simultaneous access
LOCKFILE="/tmp/$(basename "$GIT_URL").lock"

echo "Checking for file: ${FILE} in repo: ${REPO_NAME}"

# using flock to aquire lock to ensure only one script modifies the repo at a time
flock "$LOCKFILE" -c "
  if gh api repos/${REPO_NAME}/contents/${FILE} --jq .sha > /dev/null 2>&1; then
    echo 'File on ${REPO_NAME} already exists: ${FILE}' >> "$TEMP_OUTPUT_FILE"
  else
    echo 'Creating file: ${FILE}'
    gh api repos/${REPO_NAME}/contents/${FILE} \
      --method PUT \
      --field message='Kustomization created via TF' \
      --field content='${CONTENT}' \
      --field branch='${BRANCH}'
    echo 'Created file on ${REPO_NAME}: ${FILE}' >> "$TEMP_OUTPUT_FILE"
  fi
"
