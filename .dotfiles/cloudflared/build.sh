#!/usr/bin/env zsh

BINARY="cloudflared"
REPOSITORY="cloudflare/cloudflared"

if [ ! -x "${LOCAL_BIN}/${BINARY}" ]; then
  ${LOCAL_BIN}/eget ${REPOSITORY} --to ${LOCAL_BIN}/
fi
