#!/bin/bash

# Set general vars to get external inputs (from git actions)
COMMIT_MSG=$1
VERSION=$2

# Make some vars to manipulate each part of a full version (X.Y.Z)
X=$(echo $VERSION|cut -d. -f1)
Y=$(echo $VERSION|cut -d. -f2)
Z=$(echo $VERSION|cut -d. -f3)
base_version=$(echo $X.$Y.$Z)
cusotm_version=$(echo $COMMIT_MSG|cut -d':' -f1)

# Create new version using type (major,minor,patch,beta,none)
if [[ "$COMMIT_MSG"  =~ ^(major:|breaking:|release:) ]]; then
  NewVersion=$(($X+1)).0.0
elif [[ "$COMMIT_MSG" =~ ^(minor:|enhancement:|update:|feature:) ]]; then
  NewVersion=$X.$(($Y+1)).0
elif [[ "$COMMIT_MSG" =~ ^(patch:|fix:|feat:) ]]; then
  NewVersion=$X.$Y.$(($Z+1))
elif [[ "$COMMIT_MSG" =~ ^test: ]]; then
  # Generate test version string
  echo "This is a simple test. Creating a random string like $base_version-string"
  NewVersion=$base_version-$(tr -dc a-z0-9 </dev/urandom | head -c 8)
elif [[ "$COMMIT_MSG" =~ ^trash: ]]; then
  # Increment patch version and add a trash suffix with random string
  NewVersion=$X.$Y.$(($Z+1))_trash-$(tr -dc a-z0-9 </dev/urandom | head -c 8)
else
  # Handle custom commit types
  custom_version=$(echo $COMMIT_MSG | cut -d':' -f1 | cut -d' ' -f1)
  NewVersion="$base_version-$custom_version"
fi

echo "COMMIT MSG: $COMMIT_MSG"
echo "OLD VERSION: $VERSION"
echo "NEW_VERSION: $NewVersion"
echo "NEW_VERSION=$NewVersion" >> "$GITHUB_OUTPUT"
