#!/usr/bin/env zsh

. ${SCRIPTS}/functions

VERSION=latest
npm install --global --prefix "${ROOT}/local" --no-package-lock --no-fund "@anthropic-ai/claude-code@${VERSION}"
