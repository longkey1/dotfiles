#!/usr/bin/env zsh

BINARY="gcal"

rm -f ${LOCAL_BIN}/${BINARY}
rm -f ${LOCAL_CONFIG}/gcal/config.toml
rm -f ${LOCAL_CONFIG}/gcal/credentials.json
rm -f ${LOCAL_CONFIG}/zsh/functions/_gcal
