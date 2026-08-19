#!/usr/bin/env bash

set -a && . "${SCRIPTS}"/secrets.env && set +a

. "${SCRIPTS}"/functions
bw_session=$(get_bitwarden_session)
GPG_PASSPHRASE=$("${LOCAL_BIN}"/bw get password 4bb3c38c-e677-42a7-ad28-f59e80301e15 --session "${bw_session}")
export GPG_PASSPHRASE

envsubst '${GPG_KEYGRIP} ${GPG_PASSPHRASE}' <"${LOCAL_CONFIG}"/zsh/zshrc.gpg.dist >"${LOCAL_CONFIG}"/zsh/zshrc.gpg
