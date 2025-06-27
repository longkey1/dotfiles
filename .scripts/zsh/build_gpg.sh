#!/usr/bin/env zsh

set -a && . ${SCRIPTS}/secrets.env && set +a &&

. ${SCRIPTS}/functions
bw_session=$(get_bitwarden_session)
export GPG_PASSPHRASE=$(${LOCAL_BIN}/bw get password c5f2ce95-8cd9-41e6-b1ef-afeb00292e4c --session "${bw_session}")

envsubst '${GPG_KEYGRIP} ${GPG_PASSPHRASE}' < ${LOCAL_CONFIG}/zsh/zshrc.gpg.dist > ${LOCAL_CONFIG}/zsh/zshrc.gpg
