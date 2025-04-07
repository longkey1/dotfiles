#!/usr/bin/env zsh

CURRENT=$(cd $(dirname $0);pwd)

set -a && . ${SCRIPTS}/secrets.env && set +a
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/git/config ${LOCAL_CONFIG}/git/config.dist ${SCRIPTS}/secrets.env -- env LOCAL_CONFIG=${LOCAL_CONFIG} GPG_KEYID=${GPG_KEYID} ${CURRENT}/build_config.sh

