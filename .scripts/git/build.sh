#!/usr/bin/env zsh

CURRENT=$(cd $(dirname $0);pwd)

set -a && . ${SCRIPTS}/secrets.env && set +a
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/git/config ${LOCAL_CONFIG}/git/config.dist ${SCRIPTS}/secrets.env -- ${CURRENT}/build_config.sh
