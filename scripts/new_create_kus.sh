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

# using lockfile to prevent simultaneous access
LOCKFILE="/tmp/$(basename "$GIT_URL").lock"

# using flock to aquire lock to ensure only one script modifies the repo at a time
if gh api repos/"$REPO_URL"/contents/"$FILE_PATH" --silent &> /dev/null; then
  echo "{\"exists\": \"true\"}"
else
  echo "{\"exists\": \"false\"}"
fi
