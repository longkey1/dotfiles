#!/usr/bin/env zsh

function git-clone() {
  repo="https://github.com/${1}.git"
  dest="${LOCAL_CONFIG}/zsh/${2}"
  [ ! -d "${dest}" ] && git clone ${repo} ${dest} || true
}

set -a && . ${SCRIPTS}/secrets.env && set +a &&
export GPG_PASSPHRASE=$(${LOCAL_BIN}/bw get password c5f2ce95-8cd9-41e6-b1ef-afeb00292e4c --session "${bw_session}")

. ${SCRIPTS}/functions
bw_session=$(get_bitwarden_session)

envsubst '${GPG_KEYGRIP} ${GPG_PASSPHRASE}' < ${LOCAL_CONFIG}/zsh/zshrc.gpg.dist > ${LOCAL_CONFIG}/zsh/zshrc.gpg

[ ! -f ${LOCAL_CONFIG}/zsh/.zshrc ] && ln -s ${LOCAL_CONFIG}/zsh/zshrc ${LOCAL_CONFIG}/zsh/.zshrc || true
[ ! -f ${LOCAL_CONFIG}/zsh/.zlogin ] && ln -s ${LOCAL_CONFIG}/zsh/zlogin ${LOCAL_CONFIG}/zsh/.zlogin || true

# plugins
mkdir -p ${LOCAL_CONFIG}/zsh/plugins
git-clone zsh-users/zsh-completions plugins/zsh-users/zsh-completions
git-clone zsh-users/zsh-history-substring-search plugins/zsh-users/zsh-history-substring-search
git-clone zsh-users/zsh-syntax-highlighting plugins/zsh-users/zsh-syntax-highlighting
git-clone mollifier/anyframe plugins/mollifier/anyframe
git-clone olets/zsh-abbr plugins/olets/zsh-abbr
