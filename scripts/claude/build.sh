#!/usr/bin/env zsh

. ${SCRIPTS}/functions

#VERSION=latest
VERSION=v2.1.21
npm install --global --prefix "${ROOT}/local" --no-package-lock --no-fund "@anthropic-ai/claude-code@${VERSION}"
