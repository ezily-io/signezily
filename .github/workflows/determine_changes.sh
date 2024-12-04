#!/bin/bash

# Detect changes for Marketing site
if git diff --name-only "$GITHUB_EVENT_BEFORE" "$GITHUB_SHA" | grep -q "^apps/marketing/**"; then
  echo "{marketing_changed}={true}" >> $GITHUB_OUTPUT
else
  echo "{marketing_changed}={false}" >> $GITHUB_OUTPUT
fi

# Detect changes for Documentation site
if git diff --name-only "${{ github.event.before }} ${{ github.sha }}" | grep -q "^apps/documentation/**"; then
  echo "{documentation_changed}={true}" >> $GITHUB_OUTPUT
else
  echo "{documentation_changed}={false}" >> $GITHUB_OUTPUT
fi

# if git diff --name-only ${{ github.event.before }} ${{ github.sha }} | grep -q "^${{ inputs.documenso-web-path }}/"; then
#   echo "changed=true" >> $GITHUB_ENV
# else
#   echo "changed=false" >> $GITHUB_ENV
# fi

# if git diff --name-only ${{ github.event.before }} ${{ github.sha }} | grep -q "^${{ inputs.documenso-marketing-path }}/"; then
#   echo "changed=true" >> $GITHUB_ENV
# else
#   echo "changed=false" >> $GITHUB_ENV
# fi

# if git diff --name-only ${{ github.event.before }} ${{ github.sha }} | grep -q "^${{ inputs.documenso-docs-path }}/"; then
#   echo "changed=true" >> $GITHUB_ENV
# else
#   echo "changed=false" >> $GITHUB_ENV
# fi