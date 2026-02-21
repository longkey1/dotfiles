#!/usr/bin/env zsh

REPOSITORY="cloudflare/cloudflared"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "${OS}" = "linux" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only --asset cloudflared-linux-amd64
else
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --upgrade-only
fi
