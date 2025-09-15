#!/usr/bin/env zsh

. ${SCRIPTS}/functions

npm install --global --prefix "${ROOT}/local" --package-lock "@anthropic-ai/claude-code"
