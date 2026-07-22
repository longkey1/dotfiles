#!/usr/bin/env bash

. "${SCRIPTS}"/functions

symlink_to_symlink local/bin/claude
symlink config/claude/settings.json claude/settings.json
