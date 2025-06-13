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
set -a && . ${SCRIPTS}/secrets.env && set +a

# inclide functions
. ${SCRIPTS}/functions

# session
touch ${SCRIPTS}/bitwarden.session
bw_session=$(get_bitwarden_session)

## unauthenticated
bw_status=$(${LOCAL_BIN}/bw status | ${LOCAL_BIN}/jq -r .status)
if [ "${bw_status}" = "unauthenticated" ]; then
  ${LOCAL_BIN}/bw login --apikey
  ${LOCAL_BIN}/bw unlock --raw > ${SCRIPTS}/bitwarden.session
  exit
fi

## locked
if [[ "${bw_status}" = "locked" ]] && [[ -z $(<"${SCRIPTS}/bitwarden.session") ]]; then
  ${LOCAL_BIN}/bw unlock --raw > ${SCRIPTS}/bitwarden.session
fi
