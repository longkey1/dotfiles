#!/usr/bin/env zsh

function git-clone() {
  repo="https://github.com/${1}.git"
  dest="${LOCAL_CONFIG}/zsh/${2}"
  [ ! -d "${dest}" ] && git clone ${repo} ${dest} || true
}

CURRENT=$(cd $(dirname $0);pwd)
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/zsh/zshrc.gpg ${LOCAL_CONFIG}/zsh/zshrc.gpg.dist -- ${CURRENT}/build_gpg.sh

[ ! -f ${LOCAL_CONFIG}/zsh/.zshrc ] && ln -s ${LOCAL_CONFIG}/zsh/zshrc ${LOCAL_CONFIG}/zsh/.zshrc || true
[ ! -f ${LOCAL_CONFIG}/zsh/.zlogin ] && ln -s ${LOCAL_CONFIG}/zsh/zlogin ${LOCAL_CONFIG}/zsh/.zlogin || true

# plugins
mkdir -p ${LOCAL_CONFIG}/zsh/plugins
git-clone zsh-users/zsh-completions plugins/zsh-users/zsh-completions
git-clone zsh-users/zsh-history-substring-search plugins/zsh-users/zsh-history-substring-search
git-clone zsh-users/zsh-syntax-highlighting plugins/zsh-users/zsh-syntax-highlighting
git-clone mollifier/anyframe plugins/mollifier/anyframe
git-clone olets/zsh-abbr plugins/olets/zsh-abbr
