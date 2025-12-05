#!/usr/bin/env zsh

set -a && . ${SCRIPTS}/secrets.env && set +a

. ${SCRIPTS}/functions
bw_session=$(get_bitwarden_session)
export GEMINI_API_KEY=$(${LOCAL_BIN}/bw get notes a317aaf3-bb1e-4f52-8f07-b27f010add73 --session "${bw_session}")

${LOCAL_BIN}/envsubst '${GPG_KEYID} ${GEMINI_API_KEY}' < ${LOCAL_CONFIG}/git/config.dist > ${LOCAL_CONFIG}/git/config
