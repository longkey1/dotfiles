#!/usr/bin/env zsh

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

[ ! -h ${LOCAL_CONFIG}/ideavim/ideavimrc ] && ln -s ${LOCAL_CONFIG}/ideavim/ideavimrc.${OS} ${LOCAL_CONFIG}/ideavim/ideavimrc || true
