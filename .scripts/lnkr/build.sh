#!/usr/bin/env zsh

BINARY="lnkr"
REPOSITORY="longkey1/lnkr"
CURRENT=$(cd $(dirname $0);pwd)

${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
