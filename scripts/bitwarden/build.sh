#!/usr/bin/env bash

. "${SCRIPTS}"/functions

# 2026.9.0 以降はログイン時に user-key-id backfill (POST /api/accounts/key-management/user-key-id) を
# 必須実行するが Vaultwarden が未実装で 404 になり login が失敗する
# https://github.com/dani-garcia/vaultwarden/issues/7750
npm_install_global "bitwarden" "@bitwarden/cli" "2026.8.0"

# set secrets
set -a && . "${SCRIPTS}"/secrets.env && set +a

# session
touch "${SCRIPTS}"/bitwarden.session

## unauthenticated
bw_status=$("${LOCAL_BIN}"/bw status | "${LOCAL_BIN}/jq" -r .status)
if [ "${bw_status}" = "unauthenticated" ]; then
  # server config is only allowed while logged out
  if [ -n "${BW_SERVER}" ]; then
    "${LOCAL_BIN}"/bw config server "${BW_SERVER}"
  fi
  "${LOCAL_BIN}"/bw login --apikey
  "${LOCAL_BIN}"/bw unlock --raw >"${SCRIPTS}"/bitwarden.session
  exit
fi

## locked
if [[ "${bw_status}" = "locked" ]] && [[ -z $(<"${SCRIPTS}/bitwarden.session") ]]; then
  "${LOCAL_BIN}"/bw unlock --raw >"${SCRIPTS}"/bitwarden.session
fi
