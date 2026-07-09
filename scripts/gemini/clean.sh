#!/usr/bin/env bash

. "${SCRIPTS}"/functions

npm uninstall --global --prefix "${ROOT}/local" "@google/gemini-cli"
