#!/usr/bin/env zsh

REPOSITORY="x-motemen/ghq"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
