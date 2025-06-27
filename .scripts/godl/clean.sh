#!/usr/bin/env zsh

BINARY="godl"

rm -f ${LOCAL_BIN}/${BINARY}
#
rm -f ${LOCAL_CONFIG)}/godl/config.toml
find ${LOCAL_CONFIG)}godl/goroots -mindepth 1 -maxdepth 1 -type d | xargs rm -rf
rm -f ${LOCAL_CONFIG}/zsh/functions/_godl
