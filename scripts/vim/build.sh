#!/usr/bin/env bash

git-clone() {
  repo="https://github.com/${1}.git"
  dest="${ROOT}/vim/pack/bundle/start/${2}"
  if [ ! -d "${dest}" ]; then
    git clone "${repo}" "${dest}"
  fi
}

git-clone thinca/vim-quickrun vim-quickrun
git-clone vim-scripts/sudo.vim sudo.vim
git-clone longkey1/vim-lf vim-lf
git-clone nanotech/jellybeans.vim jellybeans.vim
git-clone ConradIrwin/vim-bracketed-paste vim-bracketed-paste
git-clone tyru/open-browser.vim open-browser.vim
