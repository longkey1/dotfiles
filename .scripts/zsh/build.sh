#!/usr/bin/env zsh

CURRENT=$(cd $(dirname $0);pwd)
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/zsh/zshrc.gpg ${LOCAL_CONFIG}/zsh/zshrc.gpg.dist -- ${CURRENT}/build_gpg.sh

[ ! -f ${LOCAL_CONFIG}/zsh/.zshrc ] && ln -s ${LOCAL_CONFIG}/zsh/zshrc ${LOCAL_CONFIG}/zsh/.zshrc || true

# plugins
mkdir -p ${LOCAL_CONFIG}/zsh/plugins
git clone https://github.com/zsh-users/zsh-completions ${LOCAL_CONFIG}/zsh/plugins/zsh-users/zsh-completions || true
git clone https://github.com/zsh-users/zsh-history-substring-search ${LOCAL_CONFIG}/zsh/plugins/zsh-users/zsh-history-substring-search || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${LOCAL_CONFIG}/zsh/plugins/zsh-users/zsh-syntax-highlighting || true
git clone https://github.com/mollifier/anyframe ${LOCAL_CONFIG}/zsh/plugins/mollifier/anyframe || true
git clone https://github.com/olets/zsh-abbr --recurse-submodules --depth 1 ${LOCAL_CONFIG}/zsh/plugins/olets/zsh-abbr || true
