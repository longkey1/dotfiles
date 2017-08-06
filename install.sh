#!/usr/bin/env bash
CURRENT_DIR=`pwd`

pushd `dirname $0`
ROOT_DIR=`pwd`

_createLink() {
  local FILE=$1
  ln -s ${ROOT_DIR}/${FILE} ${HOME}/.${FILE}
  echo "${FILE} created link"
}

# create directory
DIRS=(\
".bin" \
"workspace" \
)
for DIR in ${DIRS[@]}; do
  if [ -d "${HOME}/${DIR}" ]; then
    mkdir -p ${HOME}/${DIR}
  fi
done

# top directories
FILES=(\
"bundle" \
"gitconfig" \
"gitignore" \
"git-template" \
"git-commit-message" \
"config/nvim" \
"tmux" \
"tmux.conf" \
"zprezto" \
"zlogin" \
"zlogout" \
"zpreztorc" \
"zprofile" \
"zshenv" \
"zshrc" \
"zshrc.prezto" \
)
for FILE in ${FILES[@]}; do
  if [ -L "${HOME}/.${FILE}" ]; then
    rm "${HOME}/.${FILE}"
  fi
  if [ -e "${HOME}/.${FILE}" -a ! -e "${HOME}/${FILE}.bk" ]; then
    mv ${HOME}/${FILE} ${HOME}/${FILE}.bk
    echo "${FILE} created backup"
  fi
  _createLink ${FILE}
done

popd
