#!/bin/bash

# Configuration
REPO="jackmarsh/postgres"

# Get the latest release tag
LATEST_TAG=$(gh release list --repo "$REPO" --limit 1 --json tagName --jq '.[0].tagName' 2>/dev/null || echo "v0.0.0")

# Increment the version
IFS='.' read -r MAJOR MINOR PATCH <<<"${LATEST_TAG//v/}"
PATCH=$((PATCH + 1))
NEW_TAG="v$MAJOR.$MINOR.$PATCH"

echo "Latest tag: $LATEST_TAG"
echo "Creating new tag: $NEW_TAG"

# Build all PostgreSQL binaries
echo "Building all PostgreSQL binaries..."
plz build //binaries/... || {
  echo "Build failed."
  exit 1
}

# Query built tarballs
echo "Querying built tarballs..."
TARBALLS=$(plz query output //binaries/... | grep psql-.*.tar.gz)

# Check if tarballs exist
if [[ -z "$TARBALLS" ]]; then
  echo "No tarballs found. Exiting."
  exit 1
fi

# Create a new release
echo "Creating release $NEW_TAG..."
gh release create "$NEW_TAG" --repo "$REPO" --title "PostgreSQL Release $NEW_TAG" --notes "Release of PostgreSQL binaries." || {
  echo "Failed to create release $NEW_TAG."
  exit 1
}

# Upload all tarballs to the release
echo "Uploading tarballs to release $NEW_TAG..."
echo "$TARBALLS" | while read -r TAR_PATH; do
  echo "Uploading $TAR_PATH..."
  gh release upload "$NEW_TAG" "$TAR_PATH" --repo "$REPO" || {
    echo "Failed to upload $TAR_PATH. Skipping."
  }
done

echo "Release $NEW_TAG created successfully with all tarballs."
