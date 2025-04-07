#!/usr/bin/env zsh

BINARY="cloudflared"
REPOSITORY="cloudflare/cloudflared"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  if [ "${OS}" = "linux" ]; then
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/ --asset cloudflared-linux-amd64
  else
    ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
  fi
fi
