#!/usr/bin/env zsh

function git-clone() {
  repo="https://github.com/${1}.git"
  dest="${LOCAL_CONFIG}/zsh/${2}"
  [ ! -d "${dest}" ] && git clone ${repo} ${dest} || true
}

set -a && . ${DOTFILES}/secrets.env && set +a &&

envsubst '${GPG_KEYGRIP}' < ${LOCAL_CONFIG}/zsh/zlogin.dist > ${LOCAL_CONFIG}/zsh/zlogin

[ ! -f ${LOCAL_CONFIG}/zsh/.zshrc ] && ln -s ${LOCAL_CONFIG}/zsh/zshrc ${LOCAL_CONFIG}/zsh/.zshrc || true
[ ! -f ${LOCAL_CONFIG}/zsh/.zlogin ] && ln -s ${LOCAL_CONFIG}/zshzlogin ${LOCAL_CONFIG}/zsh/.zlogin || true

# plugins
mkdir -p ${LOCAL_CONFIG}/zsh/plugins
git-clone zsh-users/zsh-completions plugins/zsh-users/zsh-completions
git-clone zsh-users/zsh-history-substring-search plugins/zsh-users/zsh-history-substring-search
git-clone zsh-users/zsh-syntax-highlighting plugins/zsh-users/zsh-syntax-highlighting
git-clone mollifier/anyframe plugins/mollifier/anyframe
git-clone olets/zsh-abbr plugins/olets/zsh-abbr

${LOCAL_BIN}/gcal --config ${LOCAL_CONFIG}/gcal/config.toml completion zsh > ${LOCAL_CONFIG}/zsh/functions/_gcal
${LOCAL_BIN}/godl completion zsh > ${LOCAL_CONFIG}/zsh/functions/_godl
${LOCAL_BIN}/jnal --config ${LOCAL_CONFIG}/jnal/config.toml completion zsh > ${LOCAL_CONFIG}/zsh/functions/_jnal
${LOCAL_BIN}/just --completions zsh > ${LOCAL_CONFIG}/zsh/functions/_just
${LOCAL_BIN}/tmpl --config ${LOCAL_CONFIG}/tmpl/config.toml completion zsh > ${LOCAL_CONFIG}/zsh/functions/_tmpl
