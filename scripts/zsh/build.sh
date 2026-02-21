#!/usr/bin/env zsh

CURRENT=$(cd $(dirname $0);pwd)
${LOCAL_BIN}/checkexec ${LOCAL_CONFIG}/zsh/zshrc.gpg ${LOCAL_CONFIG}/zsh/zshrc.gpg.dist -- ${CURRENT}/build_gpg.sh

[ ! -f ${LOCAL_CONFIG}/zsh/.zshrc ] && ln -s ${LOCAL_CONFIG}/zsh/zshrc ${LOCAL_CONFIG}/zsh/.zshrc || true

# plugins
# Usage: git_sync <owner/repo> [clone_args...]
git_sync() {
  local repo=$1
  shift
  local clone_args=("$@")

  local url="https://github.com/${repo}"
  local dest="${LOCAL_CONFIG}/zsh/plugins/${repo}"

  # pull
  if [[ -d "$dest" ]]; then
    echo "[git_sync] pull: $dest"
    git -C "$dest" pull --ff-only
    return $?
  fi

  # clone
  echo "[git_sync] clone: $url → $dest"
  mkdir -p "$(dirname "$dest")"
  git clone "${clone_args[@]}" "$url" "$dest"
}
git_sync zsh-users/zsh-completions
git_sync zsh-users/zsh-history-substring-search
git_sync zsh-users/zsh-syntax-highlighting
git_sync mollifier/anyframe
git_sync olets/zsh-abbr --recurse-submodules --depth 1
