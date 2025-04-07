#!/usr/bin/env zsh

envsubst '${HOME}' < ${LOCAL_CONFIG}/godl/config.toml.dist > ${LOCAL_CONFIG}/godl/config.toml
