#!/usr/bin/env zsh

envsubst '${HOME}' < ${LOCAL_CONFIG}/gcal/config.toml.dist > ${LOCAL_CONFIG}/gcal/config.toml
