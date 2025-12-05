#!/usr/bin/env zsh

${LOCAL_BIN}/envsubst '${HOME}' < ${LOCAL_CONFIG}/jnal/config.toml.dist > ${LOCAL_CONFIG}/jnal/config.toml
