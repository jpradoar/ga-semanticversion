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
if [[ $COMMIT_MSG == *major:* ]]; then
  NewVersion=$(($X+1)).0.0
elif [[ $COMMIT_MSG == *minor:* ]]; then
  NewVersion=$X.$(($Y+1)).0
elif [[ $COMMIT_MSG == *patch:* ]] || [[ $COMMIT_MSG == *fix:* ]]; then
  NewVersion=$X.$Y.$(($Z+1))
elif [[ $COMMIT_MSG == *test:* ]]; then
  echo "This is a simple test. I will create a random string like $base_version-string"
  NewVersion=$base_version-$(tr -dc a-z0-9 </dev/urandom | head -c 8 ; echo '') 
else
  cusotm_version=$(echo $cusotm_version|cut -d' ' -f1)
  NewVersion=$base_version-$cusotm_version
fi
echo "COMMIT MSG: $COMMIT_MSG"
echo "OLD VERSION: $VERSION"
echo "NEW_VERSION: $NewVersion"
echo "NEW_VERSION=$NewVersion" >> "$GITHUB_OUTPUT" 
