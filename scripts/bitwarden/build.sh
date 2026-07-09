#!/usr/bin/env bash

. "${SCRIPTS}"/functions

npm_install_global "bitwarden" "@bitwarden/cli"

# set secrets
set -a && . "${SCRIPTS}"/secrets.env && set +a

# session
touch "${SCRIPTS}"/bitwarden.session

## unauthenticated
bw_status=$("${LOCAL_BIN}"/bw status | "${LOCAL_BIN}/qq" -r .status)
if [ "${bw_status}" = "unauthenticated" ]; then
  "${LOCAL_BIN}"/bw login --apikey
  "${LOCAL_BIN}"/bw unlock --raw > "${SCRIPTS}"/bitwarden.session
  exit
fi

## locked
if [[ "${bw_status}" = "locked" ]] && [[ -z $(< "${SCRIPTS}/bitwarden.session") ]]; then
  "${LOCAL_BIN}"/bw unlock --raw > "${SCRIPTS}"/bitwarden.session
fi
