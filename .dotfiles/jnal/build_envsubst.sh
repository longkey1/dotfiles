#!/usr/bin/env zsh

envsubst '${HOME}' < ${LOCAL_CONFIG}/jnal/config.toml.dist > ${LOCAL_CONFIG}/jnal/config.toml
