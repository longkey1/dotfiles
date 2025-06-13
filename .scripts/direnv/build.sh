#!/usr/bin/env zsh

REPOSITORY="direnv/direnv"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
