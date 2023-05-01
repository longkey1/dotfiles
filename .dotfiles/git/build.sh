#!/usr/bin/env zsh

set -a && . ${DOTFILES}/secrets.env && set +a
CURRENT=$(cd $(dirname $0);pwd)
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/git/config ${LOCAL_CONFIG}/git/config.dist ${DOTFILES}/secrets.env -- env LOCAL_CONFIG=${LOCAL_CONFIG} GPG_KEYID=${GPG_KEYID} ${CURRENT}/build_envsubst.sh

