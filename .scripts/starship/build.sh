#!/usr/bin/env zsh

BINARY="starship"
WORK_DIR=/tmp/dotfiles-${BINARY}-${USER}

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  mkdir -p ${WORK_DIR}
  pushd ${WORK_DIR}

  curl -O https://starship.rs/install.sh
  chmod +x install.sh
  ./install.sh -b ${LOCAL_BIN} -f

  popd
  rm -rf ${WORK_DIR}
fi

#
mkdir -p ${LOCAL_CONFIG}/starship
[ ! -e ${LOCAL_CONFIG}/starship/config.toml ] && ${LOCAL_BIN}/starship preset pure-preset -o ${LOCAL_CONFIG}/starship/config.toml || true
