#!/bin/bash

set -e

REPO="$1"
ENV="$2"
BRANCH="main"
FILE="clusters/${ENV}/kustomization.yaml"
CONTENT=$(echo -n "hello world" | base64)

# Ensure gh is authenticated
if ! gh auth status > /dev/null 2>&1; then
  echo "$GH_TOKEN" | gh auth login --with-token
fi

# Check if file exists
if gh api "repos/${REPO}/contents/${FILE}" --jq .sha > /dev/null 2>&1; then
  echo "File already exists: ${FILE}"
else
  echo "Creating file: ${FILE}"
  gh api "repos/${REPO}/contents/${FILE}" \
    --method PUT \
    --field message="Kustomization via TF" \
    --field content="${CONTENT}" \
    --field branch="${BRANCH}"
  echo "File created"
fi
