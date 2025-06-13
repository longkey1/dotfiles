#!/usr/bin/env zsh

REPOSITORY="casey/just"

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
