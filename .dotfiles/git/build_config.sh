#!/usr/bin/env zsh

envsubst '${GPG_KEYID}' < ${LOCAL_CONFIG}/git/config.dist > ${LOCAL_CONFIG}/git/config
