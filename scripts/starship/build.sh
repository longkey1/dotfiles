#!/usr/bin/env bash

REPOSITORY="starship/starship"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" = "linux" ]; then
  "${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/ --upgrade-only --asset linux-musl
else
  "${LOCAL_BIN}"/eget ${REPOSITORY} --to "${LOCAL_BIN}"/ --upgrade-only
fi

#
mkdir -p "${LOCAL_CONFIG}"/starship
[ ! -e "${LOCAL_CONFIG}"/starship/config.toml ] && "${LOCAL_BIN}"/starship preset pure-preset -o "${LOCAL_CONFIG}"/starship/config.toml || true
