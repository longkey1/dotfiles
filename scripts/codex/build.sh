#!/usr/bin/env zsh

. ${SCRIPTS}/functions

npm install --global --prefix "${ROOT}/local" --no-package-lock --no-fund "@openai/codex@latest"
