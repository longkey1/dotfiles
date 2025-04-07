#!/usr/bin/env zsh

BINARY="bw"
WORK_DIR=/tmp/dotfiles-${BINARY}-${USER}
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" = "darwin" ]; then
  OS="macos"
fi

# install
if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  mkdir -p ${WORK_DIR}
  pushd ${WORK_DIR}

  wget "https://vault.bitwarden.com/download/?app=cli&platform=${OS}" -O bw.zip
  unzip bw.zip
  mv bw ${LOCAL_BIN}/bw

  popd
  rm -rf ${WORK_DIR}
fi

# set secrets
set -a && . ${DOTFILES}/secrets.env && set +a


# inclide functions
. ${DOTFILES}/functions

# session
touch ${DOTFILES}/bitwarden.session
bw_session=$(get_bitwarden_session)

## unauthenticated
bw_status=$(${LOCAL_BIN}/bw status --session "${bw_session}" | ${LOCAL_BIN}/jq -r .status)
if [ "${bw_status}" = "unauthenticated" ]; then
  ${LOCAL_BIN}/bw login --apikey
  ${LOCAL_BIN}/bw unlock --raw > ${DOTFILES}/bitwarden.session
  exit
fi

## locked
bw_test=$(${LOCAL_BIN}/bw get notes e662e3a3-6e8d-4903-982d-b283007a1b6f --session "${bw_session}")
if [ "${bw_test}" != "longkey1" ]; then
  ${LOCAL_BIN}/bw unlock --raw > ${DOTFILES}/bitwarden.session
fi
