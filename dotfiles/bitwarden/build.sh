#!/usr/bin/env zsh

BINARY="bw"
WORK_DIR=/tmp/dotfiles-${BINARY}-${USER}
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "${OS}" = "darwin" ]; then
  OS="macos"
fi

if [ -x "${LOCAL_BIN}/${BINARY}" ]; then
  exit
fi

mkdir -p ${WORK_DIR}
pushd ${WORK_DIR}

wget "https://vault.bitwarden.com/download/?app=cli&platform=${OS}" -O bw.zip
unzip bw.zip
mv bw ${LOCAL_BIN}/bw

popd
rm -rf ${WORK_DIR}
