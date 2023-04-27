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
set -a && . ./dotfiles/secrets.env && set +a


# inclide functions
. ${DOTFILES}/functions

# session
touch ${DOTFILES}/bitwarden.session
bw_session=$(get_bitwarden_session)
bw_status=$(${LOCAL_BIN}/bw status --session "${bw_session}" | ${LOCAL_BIN}/jq -r .status)

## unlocked
if [ "${bw_status}" = "unlocked" ]; then
  exit
fi

## locked
if [ "${bw_status}" = "locked" ]; then
  ${LOCAL_BIN}/bw unlock --raw > ${DOTFILES}/bitwarden.session
  exit
fi

# unauthenticated
${LOCAL_BIN}/bw login --apikey
${LOCAL_BIN}/bw unlock --raw > ${DOTFILES}/bitwarden.session
