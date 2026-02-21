#!/usr/bin/env zsh

APP="got"

${LOCAL_BIN}/envsubst '${HOME}' < ${LOCAL_CONFIG}/${APP}/config.toml.dist > ${LOCAL_CONFIG}/${APP}/config.toml
