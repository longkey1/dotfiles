#!/usr/bin/env zsh

BINARY="rg"
REPOSITORY="BurntSushi/ripgrep"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
