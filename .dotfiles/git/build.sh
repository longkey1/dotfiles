#!/usr/bin/env zsh

set -a && . ./dotfiles/secrets.env && set +a
envsubst '${GPG_KEYID}' < ${LOCAL_CONFIG}/git/config.dist > ${LOCAL_CONFIG}/git/config
