#!/usr/bin/env zsh

BINARY="eget"
WORK_DIR=/tmp/dotfiles-${BINARY}-${USER}

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  mkdir -p ${WORK_DIR}
  pushd ${WORK_DIR}

  curl -o eget.sh https://zyedidia.github.io/eget.sh
  shasum -a 256 eget.sh
  ${SHELL} eget.sh
  mv ${BINARY} ${LOCAL_BIN}/${BINARY}

  popd
  rm -rf ${WORK_DIR}
fi
