#!/usr/bin/env zsh

REPOSITORY="BurntSushi/ripgrep"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/rg --upgrade-only
