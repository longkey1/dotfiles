#!/usr/bin/env zsh

. ${SCRIPTS}/functions

PACKAGE="@google/gemini-cli"
npm install --global --prefix "${ROOT}/local" --no-package-lock --no-fund --silent "${PACKAGE}@latest"
INSTALLED_VERSION=$(npm list --global --prefix "${ROOT}/local" "${PACKAGE}" --json 2>/dev/null | jq -r ".dependencies[\"${PACKAGE}\"].version // empty")
echo "gemini: installed ${PACKAGE}@${INSTALLED_VERSION}"
