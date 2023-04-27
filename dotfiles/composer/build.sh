#!/usr/bin/env zsh

. ${ROOT}/dotfiles/functions
bw_session=$(get_bitwarden_session)

export GITHUB_PERSONAL_ACCESS_TOKEN=$(${LOCAL_BIN}/bw get password afcc443a-6d28-4950-b83b-afeb004c167b --session "${bw_session}")
envsubst '${GITHUB_PERSONAL_ACCESS_TOKEN}' < ${LOCAL_CONFIG}/composer/auth.json.dist > ${LOCAL_CONFIG}/composer/auth.json
