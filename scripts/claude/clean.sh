#!/usr/bin/env zsh

. ${SCRIPTS}/functions

npm uninstall --global --prefix "${ROOT}/local" "@anthropic-ai/claude-code"
