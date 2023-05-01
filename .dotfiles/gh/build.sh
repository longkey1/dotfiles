#!/usr/bin/env zsh

BINARY="gh"
REPOSITORY="cli/cli"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH="amd64"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  if [ "${OS}" == "linux" ]; then
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --asset ${OS}_${ARCH}.tar.gz
  elif [ "${OS}" == "darwin" ]; then
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --asset macOS
  fi
fi

#
. ${DOTFILES}/functions
bw_session=$(get_bitwarden_session)
GITHUB_PERSONAL_ACCESS_TOKEN=$(${LOCAL_BIN}/bw get password afcc443a-6d28-4950-b83b-afeb004c167b --session "${bw_session}")
envsubst '${GITHUB_PERSONAL_ACCESS_TOKEN}' < ${LOCAL_CONFIG}/gh/hosts.yml.dist > ${LOCAL_CONFIG}/gh/hosts.yml
