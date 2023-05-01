#!/usr/bin/env zsh

envsubst '${HOME}' < ${LOCAL_CONFIG}/tmpl/config.toml.dist > ${LOCAL_CONFIG}/tmpl/config.toml
