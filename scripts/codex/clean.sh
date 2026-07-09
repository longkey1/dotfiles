#!/usr/bin/env bash

. "${SCRIPTS}"/functions

npm uninstall --global --prefix "${ROOT}/local" "@openai/codex"
