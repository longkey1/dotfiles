#!/usr/bin/env zsh

. ${SCRIPTS}/functions

PACKAGE="@anthropic-ai/claude-code"
VERSION=latest
npm install --global --prefix "${ROOT}/local" --no-package-lock --no-fund --silent "${PACKAGE}@${VERSION}"
INSTALLED_VERSION=$(npm list --global --prefix "${ROOT}/local" "${PACKAGE}" --json 2>/dev/null | jq -r ".dependencies[\"${PACKAGE}\"].version // empty")
echo "claude: installed ${PACKAGE}@${INSTALLED_VERSION}"
