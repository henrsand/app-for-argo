#!/bin/bash
set -e

# CONFIG
IMAGE_NAME="henrsand/app-for-argo"
GIT_VALUES_FILE="charts/values.yaml"  # path to your Helm values.yaml
NEW_TAG="v$(date +%Y%m%d%H%M%S)"  # generates a tag like v20250426094000

# Build and push the Docker image
docker build -t $IMAGE_NAME:$NEW_TAG .
docker push $IMAGE_NAME:$NEW_TAG

# Update values.yaml
echo "Updating $GIT_VALUES_FILE with new tag: $NEW_TAG"
sed -i "s|tag: .*|tag: $NEW_TAG|" charts/values.yaml

# Commit and push the change
git add $GIT_VALUES_FILE
git commit -m "Update image tag to $NEW_TAG"
git push

echo "Done! Argo CD will pick up the new deployment shortly."